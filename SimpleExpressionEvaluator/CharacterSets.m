//
//  CharacterSets.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 10/18/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import "CharacterSets.h"

@implementation CharacterSets

NSCharacterSet *kOpenParenCharacterSet;
NSCharacterSet *kCloseParenCharacterSet;

NSCharacterSet *kBinaryOperatorLowerPrecedenceCharacterSet;
NSCharacterSet *kBinaryOperatorHigherPrecedenceCharacterSet;
NSCharacterSet *kBinaryOperatorCharacterSet;

NSCharacterSet *kAssignmentCharacterSet;
NSCharacterSet *kIdentifierCharacterSet;
NSCharacterSet *kArgSeparatorCharacterSet;

NSCharacterSet *kSeparatorCharacterSet;
NSCharacterSet *kSingleCharacterTokenCharacterSet;
NSCharacterSet *kStartTokenCharacterSet;

+ (void)initialize
{
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{
        kOpenParenCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"("];
        kCloseParenCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@")"];
        
        kBinaryOperatorLowerPrecedenceCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"-+"];
        kBinaryOperatorHigherPrecedenceCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"*/"];
        kAssignmentCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"="];
        kArgSeparatorCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@","];
        kIdentifierCharacterSet = [NSCharacterSet letterCharacterSet];
        
        NSMutableCharacterSet *s =[[NSMutableCharacterSet alloc] init];
        [s formUnionWithCharacterSet:kBinaryOperatorLowerPrecedenceCharacterSet];
        [s formUnionWithCharacterSet:kBinaryOperatorHigherPrecedenceCharacterSet];
        kBinaryOperatorCharacterSet = s;
        
        s = [[NSMutableCharacterSet alloc] init];
        [s formUnionWithCharacterSet:kOpenParenCharacterSet];
        [s formUnionWithCharacterSet:kCloseParenCharacterSet];
        [s formUnionWithCharacterSet:kBinaryOperatorCharacterSet];
        [s formUnionWithCharacterSet:kAssignmentCharacterSet];
        [s formUnionWithCharacterSet:kArgSeparatorCharacterSet];
        kSingleCharacterTokenCharacterSet = s;
        
        s = [[NSMutableCharacterSet alloc] init];
        [s formUnionWithCharacterSet:kSingleCharacterTokenCharacterSet];
        [s formUnionWithCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        kSeparatorCharacterSet = s;
        
        s = [[NSMutableCharacterSet alloc] init];
        [s formUnionWithCharacterSet:kBinaryOperatorLowerPrecedenceCharacterSet];
        [s formUnionWithCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
        kStartTokenCharacterSet = s;
    });
}

@end