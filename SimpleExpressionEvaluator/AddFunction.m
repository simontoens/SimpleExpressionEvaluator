//
//  AddFunction.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/27/14 on the way from SFO to KIX.  Flight is fairly quiet.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import "AddFunction.h"

@implementation AddFunction

- (NSArray *)getNames
{
    return @[@"add", @"+"];
}

- (NSUInteger)getNumArguments
{
    return 2;
}

- (NSString *)eval:(Environment *)environment arguments:(NSArray *)arguments
{
    NSUInteger i1 = [[arguments objectAtIndex:0] integerValue];
    NSUInteger i2 = [[arguments objectAtIndex:1] integerValue];
    return [NSString stringWithFormat:@"%li", (long)i1 + i2];
}

@end