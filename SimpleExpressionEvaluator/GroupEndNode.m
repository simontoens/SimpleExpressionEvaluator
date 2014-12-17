//
//  GroupEndNode.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 12/17/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import "GroupEndNode.h"

@implementation GroupEndNode

- (BOOL)group
{
    return YES;
}

- (BOOL)groupEnd
{
    return YES;
}

@end