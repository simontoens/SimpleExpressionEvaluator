//
//  GroupEndNode.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 12/17/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import "GroupEndNode.h"

@implementation GroupEndNode

+ (GroupEndNode *)groupEnd
{
    return [[GroupEndNode alloc] initWithValue:@"]"];
}

- (BOOL)group
{
    return YES;
}

- (BOOL)groupEnd
{
    return YES;
}

@end