//
//  Node.h
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/27/13.
//  Copyright (c) 2013 Simon Toens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TokenType.h"

@interface Node : NSObject

- (NSString *)prefix;

@property (nonatomic, strong) NSString *value;
@property (nonatomic, assign) TokenType *type;
@property (nonatomic, assign) NSUInteger precedence;

@property (nonatomic, strong) Node *left;
@property (nonatomic, strong) Node *right;

@end