//
//  Tokenizer.h
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/29/13.
//  Copyright (c) 2013 Simon Toens. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * The Tokenizer parses an NSString into a list of Tokens.
 */
@interface Tokenizer : NSObject

/**
 * Returns an array of Token instances.
 */
- (NSArray *)tokenize:(NSString *)expression;

@end
