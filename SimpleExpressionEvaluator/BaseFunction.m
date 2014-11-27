//
//  BaseFunction.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/27/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import "BaseFunction.h"

@interface BaseFunction()
{
    @private
    NSArray *_arguments;
}

@end

@implementation BaseFunction

- (void)setArguments:(NSArray *)arguments
{
    _arguments = arguments;
}

- (NSArray *)getArguments
{
    return _arguments;
}

@end