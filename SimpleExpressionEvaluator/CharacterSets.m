//
//  CharacterSets.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 10/18/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import "CharacterSets.h"

@implementation CharacterSets

NSCharacterSet *kLeftParen;
NSCharacterSet *kRightParen;
NSCharacterSet *kParensCharacterSet;

NSCharacterSet *kBinaryOperatorLowerPrecedenceCharacterSet;
NSCharacterSet *kBinaryOperatorHigherPrecedenceCharacterSet;
NSCharacterSet *kBinaryOperatorCharacterSet;

NSCharacterSet *kAssignmentCharacterSet;
NSCharacterSet *kIdentifierCharacterSet;

NSCharacterSet *kSeparatorCharacterSet;
NSCharacterSet *kSingleCharacterTokenCharacterSet;
NSCharacterSet *kStartTokenCharacterSet;

+ (void)initialize
{
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{
        kLeftParen = [NSCharacterSet characterSetWithCharactersInString:@"("];
        kRightParen = [NSCharacterSet characterSetWithCharactersInString:@")"];
        NSMutableCharacterSet *s = [[NSMutableCharacterSet alloc] init];
        [s formUnionWithCharacterSet:kLeftParen];
        [s formUnionWithCharacterSet:kRightParen];
        kParensCharacterSet = s;
        
        kBinaryOperatorLowerPrecedenceCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"-+"];
        kBinaryOperatorHigherPrecedenceCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"*/"];
        kAssignmentCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"="];
        kIdentifierCharacterSet = [NSCharacterSet letterCharacterSet];
        
        s =[[NSMutableCharacterSet alloc] init];
        [s formUnionWithCharacterSet:kBinaryOperatorLowerPrecedenceCharacterSet];
        [s formUnionWithCharacterSet:kBinaryOperatorHigherPrecedenceCharacterSet];
        kBinaryOperatorCharacterSet = s;
        
        s = [[NSMutableCharacterSet alloc] init];
        [s formUnionWithCharacterSet:kParensCharacterSet];
        [s formUnionWithCharacterSet:kBinaryOperatorCharacterSet];
        [s formUnionWithCharacterSet:kAssignmentCharacterSet];
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