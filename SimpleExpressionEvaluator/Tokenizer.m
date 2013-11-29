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
    s =[[NSMutableCharacterSet alloc] init];
    [s formUnionWithCharacterSet:kBinaryOperatorLowerPrecedenceCharacterSet];
    [s formUnionWithCharacterSet:kBinaryOperatorHigherPrecedenceCharacterSet];
    kBinaryOperatorCharacterSet = s;
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
    for (NSString *token in [expression componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]])
    {
        if ([token length] > 0)
        {
            [tokens addObject:token];
        }
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
    return kNodeTypeUnknown;
}

- (NSUInteger)getPrecedenceForToken:(NSString *)token ofType:(NodeType)type
{
    switch (type)
    {
        case kNodeTypeConstant:
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
