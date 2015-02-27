//
//  BinOpNode.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 12/18/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import "Preconditions.h"
#import "CharacterSets.h"
#import "BinaryOperationNode.h"

@implementation BinaryOperationNode
{
    @private
    unichar _operator;
}

+ (void)initialize
{
    [CharacterSets class];
}

- (instancetype)initWithValue:(NSString *)value functionDefinitions:(BuiltinFunctions *)builtins
{
    [Preconditions assert:[value length] == 1 message:@"Expected token value to be a single character"];
    
    if (self = [super initWithValue:value functionDefinitions:builtins])
    {
        _operator = [value characterAtIndex:0];
    }
    return self;
}

- (BOOL)leftAssociative
{
    return YES;
}

- (NSUInteger)precedence
{
    return [kBinaryOperatorHigherPrecedenceCharacterSet characterIsMember:_operator] ? 3 : 2;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"'%@' p:ch%lu", [super description], self.precedence];
}

@end
