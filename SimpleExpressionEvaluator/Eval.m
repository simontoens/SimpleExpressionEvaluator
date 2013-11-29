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
    Stack *evalStack = [[Stack alloc] init];
    for (Node *node in [ast nodesInPreorder])
    {
        [evalStack push:node];
    }
    
    while (evalStack.count > 1)
    {
        Node *op1 = [evalStack pop];
        Node *op2 = [evalStack pop];
        Node *operator = [evalStack pop];
        Node *result = [self compute:operator op1:op1 op2:op2];
        [evalStack push:result];
    }
    Node *result = [evalStack pop];
    return [result.value integerValue];
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
