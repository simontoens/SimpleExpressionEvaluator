//
//  Node.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/27/13.
//  Copyright (c) 2013 Simon Toens. All rights reserved.
//

#import "Node.h"

@implementation Node

- (id)initWithValue:(NSString *)value nodeType:(NodeType)nodeType precedence:(NSUInteger)precedence
{
    if (self = [super init])
    {
        _value = value;
        _nodeType = nodeType;
        _precedence = precedence;
    }
    return self;
}

- (NSArray *)nodesInPreorder
{
    NSMutableArray *nodes = [[NSMutableArray alloc] init];
    [self preorder:self collectInto:nodes];
    return nodes;
}

- (NSArray *)nodesInPostorder
{
    NSMutableArray *nodes = [[NSMutableArray alloc] init];
    [self postorder:self collectInto:nodes];
    return nodes;
}

- (void)preorder:(Node *)node collectInto:(NSMutableArray *)nodes
{
    [nodes addObject:node];
    if (node.leftNode)
    {
        [self preorder:node.leftNode collectInto:nodes];
    }
    if (node.rightNode)
    {
        [self preorder:node.rightNode collectInto:nodes];
    }
}

- (void)postorder:(Node *)node collectInto:(NSMutableArray *)nodes
{
    if (node.leftNode)
    {
        [self preorder:node.leftNode collectInto:nodes];
    }
    if (node.rightNode)
    {
        [self preorder:node.rightNode collectInto:nodes];
    }
    [nodes addObject:node];
}

- (NSString *)description
{
    return self.value;
}

@end