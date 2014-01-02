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
    Node *ref = [[Node alloc] init];
    ref.value = @"a";
    
    Node *val = [[Node alloc] init];
    val.value = @"10";
    [_environment bind:val to:ref];
    XCTAssertEqualObjects([_environment resolve:ref], val);
}

@end
