//
//  Token.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 4/30/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import "CharacterSets.h"
#import "Preconditions.h"
#import "Token.h"

@implementation Token

+ (instancetype)tokenWithValue:(NSString *)value
{
    return [[Token alloc] initWithValue:value];
}

+ (instancetype)tokenWithValue:(NSString *)value type:(TokenType *)type
{
    return [[Token alloc] initWithValue:value type:type];
}

- (instancetype)initWithValue:(NSString *)value
{
    return [self initWithValue:value type:[self getTokenType:value]];
}

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

- (TokenType *)getTokenType:(NSString *)tokenValue
{
    if ([self value:tokenValue matchesCharacterSet:[NSCharacterSet decimalDigitCharacterSet]])
    {
        return [TokenType constant];
    }
    if ([self value:tokenValue matchesCharacterSet:kBinaryOperatorCharacterSet])
    {
        return [TokenType op];
    }
    if ([self value:tokenValue matchesCharacterSet:kOpenParenCharacterSet])
    {
        return [TokenType openParen];
    }
    if ([self value:tokenValue matchesCharacterSet:kCloseParenCharacterSet])
    {
        return [TokenType closeParen];
    }
    if ([self value:tokenValue matchesCharacterSet:kAssignmentCharacterSet])
    {
        return [TokenType assign];
    }
    if ([self value:tokenValue matchesCharacterSet:kIdentifierCharacterSet])
    {
        return [TokenType identifier];
    }
    if ([tokenValue length] > 1 &&
        [self value:[tokenValue substringToIndex:1] matchesCharacterSet:kBinaryOperatorLowerPrecedenceCharacterSet] &&
        [self value:[tokenValue substringFromIndex:1] matchesCharacterSet:[NSCharacterSet decimalDigitCharacterSet]])
    {
        return [TokenType constant];
    }
    [Preconditions fail:[NSString stringWithFormat:@"Unable to determine token type for token value: %@", tokenValue]];
    return nil;
}

- (BOOL)matchesCharacterSet:(NSCharacterSet *)characterSet
{
    return [self value:_value matchesCharacterSet:characterSet];
}

- (BOOL)value:(NSString *)value matchesCharacterSet:(NSCharacterSet *)characterSet
{
    for (int i = 0; i < [value length]; i++)
    {
        unichar c = [value characterAtIndex:i];
        if (![characterSet characterIsMember:c])
        {
            return NO;
        }
    }
    return YES;
}

@end