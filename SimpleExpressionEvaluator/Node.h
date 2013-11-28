//
//  Node.h
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/27/13.
//  Copyright (c) 2013 Simon Toens. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum kNodeType {
    kOperator, kOperand
} kNodeType;

@interface Node : NSObject

@property (nonatomic, strong) NSString *value;
@property (nonatomic, assign) kNodeType nodeType;
@property (nonatomic, assign) NSUInteger precedence;

@property (nonatomic, strong) Node *leftNode;
@property (nonatomic, strong) Node *rightNode;

@end