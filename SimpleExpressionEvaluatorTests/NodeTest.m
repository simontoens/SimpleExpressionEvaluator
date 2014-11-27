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

- (void)testPrefix
{
    Node *root = [Node nodeWithToken:[Token tokenWithValue:@"*"]];
    root.left = [Node nodeWithToken:[Token tokenWithValue:@"1"]];
    root.right = [Node nodeWithToken:[Token tokenWithValue:@"2"]];
    XCTAssertEqualObjects([root prefix], @"(* 1 2)");
}

- (void)testPrecedence
{
    XCTAssertEqual([Node nodeWithToken:[Token tokenWithType:[TokenType assign]]].precedence,
                   [Node nodeWithToken:[Token tokenWithType:[TokenType constant]]].precedence);
    
    XCTAssertEqual([Node nodeWithToken:[Token tokenWithType:[TokenType identifier]]].precedence,
                   [Node nodeWithToken:[Token tokenWithType:[TokenType constant]]].precedence);
    
    XCTAssertTrue([Node nodeWithToken:[Token tokenWithType:[TokenType op]]].precedence >
                  [Node nodeWithToken:[Token tokenWithType:[TokenType openParen]]].precedence);
    
    XCTAssertEqual([Node nodeWithToken:[Token tokenWithValue:@"+" type:[TokenType op]]].precedence,
                   [Node nodeWithToken:[Token tokenWithValue:@"-" type:[TokenType op]]].precedence);

    XCTAssertTrue([Node nodeWithToken:[Token tokenWithValue:@"*" type:[TokenType op]]].precedence >
                  [Node nodeWithToken:[Token tokenWithValue:@"-" type:[TokenType op]]].precedence);
    
    XCTAssertEqual([Node nodeWithToken:[Token tokenWithValue:@"*" type:[TokenType op]]].precedence,
                   [Node nodeWithToken:[Token tokenWithValue:@"/" type:[TokenType op]]].precedence);
    
    XCTAssertTrue([Node nodeWithToken:[Token tokenWithType:[TokenType closeParen]]].precedence >
                  [Node nodeWithToken:[Token tokenWithValue:@"*" type:[TokenType op]]].precedence);
    
    XCTAssertTrue([Node nodeWithToken:[Token tokenWithType:[TokenType identifier]] nodeType:[NodeType func]].precedence >
                  [Node nodeWithToken:[Token tokenWithValue:@"*" type:[TokenType op]]].precedence);
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