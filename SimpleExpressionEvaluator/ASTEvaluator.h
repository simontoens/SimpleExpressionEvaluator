//
//  ASTEvaluator.h
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/28/13.
//  Copyright (c) 2013 Simon Toens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Environment.h"
#import "Node.h"

@interface ASTEvaluator : NSObject

- (instancetype)init;
- (instancetype)initWithEnvironment:(Environment *)environment;

- (NSInteger)evaluate:(Node *)ast;

@end