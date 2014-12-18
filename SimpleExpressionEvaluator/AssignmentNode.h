//
//  Assignment.h
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 12/1/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BinaryOperationNode.h"

@interface AssignmentNode : BinaryOperationNode

+ (AssignmentNode *)assign;

@end
