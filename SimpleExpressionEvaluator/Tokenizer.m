//
//  Tokenizer.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/29/13.
//  Copyright (c) 2013 Simon Toens. All rights reserved.
//

#import "Node.h"
#import "Token.h"
#import "Tokenizer.h"
#import "Preconditions.h"

@implementation Tokenizer

static NSCharacterSet *kLeftParen;
static NSCharacterSet *kRightParen;
static NSCharacterSet *kParensCharacterSet;

static NSCharacterSet *kBinaryOperatorLowerPrecedenceCharacterSet;
static NSCharacterSet *kBinaryOperatorHigherPrecedenceCharacterSet;
static NSCharacterSet *kBinaryOperatorCharacterSet;

static NSCharacterSet *kAssignmentCharacterSet;
static NSCharacterSet *kIdentifierCharacterSet;

static NSCharacterSet *kSeparatorCharacterSet;
static NSCharacterSet *kSingleCharacterTokenCharacterSet;
static NSCharacterSet *kStartTokenCharacterSet;

+ (void)initialize
{
    kLeftParen = [NSCharacterSet characterSetWithCharactersInString:@"("];
    kRightParen = [NSCharacterSet characterSetWithCharactersInString:@")"];
    NSMutableCharacterSet *s = [[NSMutableCharacterSet alloc] init];
    [s formUnionWithCharacterSet:kLeftParen];
    [s formUnionWithCharacterSet:kRightParen];
    kParensCharacterSet = s;
    
    kBinaryOperatorLowerPrecedenceCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"-+"];
    kBinaryOperatorHigherPrecedenceCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"*/"];
    kAssignmentCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"="];
    kIdentifierCharacterSet = [NSCharacterSet letterCharacterSet];
    
    s =[[NSMutableCharacterSet alloc] init];
    [s formUnionWithCharacterSet:kBinaryOperatorLowerPrecedenceCharacterSet];
    [s formUnionWithCharacterSet:kBinaryOperatorHigherPrecedenceCharacterSet];
    kBinaryOperatorCharacterSet = s;
    
    s = [[NSMutableCharacterSet alloc] init];
    [s formUnionWithCharacterSet:kParensCharacterSet];
    [s formUnionWithCharacterSet:kBinaryOperatorCharacterSet];
    [s formUnionWithCharacterSet:kAssignmentCharacterSet];
    kSingleCharacterTokenCharacterSet = s;
    
    s = [[NSMutableCharacterSet alloc] init];
    [s formUnionWithCharacterSet:kSingleCharacterTokenCharacterSet];
    [s formUnionWithCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    kSeparatorCharacterSet = s;
    
    s = [[NSMutableCharacterSet alloc] init];
    [s formUnionWithCharacterSet:kBinaryOperatorLowerPrecedenceCharacterSet];
    [s formUnionWithCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
    kStartTokenCharacterSet = s;
}

- (NSArray *)tokenize:(NSString *)expression
{
    NSMutableArray *nodes = [[NSMutableArray alloc] init];
    for (NSString *token in [self split:expression])
    {
        TokenType *tokenType = [self getTokenType:token];
        if (!tokenType)
        {
            // error handling
        }
        Node *node = [[Node alloc] init];
        node.value = token;
        node.type = tokenType;
        node.precedence = [self getPrecedenceForToken:token ofType:tokenType];
        node.numArgs = 2;
        [nodes addObject:node];
    }
    return nodes;
}

- (NSArray *)split:(NSString *)expr
{
    NSMutableArray *tokens = [[NSMutableArray alloc] init];
    
    NSMutableString *currentToken = nil;
    
    NSMutableString *expression = [NSMutableString stringWithString:expr];
    
    for (int position = 0; position < [expression length]; position++)
    {
        unichar c = [expression characterAtIndex:position];
        
        if ([kSeparatorCharacterSet characterIsMember:c])
        {
            if (currentToken)
            {
                [tokens addObject:currentToken];
                currentToken = nil;
            }
            if ([[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:c])
            {
                continue;
            }
        }
        
        if (!currentToken)
        {
            currentToken = [[NSMutableString alloc] init];
        }
        
        [currentToken appendString:[NSString stringWithFormat:@"%C", c]];
        
        NSString *previousToken = [tokens count] > 0 ? [tokens lastObject] : nil;
        TokenType *previousTokenType = previousToken ? [self getTokenType:previousToken] : nil;
        
        if ([kStartTokenCharacterSet characterIsMember:c] &&
            previousTokenType != [TokenType constant] && previousTokenType != [TokenType identifier])
        {
            // 3-2  -> 3,-,2
            // 3+-2 -> 3, +, -2
        }
        else if ([kLeftParen characterIsMember:c] && previousTokenType == [TokenType identifier])
        {
            // blah( -> assume func with single arg
            NSRange r = [expression rangeOfCharacterFromSet:kRightParen options:NSLiteralSearch
                                                      range:NSMakeRange(position, [expression length] - position)];
            [expression deleteCharactersInRange:r];
            
            // need to work with higher level data structure, ie a "Token" instead of an NSString,
            // the TokenType could be set right here
            currentToken = [NSMutableString stringWithFormat:@"%@(", previousToken];
            [tokens removeLastObject];
            
            [tokens addObject:currentToken];
            currentToken = nil;
        }
        else if ([kSingleCharacterTokenCharacterSet characterIsMember:c])
        {
            [tokens addObject:currentToken];
            currentToken = nil;
        }
    }
    
    if (currentToken)
    {
        [tokens addObject:currentToken];
    }
    
    return tokens;
}

- (TokenType *)getTokenType:(NSString *)token
{
    if ([self token:token matchesCharacterSet:[NSCharacterSet decimalDigitCharacterSet]])
    {
        return [TokenType constant];
    }
    if ([self token:token matchesCharacterSet:kBinaryOperatorCharacterSet])
    {
        return [TokenType op];
    }
    if ([self token:token matchesCharacterSet:kParensCharacterSet])
    {
        return [TokenType paren];
    }
    if ([self token:token matchesCharacterSet:kAssignmentCharacterSet])
    {
        return [TokenType assign];
    }
    if ([self token:token matchesCharacterSet:kIdentifierCharacterSet])
    {
        return [TokenType identifier];
    }
    if ([token length] > 1 &&
        [self token:[token substringToIndex:1] matchesCharacterSet:kBinaryOperatorLowerPrecedenceCharacterSet] &&
        [self token:[token substringFromIndex:1] matchesCharacterSet:[NSCharacterSet decimalDigitCharacterSet]])
    {
        return [TokenType constant];
    }
    
    return nil;
}

- (NSUInteger)getPrecedenceForToken:(NSString *)token ofType:(TokenType *)type
{
    if (type == [TokenType assign] || type == [TokenType constant] || type == [TokenType identifier])
    {
        return 1;
    }
    if (type == [TokenType func])
    {
        return 1;
    }
    if (type == [TokenType op])
    {
        return [self token:token matchesCharacterSet:kBinaryOperatorLowerPrecedenceCharacterSet] ? 2: 3;
    }
    if (type == [TokenType paren])
    {
        return [self token:token matchesCharacterSet:kLeftParen] ? 0 : 10;
    }
    return -1;
}

- (BOOL)token:(NSString *)token matchesCharacterSet:(NSCharacterSet *)charSet
{
    for (int i = 0; i < [token length]; i++)
    {
        unichar c = [token characterAtIndex:i];
        if (![charSet characterIsMember:c])
        {
            return NO;
        }
    }
    return YES;
}

@end
