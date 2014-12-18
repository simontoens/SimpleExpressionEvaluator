//
//  FunctionNode.h
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/30/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BuiltinFunctions.h"
#import "Node.h"

@interface FunctionNode : Node

- (instancetype)init __unavailable;

- (instancetype)initWithValue:(NSString *)value functionDefinitions:(BuiltinFunctions *)builtins;

@end
