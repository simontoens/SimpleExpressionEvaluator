//
//  ExpressionEvaluator.h
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/29/13.
//  Copyright (c) 2013 Simon Toens. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExpressionEvaluator : NSObject

- (NSInteger)evaluate:(NSString *)expression;

/**
 * Last evaluated expression in prefix notation.
 */
@property (nonatomic, strong, readonly) NSString *prefix;

@end
