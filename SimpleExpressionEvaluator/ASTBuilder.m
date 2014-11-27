//
//  ASTBuilder.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/27/13.
//  Copyright (c) 2013 Simon Toens. All rights reserved.
//

#import "ASTBuilder.h"
#import "CharacterSets.h"
#import "Node.h"
#import "NodeType.h"
#import "Stack.h"

@interface ASTBuilder()
{
    @private
    Stack *_argumentStack;
    Stack *_functionStack;
}
@end

@implementation ASTBuilder

+ (void)initialize
{
    [CharacterSets class];
}

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
            if (!previousNode || node.precedence > previousNode.precedence)
            {
                [_functionStack push:node];
                nodeIndex += 1;
            }
            else
            {
                if ([self rightAssociative:node previousNode:previousNode])
                {
                    // for ex, assignment is right associative: we want a=b=3 -> a=(b=3), not (a=b)=3 so don't reduce
                    [_functionStack push:node];
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
    root.childNodes = @[lhs, rhs];
    [_argumentStack push:root];
}

- (BOOL)rightAssociative:(Node *)currentNode previousNode:(Node *)previousNode
{
    return currentNode.token.type == [TokenType assign] && previousNode.token.type == [TokenType assign];
}

@end