//
//  Node.h
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/27/13.
//  Copyright (c) 2013 Simon Toens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Environment.h"
#import "NodeType.h"
#import "Token.h"

/**
 * Abstract base class of node hierarchy.
 */
@interface Node : NSObject

+ (Node *)nodeWithToken:(Token *)token;
+ (Node *)nodeWithToken:(Token *)token nodeType:(NodeType *)nodeType;

- (instancetype)init __unavailable;

- (instancetype)initWithToken:(Token *)token;

- (Node *)eval:(Environment *)environment;

/**
 * Returns a String representation of a 'prefix' traversal with this Node as the root.
 */
- (NSString *)prefix;

@property (nonatomic, strong, readonly) Token *token;
@property (nonatomic, strong) NodeType *type;

@property (nonatomic, strong) NSArray *children;

/**
 * Type attributes
 */

@property (nonatomic, assign, readonly) BOOL argument;
@property (nonatomic, assign, readonly) BOOL function;
@property (nonatomic, assign, readonly) BOOL group;
@property (nonatomic, assign, readonly) BOOL groupStart;
@property (nonatomic, assign, readonly) BOOL groupEnd;

@end