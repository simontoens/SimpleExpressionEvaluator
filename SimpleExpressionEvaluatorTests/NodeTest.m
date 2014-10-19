//
//  NodeTest.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/28/13.
//  Copyright (c) 2013 Simon Toens. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Node.h"

@interface NodeTest : XCTestCase

@end

@implementation NodeTest

- (void)testPrefix1
{
    Node *root = [self v:@"*"];
    root.left = [self v:@"1"];
    root.right = [self v:@"2"];
    XCTAssertEqualObjects([root prefix], @"(* 1 2)");
}

- (void)testPrefix2
{
    Node *root = [self v:@"*"];
    root.left = [self v:@"1"];
    root.right = [self v:@"+"];
    root.right.left = [self v:@"3"];
    root.right.right = [self v:@"4"];
    XCTAssertEqualObjects([root prefix], @"(* 1 (+ 3 4))");
}

- (Node *)v:(NSString *)value
{
    Node *n = [[Node alloc] init];
    n.token = [Token tokenWithValue:value];
    return n;
}

@end