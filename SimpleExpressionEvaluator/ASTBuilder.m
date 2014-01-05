//
//  ASTBuilder.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/27/13.
//  Copyright (c) 2013 Simon Toens. All rights reserved.
//

#import "ASTBuilder.h"
#import "Node.h"
#import "Preconditions.h"
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
        
        switch (token.type)
        {
            case kNodeTypeConstant:
            case kNodeTypeIdentifier:
            {
                [_operandStack push:token];
                tokenIndex += 1;
                break;
            }
            case kNodeTypeParen:
            {
                if ([token.value isEqualToString:@"("])
                {
                    [_operatorStack push:token];
                    tokenIndex += 1;
                }
                else
                {
                    if ([((Node *)[_operatorStack peek]).value isEqualToString:@"("])
                    {
                        [_operatorStack pop];
                        tokenIndex += 1;
                    }
                    else
                    {
                        [self reduce];
                    }
                }
                break;
            }
            case kNodeTypeAssignment:
            case kNodeTypeBinaryOperator:
            {
                Node *previousToken = _operatorStack.empty ? nil : [_operatorStack peek];
                if (!previousToken || token.precedence > previousToken.precedence)
                {
                    [_operatorStack push:token];
                    tokenIndex += 1;
                }
                else
                {
                    if (token.type == kNodeTypeAssignment && previousToken.type == kNodeTypeAssignment)
                    {
                        // for assignment we want right associativity: a=b=3 -> a=(b=3) so don't reduce
                        [_operatorStack push:token];
                        tokenIndex += 1;
                    }
                    else
                    {
                        // reduce if the current op's precedence is lower or equal to the precedence of the op on the stack
                        // 2*3+3 => (2*3)+3
                        // this also enforces left associativity of operators that have the same precedence:
                        // (100/2)/2, not 100/(2/2)
                        [self reduce];
                    }

                }
                break;
            }
            case kNodeTypeUnknown:
            {
                [Preconditions fail:@"Unexpected: unknown node type"];
                break;
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
    root.right = [_operandStack pop];
    root.left = [_operandStack pop];
    [_operandStack push:root];
}

@end