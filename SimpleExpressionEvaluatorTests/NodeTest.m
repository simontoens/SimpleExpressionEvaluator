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

- (void)testPrefixMultiplication
{
    Node *root = [Node nodeWithToken:[Token tokenWithValue:@"*"]];
    root.left = [Node nodeWithToken:[Token tokenWithValue:@"1"]];
    root.right = [Node nodeWithToken:[Token tokenWithValue:@"2"]];
    XCTAssertEqualObjects([root prefix], @"(* 1 2)");
}

- (void)testMultiplicationAndAddition
{
    Node *root = [Node nodeWithToken:[Token tokenWithValue:@"*"]];
    root.left = [Node nodeWithToken:[Token tokenWithValue:@"1"]];
    root.right = [Node nodeWithToken:[Token tokenWithValue:@"+"]];
    root.right.left = [Node nodeWithToken:[Token tokenWithValue:@"3"]];
    root.right.right = [Node nodeWithToken:[Token tokenWithValue:@"4"]];
    XCTAssertEqualObjects([root prefix], @"(* 1 (+ 3 4))");
}

- (void)testRightAssociative
{
    Node *n1 = [Node nodeWithToken:[Token tokenWithValue:@"="]];
    Node *n2 = [Node nodeWithToken:[Token tokenWithValue:@"="]];
    // a=b=3 -> a=(b=3)
    XCTAssertTrue([n2 rightAssociative:n1], @"Expected = to be right associative when following another =");
    
    n1 = [Node nodeWithToken:[Token tokenWithValue:@"/"]];
    n2 = [Node nodeWithToken:[Token tokenWithValue:@"/"]];
    // 1000/100/2 = (1000/100)/2 = 5, not 1000/(100/2)
    XCTAssertFalse([n2 rightAssociative:n1], @"Did not expect / to be right associative");
}

- (void)testConstant
{
    Node *n = [Node nodeWithToken:[Token tokenWithValue:@"33"]];
    XCTAssertTrue(n.argument, @"Expected argument");
    XCTAssertFalse(n.variable, @"Did not expect variable");
    XCTAssertFalse(n.function, @"Did not expect function");
    XCTAssertFalse(n.group, @"Did not expect group");
}

- (void)testVariable
{
    Node *n = [Node nodeWithToken:[Token tokenWithValue:@"a"]];
    XCTAssertTrue(n.variable, @"Expected variable");
    XCTAssertTrue(n.argument, @"Expected argument");
    XCTAssertFalse(n.function, @"Did not expect function");
    XCTAssertFalse(n.group, @"Did not expect group");
}

- (void)testFunction
{
    Node *n = [Node nodeWithToken:[Token tokenWithValue:@"f"] nodeType:[NodeType func]];
    XCTAssertTrue(n.function, @"Expected function");
    XCTAssertFalse(n.variable, @"Did not expect variable");
    XCTAssertFalse(n.argument, @"Did not expect argument");
    XCTAssertFalse(n.group, @"Did not expect group");
}

- (void)testOp
{
    Node *n = [Node nodeWithToken:[Token tokenWithValue:@"*"]];
    XCTAssertTrue(n.function, @"Expected function");
    XCTAssertFalse(n.variable, @"Did not expect variable");
    XCTAssertFalse(n.argument, @"Did not expect argument");
    XCTAssertFalse(n.group, @"Did not expect group");
}

- (void)testAssign
{
    Node *n = [Node nodeWithToken:[Token tokenWithValue:@"="]];
    XCTAssertTrue(n.function, @"Expected function");
    XCTAssertFalse(n.variable, @"Did not expect variable");
    XCTAssertFalse(n.argument, @"Did not expect argument");
    XCTAssertFalse(n.group, @"Did not expect group");
}

- (void)testGroupStart
{
    Node *n = [Node nodeWithToken:[Token tokenWithValue:@"("]];
    XCTAssertTrue(n.group, @"Expected group");
    XCTAssertTrue(n.groupStart, @"Expected group start");
    XCTAssertFalse(n.groupEnd, @"Did not expect group end");
    XCTAssertFalse(n.function, @"Did not expect function");
    XCTAssertFalse(n.variable, @"Did not expect variable");
    XCTAssertFalse(n.argument, @"Did not expect argument");
}

- (void)testGroupEnd
{
    Node *n = [Node nodeWithToken:[Token tokenWithValue:@")"]];
    XCTAssertTrue(n.group, @"Expected group");
    XCTAssertTrue(n.groupEnd, @"Expected group end");
    XCTAssertFalse(n.groupStart, @"Did not expect group start");
    XCTAssertFalse(n.function, @"Did not expect function");
    XCTAssertFalse(n.variable, @"Did not expect variable");
    XCTAssertFalse(n.argument, @"Did not expect argument");
}

@end