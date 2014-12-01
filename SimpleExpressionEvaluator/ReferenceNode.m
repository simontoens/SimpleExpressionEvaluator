//
//  Reference.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 12/1/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import "ReferenceNode.h"

@implementation ReferenceNode

- (Node *)eval:(Environment *)environment
{
    Node *n = [environment resolve:self];
    return n ? n : self; // resolve to self if undefined
}

@end