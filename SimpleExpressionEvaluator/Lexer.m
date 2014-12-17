//
//  Lexer.h
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 10/18/14 at the St. Regis on Kauai.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import "Assertion.h"
#import "AssignmentNode.h"
#import "BuiltinFunctions.h"
#import "ConstantNode.h"
#import "FunctionNode.h"
#import "GroupEndNode.h"
#import "GroupStartNode.h"
#import "Lexer.h"
#import "Node.h"
#import "NodeType.h"
#import "ReferenceNode.h"
#import "Token.h"

@interface Lexer()
{
    @private
    BuiltinFunctions *_builtins;
}
@end;

@implementation Lexer

- (instancetype)init
{
    if (self = [super init])
    {
        _builtins = [[BuiltinFunctions alloc] init];
    }
    return self;
}

- (NSArray *)lex:(NSArray *)tokens
{
    NSMutableArray *nodes = [[NSMutableArray alloc] initWithCapacity:[tokens count]];
    for (NSUInteger i = 0; i < [tokens count]; i++)
    {
        id n = [self getNodesForTokenAt:i allTokens:tokens];
        if ([n isKindOfClass:[Node class]])
        {
            [nodes addObject:n];
        }
        else
        {
            [nodes addObjectsFromArray:n];
        }
    }
    return nodes;
}

- (BOOL)isFunction:(NSUInteger)currentTokenIndex allTokens:(NSArray *)tokens
{
    Token *token = [tokens objectAtIndex:currentTokenIndex];
    
    if (token.type == [TokenType op])
    {
        return YES;
    }
    
    if (token.type == [TokenType identifier])
    {
        if ([self nextTokenType:currentTokenIndex allTokens:tokens] == [TokenType openParen])
        {
            return YES;
        }
    }
    return NO;
}

- (TokenType *)nextTokenType:(NSUInteger)currentTokenIndex allTokens:(NSArray *)tokens
{
    return currentTokenIndex < [tokens count] - 1 ? ((Token *)[tokens objectAtIndex:currentTokenIndex + 1]).type : nil;
}

/**
 * Returns either single Node instance or an NSArray of many nodes.
 */
- (id)getNodesForTokenAt:(NSUInteger)currentTokenIndex allTokens:(NSArray *)allTokens
{
    Token *token = [allTokens objectAtIndex:currentTokenIndex];
    if ([self isFunction:currentTokenIndex allTokens:allTokens])
    {
        return [[FunctionNode alloc] initWithToken:token functionDefinitions:_builtins];
    }
    else if (token.type == [TokenType constant])
    {
        return [[ConstantNode alloc] initWithToken:token];
    }
    else if (token.type == [TokenType openParen])
    {
        return [[GroupStartNode alloc] initWithToken:token];
    }
    else if (token.type == [TokenType closeParen])
    {
        return [[GroupEndNode alloc] initWithToken:token];
    }
    else if (token.type == [TokenType argSep])
    {
        // , -> () as in foo(1, 2*3+5) -> foo(1)(2*3+5)
        // this simplifies ast building at this point - function args are no different than bin op args
        return @[[[GroupEndNode alloc] initWithToken:[Token tokenWithType:[TokenType closeParen]]],
                 [[GroupStartNode alloc] initWithToken:[Token tokenWithType:[TokenType openParen]]]];
    }
    else if (token.type == [TokenType assign])
    {
        return [[AssignmentNode alloc] initWithToken:token];
    }
    else if (token.type == [TokenType identifier])
    {
        return [[ReferenceNode alloc] initWithToken:token];
    }
    else
    {
        @throw [IllegalStateAssertion withReason:[NSString stringWithFormat:@"No node mapping for token %@", token]];
    }
}

@end