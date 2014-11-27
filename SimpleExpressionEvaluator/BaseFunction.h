//
//  BaseFunction.h
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/27/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseFunction : NSObject

- (void)setArguments:(NSArray *)arguments;

- (NSArray *)getArguments;

@end