//
//  DivFunction.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/30/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import "Divide.h"

@implementation Divide

- (NSArray *)getNames
{
    return @[@"div", @"/"];
}

- (NSUInteger)hook_run:(NSUInteger)arg1 arg2:(NSUInteger)arg2
{
    return arg1 / arg2;
}

@end