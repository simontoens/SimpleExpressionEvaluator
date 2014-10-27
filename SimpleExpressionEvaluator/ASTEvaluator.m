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
    return [result.token.value integerValue];
}

- (Node *)evaluateRecusively:(Node *)node
{
    if (node.type == [NodeType func])
    {
        Node *lhs = [self evaluateRecusively:node.left];
        Node *rhs = [self evaluateRecusively:node.right];
        Node *op = [[Node alloc] init];
        op.token = [Token tokenWithValue:@"+"]; // test function support as addition
        return [self compute:op arg1:lhs arg2:rhs];
    }
    else if (node.token.type == [TokenType constant])
    {
        return node;
    }
    else if (node.token.type == [TokenType identifier])
    {
        Node *n = [_environment resolve:node];
        return n ? n : node; // resolve to self if undefined
    }
    else if (node.token.type == [TokenType assign])
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
    NSString *resultString = nil;
    TokenType *resultType = nil;
    
    if (operator.token.type == [TokenType op])
    {
        NSInteger i1 = [arg1.token.value integerValue];
        NSInteger i2 = [arg2.token.value integerValue];

        NSInteger result = 0;
        
        char op = [operator.token.value characterAtIndex:0];
        
        switch (op)
        {
            case '+': result = i1 + i2; break;
            case '-': result = i1 - i2; break;
            case '*': result = i1 * i2; break;
            case '/': result = i1 / i2; break;
        }
        
        resultType = [TokenType constant];
        resultString = [NSString stringWithFormat:@"%li", (long)result];
    }
    else if (operator.token.type == [TokenType assign])
    {
        [_environment bind:arg2 to:arg1];
        resultType = [TokenType identifier];
        resultString = arg2.token.value;
    }
    Node* node = [[Node alloc] init];
    node.token = [[Token alloc] initWithValue:resultString type:resultType];
    return node;
}

@end