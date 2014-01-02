//
//  Tokenizer.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/29/13.
//  Copyright (c) 2013 Simon Toens. All rights reserved.
//

#import "Node.h"
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
        NodeType nodeType = [self getNodeType:token];
        if (nodeType == kNodeTypeUnknown)
        {
            return nil; // error handling
        }
        Node *node = [[Node alloc] init];
        node.value = token;
        node.type = nodeType;
        node.precedence = [self getPrecedenceForToken:token ofType:nodeType];
        [nodes addObject:node];
    }
    return nodes;
}

- (NSArray *)split:(NSString *)expression
{
    NSMutableArray *tokens = [[NSMutableArray alloc] init];
    
    NSMutableString *currentToken = nil;
    
    for (int i = 0; i < [expression length]; i++)
    {
        unichar c = [expression characterAtIndex:i];
        
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
        NodeType previousTokenType = previousToken ? [self getNodeType:previousToken] : kNodeTypeUnknown;
        
        if ([kStartTokenCharacterSet characterIsMember:c] && previousTokenType != kNodeTypeConstant)
        {
            // 3-2  -> 3,-,2
            // 3+-2 -> 3, +, -2
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

- (NodeType)getNodeType:(NSString *)token
{
    if ([self token:token matchesCharacterSet:[NSCharacterSet decimalDigitCharacterSet]])
    {
        return kNodeTypeConstant;
    }
    if ([self token:token matchesCharacterSet:kBinaryOperatorCharacterSet])
    {
        return kNodeTypeBinaryOperator;
    }
    if ([self token:token matchesCharacterSet:kParensCharacterSet])
    {
        return kNodeTypeParen;
    }
    if ([self token:token matchesCharacterSet:kAssignmentCharacterSet])
    {
        return kNodeTypeAssignment;
    }
    if ([self token:token matchesCharacterSet:kIdentifierCharacterSet])
    {
        return kNodeTypeIdentifier;
    }
    if ([token length] > 1 &&
        [self token:[token substringToIndex:1] matchesCharacterSet:kBinaryOperatorLowerPrecedenceCharacterSet] &&
        [self token:[token substringFromIndex:1] matchesCharacterSet:[NSCharacterSet decimalDigitCharacterSet]])
    {
        // -1
        return kNodeTypeConstant;
    }
    
    return kNodeTypeUnknown;
}

- (NSUInteger)getPrecedenceForToken:(NSString *)token ofType:(NodeType)type
{
    switch (type)
    {
        case kNodeTypeAssignment:
        case kNodeTypeConstant:
        case kNodeTypeIdentifier:
            return 1;
        case kNodeTypeBinaryOperator:
            return [self token:token matchesCharacterSet:kBinaryOperatorLowerPrecedenceCharacterSet] ? 2: 3;
        case kNodeTypeParen:
            return [self token:token matchesCharacterSet:kLeftParen] ? 0 : 10;
        case kNodeTypeUnknown:
            [Preconditions fail:@"Unexpected: unkown node type"];
            return -1;
    }
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