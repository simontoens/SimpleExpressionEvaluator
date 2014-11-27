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

+ (Node *)nodeWithToken:(Token *)token;
+ (Node *)nodeWithToken:(Token *)token nodeType:(NodeType *)nodeType;

/**
 * Returns a String representation of a 'prefix' traversal with this Node as the root.
 */
- (NSString *)prefix;

@property (nonatomic, strong, readonly) Token *token;
@property (nonatomic, strong, readonly) NodeType *type;

@property (nonatomic, strong) Node *left;
@property (nonatomic, strong) Node *right;

@property (nonatomic, readonly) NSUInteger precedence;

/**
 * Type attributes
 */

@property (nonatomic, assign, readonly) BOOL variable;
@property (nonatomic, assign, readonly) BOOL function;
@property (nonatomic, assign, readonly) BOOL group;
@property (nonatomic, assign, readonly) BOOL groupStart;
@property (nonatomic, assign, readonly) BOOL groupEnd;
@property (nonatomic, assign, readonly) BOOL argument;

@end