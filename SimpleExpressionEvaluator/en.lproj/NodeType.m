//
//  NodeType.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 10/19/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import "NodeType.h"

@implementation NodeType
{
    NSString *_name;
}

static NodeType *kFunc;

+ (void)initialize
{
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{
        kFunc = [[NodeType alloc] initPrivate:@"Func"];
    });
}

+ (NodeType *)func
{
    return kFunc;
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