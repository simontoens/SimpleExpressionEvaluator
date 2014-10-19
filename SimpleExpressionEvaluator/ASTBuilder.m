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

- (Node *)build:(NSArray *)nodes
{
    for (int nodeIndex = 0; nodeIndex < [nodes count];)
    {
        Node *node = [nodes objectAtIndex:nodeIndex];
        
        if (node.token.type == [TokenType constant] || node.token.type == [TokenType identifier])
        {
            [_operandStack push:node];
            nodeIndex += 1;
        }
        else if (node.token.type == [TokenType openParen] || node.token.type == [TokenType closeParen])
        {
            if (node.token.type == [TokenType openParen])
            {
                [_operatorStack push:node];
                nodeIndex += 1;
            }
            else
            {
                if (((Node *)[_operatorStack peek]).token.type == [TokenType openParen])
                {
                    [_operatorStack pop];
                    nodeIndex += 1;
                }
                else
                {
                    [self reduce];
                }
            }
        }
        else if (node.token.type == [TokenType assign] || node.token.type == [TokenType op] || node.token.type == [TokenType func])
        {
            Node *previousNode = _operatorStack.empty ? nil : [_operatorStack peek];
            if (!previousNode || node.precedence > previousNode.precedence)
            {
                [_operatorStack push:node];
                nodeIndex += 1;
            }
            else
            {
                if ([self isRightAssociative:node previousNode:previousNode])
                {
                    // for assignment we want right associativity: a=b=3 -> a=(b=3)
                    // same for functions if previous operator is an op: 2+func(1) -> 2+(func(1))
                    // so don't reduce
                    // (need expression token type that encapsulates expression rules?)
                    [_operatorStack push:node];
                    nodeIndex += 1;
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
        }
    }
    
    while (!_operatorStack.empty)
    {
        [self reduce];
    }
    
    return [_operandStack pop];
}

- (BOOL)isRightAssociative:(Node *)currentNode previousNode:(Node *)previousNode
{
    return
        (currentNode.token.type == [TokenType assign] && previousNode.token.type == [TokenType assign]) ||
        (currentNode.token.type == [TokenType func] && previousNode.token.type == [TokenType op]);
}

- (void)reduce
{
    Node *root = [_operatorStack pop];
    root.right = [_operandStack pop];
    if (root.numArgs > 1) { // fixme
        root.left = [_operandStack pop];
    }
    [_operandStack push:root];
}

@end