//
//  ASTBuilder.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/27/13.
//  Copyright (c) 2013 Simon Toens. All rights reserved.
//

#import "ASTBuilder.h"
#import "Node.h"
#import "Stack.h"

@interface ASTBuilder()
{
    @private
    Stack *_operatorStack;
    Stack *_operandStack;
}
@end

@implementation ASTBuilder

- (instancetype)init
{
    if (self = [super init])
    {
        _operandStack = [[Stack alloc] init];
        _operatorStack = [[Stack alloc] init];
    }
    return self;
}

- (Node *)build:(NSArray *)tokens
{
    for (int tokenIndex = 0; tokenIndex < [tokens count];)
    {
        Node *token = [tokens objectAtIndex:tokenIndex];
        if (token.nodeType == kOperandNode)
        {
            [_operandStack push:token];
            tokenIndex += 1;
        }
        else
        {
            if (_operatorStack.empty || token.precedence >= ((Node *)[_operatorStack peek]).precedence)
            {
                [_operatorStack push:token];
                tokenIndex += 1;
            }
            else
            {
                [self reduce];
            }
        }
    }
    
    while (!_operatorStack.empty)
    {
        [self reduce];
    }
    
    return [_operandStack pop];
}

- (void)reduce
{
    Node *root = [_operatorStack pop];
    root.rightNode = [_operandStack pop];
    root.leftNode = [_operandStack pop];
    [_operandStack push:root];
}

@end