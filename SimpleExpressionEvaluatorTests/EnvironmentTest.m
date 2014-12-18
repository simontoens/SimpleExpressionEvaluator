//
//  EnvironmentTest.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 1/1/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ConstantNode.h"
#import "Environment.h"
#import "Node.h"
#import "ReferenceNode.h"

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
    Node *ref = [[ConstantNode alloc] initWithValue:@"a"];
    Node *val = [[ReferenceNode alloc] initWithValue:@"10"];
    [_environment bind:val to:ref];
    XCTAssertEqualObjects([_environment resolve:ref], val);
}

@end