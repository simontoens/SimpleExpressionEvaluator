//
//  InvalidTokenException.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 1/12/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import "InvalidTokenException.h"

@implementation InvalidTokenException

- (instancetype)initWithInvalidNode:(Node *)node atPosition:(NSUInteger)position
{
    if (self = [super initWithName:@"InvalidTokenException"
                            reason:[NSString stringWithFormat:@"Invalid token \"%@\" at %lu", node, (unsigned long)position]
                          userInfo:nil])
    {
        _node = node;
        _position = position;
    }
    return self;
}

@end
