//
//  BinOpFunction.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/30/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import "Assertion.h"
#import "BinOpFunction.h"

@implementation BinOpFunction

- (NSUInteger)getNumArguments
{
    return 2;
}

- (NSString *)eval:(NSArray *)arguments
{
    NSUInteger i1 = [[arguments objectAtIndex:0] integerValue];
    NSUInteger i2 = [[arguments objectAtIndex:1] integerValue];
    return [NSString stringWithFormat:@"%li", (long)[self hook_eval:i1 arg2:i2]];
}

- (NSArray *)getNames
{
    @throw [AbstractMethodAssertion assertion];
}

- (NSUInteger)hook_eval:(NSUInteger)arg1 arg2:(NSUInteger)arg2
{
    @throw [AbstractMethodAssertion assertion];
}

@end
