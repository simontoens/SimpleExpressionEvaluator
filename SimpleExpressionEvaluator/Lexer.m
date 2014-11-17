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
        Node *node = [self getNodeForToken:token];
        node.type = [self getNodeType:i allTokens:tokens];
        [nodes addObject:node];
    }
    return [self postProcessNodes:nodes];
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

/**
 * Replaces , with () around args.  
 * Split this up into a chain of post processors if this needs to do anything else.
 */
- (NSArray *)postProcessNodes:(NSArray *)nodes
{
    NSMutableArray *newNodes = [[NSMutableArray alloc] initWithCapacity:[nodes count] + 40]; // size ??
    BOOL functionWithArgs = NO;
    for (NSUInteger i = 0; i < [nodes count]; i++)
    {
        Node *node = [nodes objectAtIndex:i];
        Node *potentialArg = [self nextNode:i + 1 allNodes:nodes];
        if (functionWithArgs)
        {
            if (node.groupStart)
            {
                // func def starts with '(', leave it and close it after first arg
            }
            else if (node.token.type == [TokenType argSep])
            {
                [newNodes addObject:[self getNodeForToken:[Token tokenWithType:[TokenType closeParen]]]];
                if (((Node *)[self nextNode:i allNodes:nodes]).argument)
                {
                    // there's another arg - add another start group
                    [newNodes addObject:[self getNodeForToken:[Token tokenWithType:[TokenType openParen]]]];
                }
                continue;
            }
            if (node.groupEnd)
            {
                // func def ends with ')', it closes the '(' of the last arg.
                functionWithArgs = NO;
            }
        }
        else if (node.function && potentialArg.argument)
        {
            functionWithArgs = YES;
        }
        
        [newNodes addObject:node];
    }
    return newNodes;
}

- (TokenType *)nextTokenType:(NSUInteger)currentTokenIndex allTokens:(NSArray *)tokens
{
    return currentTokenIndex < [tokens count] - 1 ? ((Token *)[tokens objectAtIndex:currentTokenIndex + 1]).type : nil;
}

- (Node *)nextNode:(NSUInteger)currentNodeIndex allNodes:(NSArray *)nodes
{
    return currentNodeIndex < [nodes count] - 1 ? [nodes objectAtIndex:currentNodeIndex + 1] : nil;
}

- (Node *)previousNode:(NSUInteger)currentNodeIndex allNodes:(NSArray *)nodes
{
    return currentNodeIndex == 0 ? nil : [nodes objectAtIndex:currentNodeIndex - 1];
}

@end