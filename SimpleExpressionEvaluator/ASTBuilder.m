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
        
        if (token.type == [TokenType constant] || token.type == [TokenType identifier])
        {
            [_operandStack push:token];
            tokenIndex += 1;
        }
        else if (token.type == [TokenType paren])
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
        }
        else if (token.type == [TokenType assign] || token.type == [TokenType op] || token.type == [TokenType func])
        {
            Node *previousToken = _operatorStack.empty ? nil : [_operatorStack peek];
            if (!previousToken || token.precedence > previousToken.precedence)
            {
                [_operatorStack push:token];
                tokenIndex += 1;
            }
            else
            {
                if ([self isRightAssociative:token previousToken:previousToken])
                {
                    // for assignment we want right associativity: a=b=3 -> a=(b=3)
                    // same for functions if previous operator is an op: 2+func(1) -> 2+(func(1))
                    // so don't reduce
                    // (need expression token type that encapsulates expression rules?)
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
        }
    }
    
    while (!_operatorStack.empty)
    {
        [self reduce];
    }
    
    return [_operandStack pop];
}

- (BOOL)isRightAssociative:(Node *)currentToken previousToken:(Node *)previousToken
{
    return
        (currentToken.type == [TokenType assign] && previousToken.type == [TokenType assign]) ||
        (currentToken.type == [TokenType func] && previousToken.type == [TokenType op]);
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