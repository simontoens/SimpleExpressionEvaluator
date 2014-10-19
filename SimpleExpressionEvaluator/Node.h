//
//  Node.h
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/27/13.
//  Copyright (c) 2013 Simon Toens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NodeType.h"
#import "Token.h"

@interface Node : NSObject

- (NSString *)prefix;

@property (nonatomic, strong) Token *token;
@property (nonatomic, assign) NSUInteger precedence;
@property (nonatomic, strong) NodeType *type;

@property (nonatomic, strong) Node *left;
@property (nonatomic, strong) Node *right;

@end