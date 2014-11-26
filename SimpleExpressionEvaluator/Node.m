//
//  Node.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/27/13.
//  Copyright (c) 2013 Simon Toens. All rights reserved.
//

#import "CharacterSets.h"
#import "Node.h"

@implementation Node

@dynamic precedence;
@dynamic variable, function, group, groupStart, groupEnd;


+ (Node *)nodeWithToken:(Token *)token
{
    return [Node nodeWithToken:token nodeType:nil];
}

+ (Node *)nodeWithToken:(Token *)token nodeType:(NodeType *)nodeType
{
    Node *n = [[Node alloc] init];
    n.token = token;
    n.type = nodeType;
    return n;
}

- (NSArray *)preorder
{
    NSMutableArray *nodes = [[NSMutableArray alloc] init];
    [self preorder:self collectInto:nodes];
    return nodes;
}

- (void)preorder:(Node *)node collectInto:(NSMutableArray *)nodes
{
    [nodes addObject:node];
    if (node.left)
    {
        [self preorder:node.left collectInto:nodes];
    }
    if (node.right)
    {
        [self preorder:node.right collectInto:nodes];
    }
}

- (NSString *)prefix
{
    NSMutableString *s = [[NSMutableString alloc] init];
    [self prefix:self string:s];
    return s;
}

- (void)prefix:(Node *)node string:(NSMutableString *)string
{
    if (!node.left && !node.right)
    {
        [string appendString:@" "];
        [string appendString:node.token.value];
    }
    else
    {
        if (self != node)
        {
            [string appendString:@" "];            
        }
        [string appendString:@"("];
        [string appendString:node.token.value];
        if (node.left)
        {
            [self prefix:node.left string:string];
        }
        if (node.right)
        {
            [self prefix:node.right string:string];
        }
        [string appendString:@")"];
    }
}

- (BOOL)rightAssociative:(Node *)previousNode
{
    return _token.type == [TokenType assign] && previousNode.token.type == [TokenType assign];
}

- (NSString *)description
{
    return self.token.value;
}

- (NSUInteger)precedence
{
    if (_type == [NodeType func])
    {
        return 5;
    }
    if (_token.type == [TokenType assign] || _token.type == [TokenType constant] || _token.type == [TokenType identifier])
    {
        return 1;
    }
    if (_token.type == [TokenType op])
    {
        return [_token matchesCharacterSet:kBinaryOperatorLowerPrecedenceCharacterSet] ? 2 : 3;
    }
    if (_token.type == [TokenType openParen])
    {
        return 0;
    }
    if (_token.type == [TokenType closeParen])
    {
        return 10;
    }
    return -1;
}

- (BOOL)variable
{
    return _token.type == [TokenType identifier] && _type != [NodeType func];
}

- (BOOL)function
{
    return _token.type == [TokenType op] || _token.type == [TokenType assign] || _type == [NodeType func];
}

- (BOOL)group
{
    return self.groupStart || self.groupEnd;
}

- (BOOL)groupStart
{
    return _token.type == [TokenType openParen];
}

- (BOOL)groupEnd
{
    return _token.type == [TokenType closeParen];
}

- (BOOL)argument
{
    return self.variable || _token.type == [TokenType constant];
}

@end