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

@interface Tokenizer()
- (NSArray *)split:(NSString *)expression;
- (TokenType *)getTokenType:(NSString *)token;
- (NSUInteger)getPrecedenceForToken:(NSString *)token ofType:(TokenType *)type;
@end

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

- (void)testSplit
{
    NSArray *expected = @[[self v:@"1" t:[TokenType constant]]];
    XCTAssertEqualObjects([tokenizer split:@"1"], expected);
    XCTAssertEqualObjects([tokenizer split:@"   1  "], expected);

    expected = @[[self v:@"1" t:[TokenType constant]], [self v:@"2" t:[TokenType constant]], [self v:@"3" t:[TokenType constant]]];
    XCTAssertEqualObjects([tokenizer split:@" 1  2   3  "], expected);

    expected = @[[self v:@"1" t:[TokenType constant]], [self v:@"+" t:[TokenType op]], [self v:@"3" t:[TokenType constant]]];
    XCTAssertEqualObjects([tokenizer split:@"1 + 3"], expected);

    expected = @[[self v:@"1" t:[TokenType constant]], [self v:@"+" t:[TokenType op]], [self v:@"3" t:[TokenType constant]]];
    XCTAssertEqualObjects([tokenizer split:@"1+3"], expected);

    expected = @[[self v:@"1" t:[TokenType constant]],
                 [self v:@"+" t:[TokenType op]],
                 [self v:@"(" t:[TokenType paren]],
                 [self v:@"3" t:[TokenType constant]],
                 [self v:@")" t:[TokenType paren]]];
    XCTAssertEqualObjects([tokenizer split:@"1+(3)"], expected);

    expected = @[[self v:@"1" t:[TokenType constant]],
                 [self v:@"/" t:[TokenType op]],
                 [self v:@"2" t:[TokenType constant]],
                 [self v:@"-" t:[TokenType op]],
                 [self v:@"3" t:[TokenType constant]]];
    XCTAssertEqualObjects([tokenizer split:@"1/2-3"], expected);

    expected = @[[self v:@"-1" t:[TokenType constant]]];
    XCTAssertEqualObjects([tokenizer split:@"-1"], expected);

    expected = @[[self v:@"-1" t:[TokenType constant]], [self v:@"+" t:[TokenType op]], [self v:@"3" t:[TokenType constant]]];
    XCTAssertEqualObjects([tokenizer split:@"-1+3"], expected);

    expected = @[[self v:@"-1" t:[TokenType constant]], [self v:@"*" t:[TokenType op]], [self v:@"-3" t:[TokenType constant]]];
    XCTAssertEqualObjects([tokenizer split:@"-1*-3"], expected);

    expected = @[[self v:@"-1" t:[TokenType constant]],
                 [self v:@"*" t:[TokenType op]],
                 [self v:@"(" t:[TokenType paren]],
                 [self v:@"-3" t:[TokenType constant]],
                 [self v:@")" t:[TokenType paren]]];
    XCTAssertEqualObjects([tokenizer split:@"-1*(-3)"], expected);

    expected = @[[self v:@"=" t:[TokenType assign]]];
    XCTAssertEqualObjects([tokenizer split:@"="], expected);
    
    expected = @[[self v:@"x" t:[TokenType identifier]], [self v:@"=" t:[TokenType assign]], [self v:@"1" t:[TokenType constant]]];
    XCTAssertEqualObjects([tokenizer split:@"x=1"], expected);
    
    expected = @[[self v:@"myvar" t:[TokenType identifier]], [self v:@"=" t:[TokenType assign]], [self v:@"1" t:[TokenType constant]]];
    XCTAssertEqualObjects([tokenizer split:@"myvar=1"], expected);

    expected = @[[self v:@"myvar" t:[TokenType identifier]], [self v:@"+" t:[TokenType op]], [self v:@"yourvar" t:[TokenType identifier]]];
    XCTAssertEqualObjects([tokenizer split:@"myvar+yourvar"], expected);
    
    //expected = @[@"f", @"2"];
    //XCTAssertEqualObjects([tokenizer split:@"f(2)"], expected);
}

- (void)testGetNodeType
{
    XCTAssertNil([tokenizer getTokenType:@"2a3"]);
    XCTAssertNil([tokenizer getTokenType:@"1.533"]);
    XCTAssertNil([tokenizer getTokenType:@"1,533"]);

    XCTAssertEqualObjects([tokenizer getTokenType:@"1533"], [TokenType constant]);
    XCTAssertEqual([tokenizer getTokenType:@"+"], [TokenType op]);
    XCTAssertEqual([tokenizer getTokenType:@"-"], [TokenType op]);
    XCTAssertEqual([tokenizer getTokenType:@"*"], [TokenType op]);
    XCTAssertEqual([tokenizer getTokenType:@"/"], [TokenType op]);
    XCTAssertEqual([tokenizer getTokenType:@"("], [TokenType paren]);
    XCTAssertEqual([tokenizer getTokenType:@")"], [TokenType paren]);
    
    XCTAssertEqual([tokenizer getTokenType:@"-1"], [TokenType constant]);
    XCTAssertEqual([tokenizer getTokenType:@"+3"], [TokenType constant]);
    XCTAssertNil([tokenizer getTokenType:@"*3"]);
    XCTAssertNil([tokenizer getTokenType:@"/3"]);
    
    XCTAssertEqual([tokenizer getTokenType:@"="], [TokenType assign]);
    
    XCTAssertEqual([tokenizer getTokenType:@"a"], [TokenType identifier]);
    XCTAssertEqual([tokenizer getTokenType:@"abc"], [TokenType identifier]);
    XCTAssertNil([tokenizer getTokenType:@"abc1"]);
}

- (void)testPrecedence
{
    XCTAssertTrue([tokenizer getPrecedenceForToken:@"=" ofType:[TokenType assign]] ==
                  [tokenizer getPrecedenceForToken:@"2" ofType:[TokenType constant]]);
    
    XCTAssertTrue([tokenizer getPrecedenceForToken:@"a" ofType:[TokenType identifier]] ==
                  [tokenizer getPrecedenceForToken:@"2" ofType:[TokenType constant]]);
    
    XCTAssertTrue([tokenizer getPrecedenceForToken:@"func" ofType:[TokenType func]] ==
                  [tokenizer getPrecedenceForToken:@"2" ofType:[TokenType constant]]);
    
    XCTAssertTrue([tokenizer getPrecedenceForToken:@"+" ofType:[TokenType op]] >
                  [tokenizer getPrecedenceForToken:@"(" ofType:[TokenType paren]]);
    
    XCTAssertTrue([tokenizer getPrecedenceForToken:@"+" ofType:[TokenType op]] ==
                  [tokenizer getPrecedenceForToken:@"-" ofType:[TokenType op]]);
    
    XCTAssertTrue([tokenizer getPrecedenceForToken:@"*" ofType:[TokenType op]] >
                  [tokenizer getPrecedenceForToken:@"-" ofType:[TokenType op]]);
    
    XCTAssertTrue([tokenizer getPrecedenceForToken:@"*" ofType:[TokenType op]] ==
                  [tokenizer getPrecedenceForToken:@"/" ofType:[TokenType op]]);
    
    XCTAssertTrue([tokenizer getPrecedenceForToken:@")" ofType:[TokenType paren]] >
                  [tokenizer getPrecedenceForToken:@"*" ofType:[TokenType op]]);
}

- (void)testTokenize
{
    NSString *expression = @"1 + 2";
    NSArray *tokens = [tokenizer tokenize:expression];
    XCTAssertEqual([tokens count], (NSUInteger)3);
    
    XCTAssertEqualObjects(((Node *)[tokens objectAtIndex:0]).value, @"1");
    XCTAssertTrue(((Node *)[tokens objectAtIndex:0]).precedence > 0);
    
    XCTAssertEqualObjects(((Node *)[tokens objectAtIndex:1]).value, @"+");
    XCTAssertTrue(((Node *)[tokens objectAtIndex:1]).precedence > 0);
    
    XCTAssertEqualObjects(((Node *)[tokens objectAtIndex:2]).value, @"2");
    XCTAssertTrue(((Node *)[tokens objectAtIndex:2]).precedence > 0);
}

- (void)testInvalidExpression
{
    // the tokenizer is ok with this
    NSArray *tokens = [tokenizer tokenize:@"++++-12(((33--)"];
    XCTAssertEqualObjects(((Node *)[tokens objectAtIndex:0]).value, @"+");
    XCTAssertEqualObjects(((Node *)[tokens objectAtIndex:1]).value, @"+");
    XCTAssertEqualObjects(((Node *)[tokens objectAtIndex:2]).value, @"+");
    XCTAssertEqualObjects(((Node *)[tokens objectAtIndex:3]).value, @"+");
    XCTAssertEqualObjects(((Node *)[tokens objectAtIndex:4]).value, @"-12");
}

- (Token *)v:(NSString *)value t:(TokenType *)type\
{
    return [[Token alloc] initWithValue:value type:type];
}

@end
