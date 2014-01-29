//
//  TokenType.h
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 1/12/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TokenType : NSObject

- (id)init __unavailable;

+ (TokenType *)assign;
+ (TokenType *)constant;
+ (TokenType *)identifier;
+ (TokenType *)op;
+ (TokenType *)paren;

@end
