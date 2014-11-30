//
//  BuiltinFunctions.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/27/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import "AddFunction.h"
#import "BuiltinFunctions.h"
#import "DivFunction.h"
#import "Preconditions.h"
#import "MultFunction.h"
#import "SubFunction.h"

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
        
        [self registerFunction:[[AddFunction alloc] init]];
        [self registerFunction:[[DivFunction alloc] init]];
        [self registerFunction:[[MultFunction alloc] init]];
        [self registerFunction:[[SubFunction alloc] init]];
    }
    return self;
}

- (id<Function>)getFunction:(NSString *)name
{
    [Preconditions assertNotNil:name];
    return [_nameToFunctionInstance objectForKey:[self normalizeFunctionName:name]];
}

- (void)registerFunction:(id<Function>) function
{
    for (NSString *name in [function getNames])
    {
        [_nameToFunctionInstance setObject:function forKey:[self normalizeFunctionName:name]];
    }
}

- (NSString *)normalizeFunctionName:(NSString *)name
{
    return [name lowercaseString];
}

@end