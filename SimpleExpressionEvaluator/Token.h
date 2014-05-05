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

@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) TokenType *tokenType;

@end
