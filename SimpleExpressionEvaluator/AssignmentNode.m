//
//  Assignment.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 12/1/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import "AssignmentNode.h"

@implementation AssignmentNode

+ (AssignmentNode *)assign
{
    return [[super alloc] initWithValue:@"="];
}

- (Node *)eval:(Environment *)environment
{
    Node *lhs = [self.children objectAtIndex:0];
    Node *rhs = [[self.children objectAtIndex:1] eval:environment];
    [environment bind:rhs to:lhs];
    return rhs;
}

- (BOOL)leftAssociative
{
    // a=b=c is (a=(b=3)), *not* ((a=b)=3)
    return NO;
}

- (NSUInteger)precedence
{
    // lowest bin op precedence
    return 1;
}

@end
