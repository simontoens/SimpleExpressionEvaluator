//
//  SubFunction.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/30/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import "SubtractFunction.h"

@implementation SubtractFunction

- (NSArray *)getNames
{
    return @[@"sub", @"-"];
}

- (NSUInteger)hook_run:(NSUInteger)arg1 arg2:(NSUInteger)arg2
{
    return arg1 - arg2;
}

@end
