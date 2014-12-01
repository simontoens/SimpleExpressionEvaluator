//
//  BinOpFunction.h
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/30/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Function.h"

/**
 * Abstract base class for functions that take 2 numerical arguments.
 */
@interface BinOpFunction : NSObject <Function>

- (NSUInteger)hook_run:(NSUInteger)arg1 arg2:(NSUInteger)arg2;

@end
