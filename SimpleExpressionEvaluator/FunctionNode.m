//
//  FunctionNode.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/30/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import "Assertion.h"
#import "FunctionNode.h"

@interface FunctionNode()
{
    @private
    BuiltinFunctions *_builtins;
}
@end

@implementation FunctionNode

- (instancetype)initWithFunctionDefinitions:(BuiltinFunctions *)builtins
{
    if (self = [super init])
    {
        _builtins = builtins;
    }
    return self;
}

- (Node *)eval:(Environment *)environment
{
    Node *lhs = [[self.children objectAtIndex:0] eval:environment];
    Node *rhs = [[self.children objectAtIndex:1] eval:environment];
    
    id<Function> function = [_builtins getFunction:self.token.value];
    if (!function)
    {
        @throw [IllegalStateAssertion withReason:[NSString stringWithFormat:@"Unable to resolve function for %@", self]];
    }
    NSString *result = [function run:@[lhs.token.value, rhs.token.value]];
    return [Node nodeWithToken:[Token tokenWithValue:result type:[TokenType constant]]];
}

@end