//
//  ASTBuilder.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/27/13.
//  Copyright (c) 2013 Simon Toens. All rights reserved.
//

#import "Assertion.h"
#import "ASTBuilder.h"
#import "BinaryOperationNode.h"
#import "Node.h"
#import "Stack.h"

@interface ASTBuilder()
{
    @private
    Stack *_argumentStack;
    Stack *_functionStack;
}
@end

@implementation ASTBuilder

- (instancetype)init
{
    if (self = [super init])
    {
        _argumentStack = [[Stack alloc] init];
        _functionStack = [[Stack alloc] init];
    }
    return self;
}

- (Node *)build:(NSArray *)nodes
{
    for (int nodeIndex = 0; nodeIndex < [nodes count];)
    {
        Node *node = [nodes objectAtIndex:nodeIndex];
        
        if (node.argument) // abc, 123
        {
            [_argumentStack push:node];
            nodeIndex += 1;
        }
        else if (node.group) // (, )
        {
            if (node.groupStart) // (
            {
                [_functionStack push:node];
                nodeIndex += 1;
            }
            else // )
            {
                Node *prevFuncNode = [_functionStack peek];
                if (prevFuncNode.groupStart)
                {
                    [_functionStack pop];
                    nodeIndex += 1;
                }
                else
                {
                    [self reduce];
                }
            }
        }
        else if (node.function)
        {
            Node *previousNode = [_functionStack peek];
            BOOL reduce = NO;
            
            if ([node isKindOfClass:[BinaryOperationNode class]])
            {
                BinaryOperationNode *binOpNode = (BinaryOperationNode *)node;
                if (previousNode && previousNode.function)
                {
                    if ([previousNode isKindOfClass:[BinaryOperationNode class]])
                    {
                        BinaryOperationNode *prevBinOpNode = (BinaryOperationNode *)previousNode;
                        if (prevBinOpNode.precedence == binOpNode.precedence)
                        {
                            reduce = binOpNode.leftAssociative;
                        }
                        else
                        {
                            reduce = prevBinOpNode.precedence > binOpNode.precedence;
                        }
                    }
                    else
                    {
                        reduce = YES;
                    }
                }
            }
            
            if (reduce)
            {
                // reduce if the current op's precedence is lower or equal to the precedence of the op on the stack
                // 2*3+3 => (2*3)+3
                // this also enforces left associativity of operators that have the same precedence:
                // (100/2)/2, not 100/(2/2)
                [self reduce];
                
            }
            else
            {
                [_functionStack push:node];
                nodeIndex += 1;
            }
        }
    }
    
    while (!_functionStack.empty)
    {
        [self reduce];
    }
    
    return [_argumentStack pop];
}

- (void)reduce
{
    Node *root = [_functionStack pop];
    Node *rhs = [_argumentStack pop];
    Node *lhs = [_argumentStack pop];
    root.children = @[lhs, rhs];
    [_argumentStack push:root];
}

@end