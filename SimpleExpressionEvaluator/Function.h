//
//  Function.h
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/27/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Function <NSObject>

- (NSString *)getName;

- (NSUInteger)getNumArguments;

- (void)setArguments:(NSArray *)arguments;

- (NSString *)eval;

@end