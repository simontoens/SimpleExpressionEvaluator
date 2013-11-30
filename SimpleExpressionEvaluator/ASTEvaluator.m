//
//  ASTEvaluator.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/28/13.
//  Copyright (c) 2013 Simon Toens. All rights reserved.
//

#import "ASTEvaluator.h"
#import "Node.h"
#import "Stack.h"

@implementation ASTEvaluator

- (NSInteger)evaluate:(Node *)ast
{
    Node *result = [self evaluateRecusively:ast];
    return [result.value integerValue];
}

- (Node *)evaluateRecusively:(Node *)node
{
    if (node.type == kNodeTypeConstant)
    {
        return node;
    }
    else
    {
        Node *lhs = [self evaluateRecusively:node.left];
        Node *rhs = [self evaluateRecusively:node.right];
        return [self compute:node arg1:lhs arg2:rhs];
    }
}

- (Node *)compute:(Node *)operator arg1:(Node *)arg1 arg2:(Node *)arg2
{
    int i1 = [arg1.value integerValue];
    int i2 = [arg2.value integerValue];

    int result = 0;
    
    char op = [operator.value characterAtIndex:0];
    
    switch (op)
    {
        case '+': result = i1 + i2; break;
        case '-': result = i1 - i2; break;
        case '*': result = i1 * i2; break;
        case '/': result = i1 / i2; break;
    }
    
    Node *node = [[Node alloc] init];
    node.type = kNodeTypeConstant;
    node.value = [NSString stringWithFormat:@"%i", result];
    return node;
}

@end
