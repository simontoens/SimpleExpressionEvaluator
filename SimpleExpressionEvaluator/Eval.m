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
    Node *op1 = nil;
    Node *op2 = nil;
    
    for (Node *n in [ast nodesInPostorderRight])
    {
        NSLog(@"NODE %@", n);
        if (!op1)
        {
            op1 = n;
        }
        else if (!op2)
        {
            op2 = n;
        }
        else
        {
            op1 = [self compute:n op1:op1 op2:op2];
            op2 = nil;
        }
    }
    return [op1.value integerValue];
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
