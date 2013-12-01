//
//  Node.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/27/13.
//  Copyright (c) 2013 Simon Toens. All rights reserved.
//

#import "Node.h"

@implementation Node

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
        [string appendString:node.value];
    }
    else
    {
        if (self != node)
        {
            [string appendString:@" "];            
        }
        [string appendString:@"("];
        [string appendString:node.value];
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

- (NSString *)description
{
    return self.value;
}

@end