//
//  TokenTypeTest.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 1/29/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TokenType.h"

@interface TokenTypeTest : XCTestCase

@end

@implementation TokenTypeTest

- (void)tearDown
{
    [NSThread sleepForTimeInterval:1]; // crappy Xcode bug, utests can't run too fast
    [super tearDown];
}

- (void)testTokenType
{
    XCTAssertEqual([TokenType constant], [TokenType constant]);
    XCTAssertEqualObjects([TokenType constant], [TokenType constant]);
}

@end
