//
//  BinOpNode.h
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 12/18/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FunctionNode.h"

/**
 * A binary operation is a special type of function that takes 2 arguments: 2+1, 1-3, a=3 etc.
 */
@interface BinaryOperationNode : FunctionNode

/**
 * Decides the default precedence when multiple types of the same operation follow each other.  The default is left associative:
 * 100/2/2 is processed as ((100/2)/2), *not* (100/(2/2))
 */
@property (nonatomic, assign, readonly) BOOL leftAssociative;

@property (nonatomic, assign, readonly) NSUInteger precedence;

@end
