//
//  CharacterSets.h
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 10/18/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CharacterSets : NSObject

extern NSCharacterSet *kOpenParenCharacterSet;
extern NSCharacterSet *kCloseParenCharacterSet;

extern NSCharacterSet *kBinaryOperatorLowerPrecedenceCharacterSet;
extern NSCharacterSet *kBinaryOperatorHigherPrecedenceCharacterSet;
extern NSCharacterSet *kBinaryOperatorCharacterSet;

extern NSCharacterSet *kAssignmentCharacterSet;
extern NSCharacterSet *kIdentifierCharacterSet;
extern NSCharacterSet *kArgSeparatorCharacterSet;

extern NSCharacterSet *kSeparatorCharacterSet;
extern NSCharacterSet *kSingleCharacterTokenCharacterSet;
extern NSCharacterSet *kStartTokenCharacterSet;

@end