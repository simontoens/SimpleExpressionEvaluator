//
//  GroupEndNode.h
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 12/17/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Node.h"

/**
 * Placeholder node that stands for the end of a grouping (ie ')').
 */
@interface GroupEndNode : Node

+ (GroupEndNode *)groupEnd;

@end
