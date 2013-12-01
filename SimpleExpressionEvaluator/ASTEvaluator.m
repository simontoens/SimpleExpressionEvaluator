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

@interface ASTEvaluator()
{
    @private
    NSMutableDictionary *_environment;
}
@end

@implementation ASTEvaluator

- (id)init
{
    if (self = [super init])
    {
        _environment = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSInteger)evaluate:(Node *)ast
{
    Node *result = [self evaluateRecusively:ast];
    return [result.value integerValue];
}

- (Node *)evaluateRecusively:(Node *)node
{
    if (node.type == kNodeTypeConstant)
    {
        return node;
    }
    else if (node.type == kNodeTypeIdentifier)
    {
        Node *n = [self resolve:node];
        return n ? n : node; // resolve to self if undefined
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
    Node *resultNode = [[Node alloc] init];
    resultNode.type = kNodeTypeConstant;
    
    if (operator.type == kNodeTypeBinaryOperator)
    {
        int i1 = [arg1.value integerValue];
        int i2 = [arg2.value integerValue];

        int result = 0;
        
        char op = [operator.value characterAtIndex:0];
        
        switch (op)
        {
            case '+': result = i1 + i2; break;
            case '-': result = i1 - i2; break;
            case '*': result = i1 * i2; break;
            case '/': result = i1 / i2; break;
        }
        
        resultNode.value = [NSString stringWithFormat:@"%i", result];
    }
    else if (operator.type == kNodeTypeAssignment)
    {
        [self bind:arg2 to:arg1];
        resultNode.value = arg2.value;
    }

    return resultNode;
}

- (void)bind:(Node *)value to:(Node *)ident
{
    [_environment setObject:value forKey:ident.value];
}

- (Node *)resolve:(Node *)reference
{
    return [_environment objectForKey:reference.value];
}

@end
