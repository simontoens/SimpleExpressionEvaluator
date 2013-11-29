//
//  Node.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/27/13.
//  Copyright (c) 2013 Simon Toens. All rights reserved.
//

#import "Node.h"

@implementation Node

- (NSArray *)nodesInPreorder
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

- (NSString *)description
{
    return self.value;
}

@end