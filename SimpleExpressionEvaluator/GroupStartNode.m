//
//  OpenParenNode.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 12/17/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import "GroupStartNode.h"

@implementation GroupStartNode

+ (GroupStartNode *)groupStart
{
    return [[GroupStartNode alloc] initWithValue:@"["];
}

- (BOOL)group
{
    return YES;
}

- (BOOL)groupStart
{
    return YES;
}

@end
