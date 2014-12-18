//
//  BinOpNode.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 12/18/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import "CharacterSets.h"
#import "BinaryOperationNode.h"

@implementation BinaryOperationNode

+ (void)initialize
{
    [CharacterSets class];
}

- (BOOL)leftAssociative
{
    return YES;
}

- (NSUInteger)precedence
{
    return [self.token matchesCharacterSet:kBinaryOperatorHigherPrecedenceCharacterSet] ? 3 : 2;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@: %lu", [super description], self.precedence];
}

@end
