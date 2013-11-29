//
//  Node.h
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/27/13.
//  Copyright (c) 2013 Simon Toens. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum NodeType {
    kOperatorNode, kOperandNode
} NodeType;

@interface Node : NSObject

- (id)initWithValue:(NSString *)value nodeType:(NodeType)nodeType precedence:(NSUInteger)precedence;

- (NSArray *)nodesInPreorder;
- (NSArray *)nodesInPostorder;

@property (nonatomic, strong) NSString *value;
@property (nonatomic, assign) NodeType nodeType;
@property (nonatomic, assign) NSUInteger precedence;

@property (nonatomic, strong) Node *leftNode;
@property (nonatomic, strong) Node *rightNode;

@end