//
//  BuiltinFunctions.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/27/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import "AddFunction.h"
#import "BuiltinFunctions.h"

@interface BuiltinFunctions()
{
    @private
    NSMutableDictionary *_nameToFunctionInstance;
}

@end

@implementation BuiltinFunctions

- (instancetype)init
{
    if (self = [super init])
    {
        _nameToFunctionInstance = [[NSMutableDictionary alloc] init];
        
        id<Function> add = [[AddFunction alloc] init];
        [_nameToFunctionInstance setObject:add forKey:[add getName]];
    }
    return self;
}

- (id<Function>)getFunction:(NSString *)name
{
    return [_nameToFunctionInstance objectForKey:name];
}

@end