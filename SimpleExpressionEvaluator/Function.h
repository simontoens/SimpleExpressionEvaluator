//
//  Function.h
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/27/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Environment.h"

@protocol Function <NSObject>

- (NSArray *)getNames;

- (NSUInteger)getNumArguments;

- (NSString *)eval:(Environment *)environment arguments:(NSArray *)arguments;

@end