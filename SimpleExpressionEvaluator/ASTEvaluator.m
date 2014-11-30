//
//  ASTEvaluator.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/28/13.
//  Copyright (c) 2013 Simon Toens. All rights reserved.
//

#import "Assertion.h"
#import "ASTEvaluator.h"
#import "BuiltinFunctions.h"
#import "Node.h"
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
    if (node.token.type == [TokenType assign])
    {
        Node *lhs = [node.children objectAtIndex:0];
        Node *rhs = [self evaluateRecusively:[node.children objectAtIndex:1]];
        [_environment bind:rhs to:lhs];
        return rhs;
    }
    else if (node.function)
    {
        Node *lhs = [self evaluateRecusively:[node.children objectAtIndex:0]];
        Node *rhs = [self evaluateRecusively:[node.children objectAtIndex:1]];
        
        id<Function> function = [_builtins getFunction:node.token.value];
        if (!function)
        {
            @throw [IllegalStateAssertion withReason:[NSString stringWithFormat:@"Unable to resolve function for %@", node]];
        }
        NSString *result = [function eval:@[lhs.token.value, rhs.token.value]];
        return [Node nodeWithToken:[Token tokenWithValue:result type:[TokenType constant]]];
    }
    else if (node.token.type == [TokenType constant])
    {
        return node;
    }
    else if (node.token.type == [TokenType identifier])
    {
        Node *n = [_environment resolve:node];
        return n ? n : node; // resolve to self if undefined
    } else
    {
        @throw [IllegalStateAssertion withReason:[NSString stringWithFormat:@"Unable to evaluate Node: %@", node]];
    }
}

@end