//
//  Token.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 4/30/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import "Preconditions.h"
#import "Token.h"

@implementation Token

- (instancetype)initWithValue:(NSString *)value type:(TokenType *)type
{
    [Preconditions assertNotNil:value];
    [Preconditions assertNotNil:type];
    if (self = [super init])
    {
        _value = value;
        _type = type;
    }
    return self;
}

- (NSUInteger)hash
{
    static NSUInteger prime = 31;
    NSUInteger result = prime + [_value hash];
    result = prime * result + [_type hash];
    return result;
}

- (BOOL)isEqual:(id)object
{
	if (self == object)
    {
        return YES;
    }
	if (![object isKindOfClass:[object class]])
    {
        return NO;
    }
    Token *other = (Token *)object;
    return [_value isEqualToString:other->_value] && _type == other->_type;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@", _value, _type];
}

@end