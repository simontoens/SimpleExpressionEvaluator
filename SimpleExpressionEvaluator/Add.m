//
//  AddFunction.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/27/14 on the way from SFO to KIX.  Flight is fairly quiet.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import "Add.h"

@implementation Add

- (NSArray *)getNames
{
    return @[@"add", @"+"];
}

- (NSUInteger)hook_run:(NSUInteger)arg1 arg2:(NSUInteger)arg2
{
    return arg1 + arg2;
}

@end