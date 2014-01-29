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
{
    Environment *_environment;
}

- (instancetype)init
{
    return [self initWithEnvironment:[[Environment alloc] init]];
}

- (instancetype)initWithEnvironment:(Environment *)environment
{
    if (self = [super init])
    {
        _environment = environment;
    }
    return self;
}

- (NSInteger)evaluate:(Node *)ast
{
    Node *result = [self evaluateRecusively:ast];
    return [result.value integerValue];
}

- (Node *)evaluateRecusively:(Node *)node
{
    if (node.type == [TokenType constant])
    {
        return node;
    }
    else if (node.type == [TokenType identifier])
    {
        Node *n = [_environment resolve:node];
        return n ? n : node; // resolve to self if undefined
    }
    else if (node.type == [TokenType assign])
    {
        Node *lhs = node.left;
        Node *rhs = [self evaluateRecusively:node.right];
        return [self compute:node arg1:lhs arg2:rhs];
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
    Node *resultNode = [[Node alloc] init];
    resultNode.type = [TokenType constant];
    
    if (operator.type == [TokenType op])
    {
        NSInteger i1 = [arg1.value integerValue];
        NSInteger i2 = [arg2.value integerValue];

        NSInteger result = 0;
        
        char op = [operator.value characterAtIndex:0];
        
        switch (op)
        {
            case '+': result = i1 + i2; break;
            case '-': result = i1 - i2; break;
            case '*': result = i1 * i2; break;
            case '/': result = i1 / i2; break;
        }
        
        resultNode.value = [NSString stringWithFormat:@"%li", (long)result];
    }
    else if (operator.type == [TokenType assign])
    {
        [_environment bind:arg2 to:arg1];
        resultNode.value = arg2.value;
    }

    return resultNode;
}

@end
