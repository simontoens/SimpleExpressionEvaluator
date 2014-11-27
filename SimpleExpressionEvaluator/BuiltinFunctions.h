//
//  BuiltinFunctions.h
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/27/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Function.h"

@interface BuiltinFunctions : NSObject

- (id<Function>)getFunction:(NSString *)name;

@end