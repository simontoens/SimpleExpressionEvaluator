//
//  Environment.h
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 1/1/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Node.h"

@interface Environment : NSObject

- (void)bind:(Node *)value to:(Node *)ident;
- (Node *)resolve:(Node *)reference;

@end
