//
//  TokenTest.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 10/18/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Token.h"

@interface TokenTest : XCTestCase
@end

@implementation TokenTest

- (void)testTokenType
{
    XCTAssertEqual([Token tokenWithValue:@"+"].type, [TokenType op]);
    XCTAssertEqual([Token tokenWithValue:@"-"].type, [TokenType op]);
    XCTAssertEqual([Token tokenWithValue:@"*"].type, [TokenType op]);
    XCTAssertEqual([Token tokenWithValue:@"/"].type, [TokenType op]);

    XCTAssertEqual([Token tokenWithValue:@"("].type, [TokenType paren]);
    XCTAssertEqual([Token tokenWithValue:@")"].type, [TokenType paren]);
    
    XCTAssertEqualObjects([Token tokenWithValue:@"1533"].type, [TokenType constant]);
    [self assertUnknownTokenType:@"2a3"];
    [self assertUnknownTokenType:@"1.533"];
    [self assertUnknownTokenType:@"1,533"];
    
    XCTAssertEqualObjects([Token tokenWithValue:@"-1"].type, [TokenType constant]);
    XCTAssertEqualObjects([Token tokenWithValue:@"+3"].type, [TokenType constant]);
    [self assertUnknownTokenType:@"*3"];
    [self assertUnknownTokenType:@"/5"];
    
    XCTAssertEqualObjects([Token tokenWithValue:@"="].type, [TokenType assign]);
    
    XCTAssertEqualObjects([Token tokenWithValue:@"a"].type, [TokenType identifier]);
    XCTAssertEqualObjects([Token tokenWithValue:@"abc"].type, [TokenType identifier]);
    [self assertUnknownTokenType:@"abc1"];
}

- (void)assertUnknownTokenType:(NSString *)tokenValue
{
    @try
    {
        [Token tokenWithValue:tokenValue];
        XCTFail(@"Expected NSException to be thrown");
    } @catch (NSException *expected)
    {
    }
}

@end