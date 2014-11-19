//
//  Lexer.h
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 10/18/14 at the St. Regis on Kauai.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import "CharacterSets.h"
#import "Lexer.h"
#import "Node.h"
#import "NodeType.h"
#import "Token.h"

@implementation Lexer

+ (void)initialize
{
    [CharacterSets class];
}

- (NSArray *)lex:(NSArray *)tokens
{
    NSMutableArray *nodes = [[NSMutableArray alloc] initWithCapacity:[tokens count]];
    for (NSUInteger i = 0; i < [tokens count]; i++)
    {
        Token *token = [tokens objectAtIndex:i];
        
        if (token.type == [TokenType argSep])
        {
            // , -> )(   foo(1, 2, 3) -> foo(1)(2)(3)
            [nodes addObject:[self getNodeForToken:[Token tokenWithType:[TokenType closeParen]]]];
            [nodes addObject:[self getNodeForToken:[Token tokenWithType:[TokenType openParen]]]];
        }
        else
        {
            Node *node = [self getNodeForToken:token];
            node.type = [self getNodeType:i allTokens:tokens];
            [nodes addObject:node];
        }
    }
    return nodes;
}

- (Node *)getNodeForToken:(Token *)token
{
    Node *node = [[Node alloc] init];
    node.token = token;
    node.precedence = [self getPrecedence:token];
    return node;
}

- (NodeType *)getNodeType:(NSUInteger)currentTokenIndex allTokens:(NSArray *)tokens
{
    Token *token = [tokens objectAtIndex:currentTokenIndex];
    if (token.type == [TokenType identifier])
    {
        if ([self nextTokenType:currentTokenIndex allTokens:tokens] == [TokenType openParen])
        {
            return [NodeType func];
        }
    }
    return nil;
}

- (NSUInteger)getPrecedence:(Token *)token
{
    if (token.type == [TokenType assign] || token.type == [TokenType constant] || token.type == [TokenType identifier])
    {
        return 1;
    }
    if (token.type == [TokenType op])
    {
        return [token matchesCharacterSet:kBinaryOperatorLowerPrecedenceCharacterSet] ? 2 : 3;
    }
    if (token.type == [TokenType openParen])
    {
        return 0;
    }
    if (token.type == [TokenType closeParen])
    {
        return 10;
    }
    return -1;
}

- (TokenType *)nextTokenType:(NSUInteger)currentTokenIndex allTokens:(NSArray *)tokens
{
    return currentTokenIndex < [tokens count] - 1 ? ((Token *)[tokens objectAtIndex:currentTokenIndex + 1]).type : nil;
}

- (Node *)nextNode:(NSUInteger)currentNodeIndex allNodes:(NSArray *)nodes
{
    return currentNodeIndex < [nodes count] - 1 ? [nodes objectAtIndex:currentNodeIndex + 1] : nil;
}

@end