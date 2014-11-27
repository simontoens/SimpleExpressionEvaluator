//
//  AddFunction.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/27/14 on the way from SFO to KIX.  Flight is fairly quiet.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import "AddFunction.h"

@implementation AddFunction

- (NSString *)getName
{
    return @"add";
}

- (NSUInteger)getNumArguments
{
    return 2;
}

- (NSString *)eval
{
    NSArray *args = [super getArguments];
    NSUInteger i1 = [[args objectAtIndex:0] integerValue];
    NSUInteger i2 = [[args objectAtIndex:1] integerValue];
    return [NSString stringWithFormat:@"%li", (long)i1 + i2];
}

@end