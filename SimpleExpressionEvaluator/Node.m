//
//  Node.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/27/13.
//  Copyright (c) 2013 Simon Toens. All rights reserved.
//

#import "Node.h"

@implementation Node

- (id)initWithValue:(NSString *)value nodeType:(NodeType)nodeType
{
    if (self = [super init])
    {
        _value = value;
        _type = nodeType;
        _precedence = [Node getPrecedenceForNodeType:nodeType value:value];
    }
    return self;
}

+ (NSUInteger)getPrecedenceForNodeType:(NodeType)nodeType value:(NSString *)value
{
    switch (nodeType)
    {
        case kNodeTypeConstant:
            return 1;
        case kNodeTypeBinaryOperator:
            if ([value isEqualToString:@"-"] || [value isEqualToString:@"+"])
            {
                return 2;
            }
            else
            {
                return 3;
            }
        case kNodeTypeParen:
            return [value isEqualToString:@"("] ? 0 : 10;
    }
}

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