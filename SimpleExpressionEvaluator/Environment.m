//
//  Environment.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 1/1/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import "Environment.h"

@implementation Environment
{
    NSMutableDictionary *_env;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _env = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (id)objectForKeyedSubscript:(id <NSCopying>)key
{
    return _env[key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key
{
    _env[key] = obj;
}

@end
