//
//  Eval.h
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/28/13.
//  Copyright (c) 2013 Simon Toens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Node.h"

@interface ASTEvaluator : NSObject

- (NSInteger)evaluate:(Node *)ast;

@end