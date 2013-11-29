//
//  Eval.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/28/13.
//  Copyright (c) 2013 Simon Toens. All rights reserved.
//

#import "Eval.h"
#import "Node.h"
#import "Stack.h"

@implementation Eval

- (NSInteger)evaluate:(Node *)ast
{
    Node *result = [self evaluateRecusively:ast];
    return [result.value integerValue];
}

- (Node *)evaluateRecusively:(Node *)node
{
    if (node.nodeType == kNodeTypeConstant)
    {
        return node;
    }
    else
    {
        Node *lhs = [self evaluateRecusively:node.leftNode];
        Node *rhs = [self evaluateRecusively:node.rightNode];
        return [self compute:node op1:lhs op2:rhs];
    }
}

- (Node *)compute:(Node *)operator op1:(Node *)op1 op2:(Node *)op2
{
    int i1 = [op1.value integerValue];
    int i2 = [op2.value integerValue];
    Node *result = [[Node alloc] init];
    if ([@"*" isEqualToString:operator.value])
    {
        result.value = [NSString stringWithFormat:@"%i", i1 * i2];
    }
    else
    {
        result.value = [NSString stringWithFormat:@"%i", i1 + i2];
    }
    return result;
}

@end
