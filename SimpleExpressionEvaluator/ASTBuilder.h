//
//  ASTBuilder.h
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/27/13.
//  Copyright (c) 2013 Simon Toens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Node.h"

@interface ASTBuilder : NSObject

- (Node *)build:(NSArray *)nodes;

@end