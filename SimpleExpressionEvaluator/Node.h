//
//  Node.h
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/27/13.
//  Copyright (c) 2013 Simon Toens. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum NodeType {
    kNodeTypeBinaryOperator,
    kNodeTypeConstant,
    kNodeTypeParen,
    kNodeTypeUnknown
} NodeType;

@interface Node : NSObject

- (NSArray *)nodesInPreorder;

@property (nonatomic, strong) NSString *value;
@property (nonatomic, assign) NodeType type;
@property (nonatomic, assign) NSUInteger precedence;

@property (nonatomic, strong) Node *left;
@property (nonatomic, strong) Node *right;

@end