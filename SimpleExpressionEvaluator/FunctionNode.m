//
//  FunctionNode.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/30/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import "Assertion.h"
#import "ConstantNode.h"
#import "FunctionNode.h"

@interface FunctionNode()
{
    @private
    BuiltinFunctions *_builtins;
}
@end

@implementation FunctionNode

- (instancetype)initWithValue:(NSString *)value functionDefinitions:(BuiltinFunctions *)builtins
{
    if (self = [super initWithValue:value])
    {
        _builtins = builtins;
    }
    return self;
}

- (Node *)eval:(Environment *)environment
{
    Node *lhs = [[self.children objectAtIndex:0] eval:environment];
    Node *rhs = [[self.children objectAtIndex:1] eval:environment];
    
    id<Function> function = [_builtins getFunction:self.value];
    if (!function)
    {
        @throw [IllegalStateAssertion withReason:[NSString stringWithFormat:@"Unable to resolve function for %@", self]];
    }
    NSString *result = [function run:@[lhs.value, rhs.value]];
    return [[ConstantNode alloc] initWithValue:result];
}

- (BOOL)function
{
    return YES;
}

@end