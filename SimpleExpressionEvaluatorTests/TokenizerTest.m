//
//  TokenizerTest.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/29/13.
//  Copyright (c) 2013 Simon Toens. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Node.h"
#import "Token.h"
#import "Tokenizer.h"

@interface TokenizerTest : XCTestCase
{
    Tokenizer *tokenizer;
}

@end

@implementation TokenizerTest

- (void)setUp
{
    [super setUp];
    tokenizer = [[Tokenizer alloc] init];
}

- (void)testTokenize
{
    NSArray *expected = @[[self v:@"1" t:[TokenType constant]]];
    XCTAssertEqualObjects([tokenizer tokenize:@"1"], expected);
    XCTAssertEqualObjects([tokenizer tokenize:@"   1  "], expected);

    expected = @[[self v:@"1" t:[TokenType constant]], [self v:@"2" t:[TokenType constant]], [self v:@"3" t:[TokenType constant]]];
    XCTAssertEqualObjects([tokenizer tokenize:@" 1  2   3  "], expected);

    expected = @[[self v:@"1" t:[TokenType constant]], [self v:@"+" t:[TokenType op]], [self v:@"3" t:[TokenType constant]]];
    XCTAssertEqualObjects([tokenizer tokenize:@"1 + 3"], expected);

    expected = @[[self v:@"1" t:[TokenType constant]], [self v:@"+" t:[TokenType op]], [self v:@"3" t:[TokenType constant]]];
    XCTAssertEqualObjects([tokenizer tokenize:@"1+3"], expected);

    expected = @[[self v:@"1" t:[TokenType constant]],
                 [self v:@"+" t:[TokenType op]],
                 [self v:@"(" t:[TokenType openParen]],
                 [self v:@"3" t:[TokenType constant]],
                 [self v:@")" t:[TokenType closeParen]]];
    XCTAssertEqualObjects([tokenizer tokenize:@"1+(3)"], expected);

    expected = @[[self v:@"1" t:[TokenType constant]],
                 [self v:@"/" t:[TokenType op]],
                 [self v:@"2" t:[TokenType constant]],
                 [self v:@"-" t:[TokenType op]],
                 [self v:@"3" t:[TokenType constant]]];
    XCTAssertEqualObjects([tokenizer tokenize:@"1/2-3"], expected);

    expected = @[[self v:@"-1" t:[TokenType constant]]];
    XCTAssertEqualObjects([tokenizer tokenize:@"-1"], expected);

    expected = @[[self v:@"-1" t:[TokenType constant]], [self v:@"+" t:[TokenType op]], [self v:@"3" t:[TokenType constant]]];
    XCTAssertEqualObjects([tokenizer tokenize:@"-1+3"], expected);

    expected = @[[self v:@"-1" t:[TokenType constant]], [self v:@"*" t:[TokenType op]], [self v:@"-3" t:[TokenType constant]]];
    XCTAssertEqualObjects([tokenizer tokenize:@"-1*-3"], expected);

    expected = @[[self v:@"-1" t:[TokenType constant]],
                 [self v:@"*" t:[TokenType op]],
                 [self v:@"(" t:[TokenType openParen]],
                 [self v:@"-3" t:[TokenType constant]],
                 [self v:@")" t:[TokenType closeParen]]];
    XCTAssertEqualObjects([tokenizer tokenize:@"-1*(-3)"], expected);

    expected = @[[self v:@"=" t:[TokenType assign]]];
    XCTAssertEqualObjects([tokenizer tokenize:@"="], expected);
    
    expected = @[[self v:@"x" t:[TokenType identifier]], [self v:@"=" t:[TokenType assign]], [self v:@"1" t:[TokenType constant]]];
    XCTAssertEqualObjects([tokenizer tokenize:@"x=1"], expected);
    
    expected = @[[self v:@"myvar" t:[TokenType identifier]], [self v:@"=" t:[TokenType assign]], [self v:@"1" t:[TokenType constant]]];
    XCTAssertEqualObjects([tokenizer tokenize:@"myvar=1"], expected);

    expected = @[[self v:@"myvar" t:[TokenType identifier]], [self v:@"+" t:[TokenType op]], [self v:@"yourvar" t:[TokenType identifier]]];
    XCTAssertEqualObjects([tokenizer tokenize:@"myvar+yourvar"], expected);
    
    expected = @[[self v:@"f" t:[TokenType identifier]],
                 [self v:@"(" t:[TokenType openParen]],
                 [self v:@"1" t:[TokenType constant]],
                 [self v:@")" t:[TokenType closeParen]]];
    XCTAssertEqualObjects([tokenizer tokenize:@"f  ( 1)"], expected);
}


- (Token *)v:(NSString *)value t:(TokenType *)type
{
    return [[Token alloc] initWithValue:value type:type];
}

@end