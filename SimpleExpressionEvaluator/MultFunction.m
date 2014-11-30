//
//  MultFunction.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/30/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import "MultFunction.h"

@implementation MultFunction

- (NSArray *)getNames
{
    return @[@"mult", @"*"];
}

- (NSUInteger)hook_eval:(NSUInteger)arg1 arg2:(NSUInteger)arg2
{
    return arg1 * arg2;
}

@end
