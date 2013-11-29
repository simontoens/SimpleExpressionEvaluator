//
//  Node.h
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/27/13.
//  Copyright (c) 2013 Simon Toens. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum NodeType {
    kNodeTypeBinaryOperator, kNodeTypeConstant, kNodeTypeParen
} NodeType;

@interface Node : NSObject

- (id)initWithValue:(NSString *)value nodeType:(NodeType)nodeType;

- (NSArray *)nodesInPreorder;

@property (nonatomic, strong) NSString *value;
@property (nonatomic, assign) NodeType nodeType;
@property (nonatomic, assign, readonly) NSUInteger precedence;

@property (nonatomic, strong) Node *leftNode;
@property (nonatomic, strong) Node *rightNode;

@end