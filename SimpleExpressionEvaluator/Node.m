//
//  Node.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/27/13.
//  Copyright (c) 2013 Simon Toens. All rights reserved.
//

#import "Assertion.h"
#import "Node.h"

@implementation Node

- (instancetype)initWithValue:(NSString *)value
{
    if (self = [super init])
    {
        _value = value;
    }
    return self;
}

- (Node *)eval:(Environment *)environment
{
    @throw [AbstractMethodAssertion forSelector:_cmd];
}

- (NSString *)prefix
{
    NSMutableString *s = [[NSMutableString alloc] init];
    [self prefix:self string:s];
    return s;
}

- (void)prefix:(Node *)node string:(NSMutableString *)string
{
    if ([string length] > 0)
    {
        [string appendString:@" "];
    }
    if (node.function)
    {
        [string appendString:@"("];
    }
    [string appendString:node->_value];
    if ([node.children count] >= 1)
    {
        [self prefix:[node.children objectAtIndex:0]  string:string];
    }
    if ([node.children count] >= 2)
    {
        [self prefix:[node.children objectAtIndex:1] string:string];
    }
    if (node.function)
    {
        [string appendString:@")"];
    }
}

- (NSString *)description
{
    return _value;
}

- (BOOL)argument
{
    return NO;
}

- (BOOL)function
{
    return NO;
}

- (BOOL)group
{
    return NO;
}

- (BOOL)groupStart
{
    return NO;
}

- (BOOL)groupEnd
{
    return NO;
}

@end