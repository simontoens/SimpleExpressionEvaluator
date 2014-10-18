//
//  Tokenizer.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/29/13.
//  Copyright (c) 2013 Simon Toens. All rights reserved.
//

#import "CharacterSets.h"
#import "Token.h"
#import "Tokenizer.h"
#import "Preconditions.h"

@implementation Tokenizer

+ (void)initialize
{
    [CharacterSets class];
}

- (NSArray *)tokenize:(NSString *)stringExpression
{
    NSMutableArray *tokens = [[NSMutableArray alloc] init];
    
    NSMutableString *currentTokenValue = nil;
    
    NSMutableString *expression = [NSMutableString stringWithString:stringExpression];
    
    for (int position = 0; position < [expression length]; position++)
    {
        unichar c = [expression characterAtIndex:position];
        
        if ([kSeparatorCharacterSet characterIsMember:c])
        {
            if (currentTokenValue)
            {
                [tokens addObject:[Token tokenWithValue:currentTokenValue]];
                currentTokenValue = nil;
            }
            if ([[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:c])
            {
                continue;
            }
        }
        
        if (!currentTokenValue)
        {
            currentTokenValue = [[NSMutableString alloc] init];
        }
        
        [currentTokenValue appendString:[NSString stringWithFormat:@"%C", c]];

        Token *previousToken = [tokens count] > 0 ? [tokens lastObject] : nil;

        if ([kStartTokenCharacterSet characterIsMember:c] &&
            previousToken.type != [TokenType constant] && previousToken.type != [TokenType identifier])
        {
            // 3-2  -> 3,-,2
            // 3+-2 -> 3, +, -2
        }
        else if ([kLeftParen characterIsMember:c] && previousToken.type == [TokenType identifier])
        {
            // blah( -> assume func with single arg
            NSRange r = [expression rangeOfCharacterFromSet:kRightParen options:NSLiteralSearch
                                                      range:NSMakeRange(position, [expression length] - position)];
            [expression deleteCharactersInRange:r];
            
            // need to work with higher level data structure, ie a "Token" instead of an NSString,
            // the TokenType could be set right here
            currentTokenValue = [NSMutableString stringWithFormat:@"%@(", previousToken.value];
            [tokens removeLastObject];
            
            [tokens addObject:[Token tokenWithValue:currentTokenValue]];
            currentTokenValue = nil;
        }
        else if ([kSingleCharacterTokenCharacterSet characterIsMember:c])
        {
            [tokens addObject:[Token tokenWithValue:currentTokenValue]];
            currentTokenValue = nil;
        }
    }
    
    if (currentTokenValue)
    {
        [tokens addObject:[Token tokenWithValue:currentTokenValue]];
    }
    
    return tokens;
}

@end