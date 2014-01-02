//
//  EnvironmentTest.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 1/1/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Environment.h"

@interface EnvironmentTest : XCTestCase

@end

@implementation EnvironmentTest
{
    Environment *_environment;
}

- (void)setUp
{
    [super setUp];
    _environment = [[Environment alloc] init];
}

- (void)testEnv
{
    NSString *var = @"a";
    NSString *value = @"10";
    _environment[var] = value;
    XCTAssertEqualObjects(_environment[var], value);
}

@end
