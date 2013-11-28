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
@property (nonatomic, strong) Stack *operatorStack;
@property (nonatomic, strong) Stack *operandStack;
@end

@implementation ASTBuilder

- (instancetype)init
{
    if (self = [super init])
    {
        _operandStack = [[Stack alloc] init];
        _operandStack = [[Stack alloc] init];
    }
    return self;
}

- (Node *)build:(NSArray *)tokens
{
    for (Node *token in tokens)
    {
        if (token.nodeType == kOperandNode)
        {
            [_operandStack push:token];
        }
        else
        {
            if (_operatorStack.empty)
            {
                [_operatorStack push:token];
            }
            else
            {
                Node *top = [_operatorStack peek];
            }
            [_operatorStack push:token];
        }
    }
    return nil;
}


@end
