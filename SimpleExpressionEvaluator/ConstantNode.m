//
//  Constant.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/30/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import "ConstantNode.h"

@implementation ConstantNode

- (Node *)eval:(Environment *)environment
{
    return self;
}

- (BOOL)argument
{
    return YES;
}

@end
