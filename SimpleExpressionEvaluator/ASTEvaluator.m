//
//  ASTEvaluator.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/28/13.
//  Copyright (c) 2013 Simon Toens. All rights reserved.
//

#import "ASTEvaluator.h"
#import "BuiltinFunctions.h"
#import "Node.h"
#import "Preconditions.h"
#import "Stack.h"

@implementation ASTEvaluator
{
    Environment *_environment;
    BuiltinFunctions *_builtins;
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
        _builtins = [[BuiltinFunctions alloc] init];
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
        Node *lhs = [self evaluateRecusively:[node.childNodes objectAtIndex:0]];
        Node *rhs = [self evaluateRecusively:[node.childNodes objectAtIndex:1]];
        
        id<Function> function = [_builtins getFunction:node.token.value];
        if (!function)
        {
            [Preconditions fail:[NSString stringWithFormat:@"Unable to resolve function for %@", node]];
        }
        [function setArguments:@[lhs.token.value, rhs.token.value]];
        return [Node nodeWithToken:[Token tokenWithValue:[function eval] type:[TokenType constant]]];
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
        Node *lhs = [node.childNodes objectAtIndex:0];
        Node *rhs = [self evaluateRecusively:[node.childNodes objectAtIndex:1]];
        return [self compute:node arg1:lhs arg2:rhs];
    }
    else if (node.token.type == [TokenType op])        
    {
        Node *lhs = [self evaluateRecusively:[node.childNodes objectAtIndex:0]];
        Node *rhs = [self evaluateRecusively:[node.childNodes objectAtIndex:1]];
        return [self compute:node arg1:lhs arg2:rhs];
    } else
    {
        [Preconditions fail:[NSString stringWithFormat:@"Don't know how to evaluate node: %@", node]];
        return nil;
    }
}

- (Node *)compute:(Node *)operator arg1:(Node *)arg1 arg2:(Node *)arg2
{
    NSString *resultString = nil;
    
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
        
        resultString = [NSString stringWithFormat:@"%li", (long)result];
    }
    else if (operator.token.type == [TokenType assign])
    {
        [_environment bind:arg2 to:arg1];
        resultString = arg2.token.value;
    }
    return [Node nodeWithToken:[Token tokenWithValue:resultString type:[TokenType constant]]];
}

@end