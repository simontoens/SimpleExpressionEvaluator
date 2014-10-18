//
//  Lexer.h
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 10/18/14 at the St. Regis on Kauai.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * The lexer transforms a list of Tokens into a list of Nodes.
 */
@interface Lexer : NSObject

- (NSArray *)lex:(NSArray *)tokens;

@end