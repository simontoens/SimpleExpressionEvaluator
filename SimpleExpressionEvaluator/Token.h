//
//  Token.h
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 4/30/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TokenType.h"

@interface Token : NSObject

+ (instancetype)tokenWithValue:(NSString *)value;

- (instancetype)init __unavailable;
- (instancetype)initWithValue:(NSString *)value;
- (instancetype)initWithValue:(NSString *)value type:(TokenType *)type;

- (BOOL)matchesCharacterSet:(NSCharacterSet *)characterSet;

@property (nonatomic, strong, readonly) NSString *value;
@property (nonatomic, assign, readonly) TokenType *type;

@end