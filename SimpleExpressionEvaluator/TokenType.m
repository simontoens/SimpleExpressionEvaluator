//
//  TokenType.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 1/12/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import "TokenType.h"

@implementation TokenType
{
    NSString *_name;
}

static TokenType *kAssign;
static TokenType *kConstant;
static TokenType *kIdentifer;
static TokenType *kOp;
static TokenType *kOpenParen;
static TokenType *kCloseParen;
static TokenType *kArgSep;

+ (void)initialize
{
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{
        kAssign = [[TokenType alloc] initPrivate:@"Assign"];
        kConstant = [[TokenType alloc] initPrivate:@"Const"];
        kIdentifer = [[TokenType alloc] initPrivate:@"Ident"];
        kOp = [[TokenType alloc] initPrivate:@"Op"];
        kOpenParen = [[TokenType alloc] initPrivate:@"("];
        kCloseParen = [[TokenType alloc] initPrivate:@")"];
        kArgSep = [[TokenType alloc] initPrivate:@","];
    });
}

+ (TokenType *)assign
{
    return kAssign;
}

+ (TokenType *)constant
{
    return kConstant;
}

+ (TokenType *)identifier
{
    return kIdentifer;
}

+ (TokenType *)op
{
    return kOp;
}

+ (TokenType *)openParen
{
    return kOpenParen;
}

+ (TokenType *)closeParen
{
    return kCloseParen;
}

+ (TokenType *)argSep
{
    return kArgSep;
}

- (NSString *)description
{
    return _name;
}

- (id)initPrivate:(NSString *)name
{
    if (self = [super init])
    {
        _name = name;
    }
    return self;
}

@end