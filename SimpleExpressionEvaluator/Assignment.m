//
//  Assignment.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 12/1/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import "Assignment.h"

@implementation Assignment

- (Node *)eval:(Environment *)environment
{
    Node *lhs = [self.children objectAtIndex:0];
    Node *rhs = [[self.children objectAtIndex:1] eval:environment];
    [environment bind:rhs to:lhs];
    return rhs;
}

@end
