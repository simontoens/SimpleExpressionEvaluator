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
#import "Token.h"

@implementation Lexer

+ (void)initialize
{
    [CharacterSets class];
}

- (NSArray *)lex:(NSArray *)tokens
{
    NSMutableArray *nodes = [[NSMutableArray alloc] initWithCapacity:[tokens count]];
    for (Token *token in tokens)
    {
        Node *node = [[Node alloc] init];
        node.token = token;
        node.precedence = [self getPrecedenceForToken:token];
        node.numArgs = 2;
        [nodes addObject:node];
    }
    return nodes;
}

- (NSUInteger)getPrecedenceForToken:(Token *)token
{
    if (token.type == [TokenType assign] || token.type == [TokenType constant] || token.type == [TokenType identifier])
    {
        return 1;
    }
    if (token.type == [TokenType func])
    {
        return 1;
    }
    if (token.type == [TokenType op])
    {
        return [token matchesCharacterSet:kBinaryOperatorLowerPrecedenceCharacterSet] ? 2: 3;
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

@end