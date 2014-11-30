//
//  Function.h
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/27/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Function <NSObject>

- (NSArray *)getNames;

- (NSUInteger)getNumArguments;

- (NSString *)run:(NSArray *)arguments;

@end