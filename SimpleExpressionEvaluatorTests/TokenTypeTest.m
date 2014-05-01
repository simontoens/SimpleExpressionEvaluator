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

- (void)testTokenType
{
    XCTAssertEqual([TokenType constant], [TokenType constant]);
    XCTAssertEqualObjects([TokenType constant], [TokenType constant]);
}

@end
