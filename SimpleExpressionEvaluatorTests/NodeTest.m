//
//  NodeTest.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/28/13.
//  Copyright (c) 2013 Simon Toens. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AssignmentNode.h"
#import "BinaryOperationNode.h"
#import "ConstantNode.h"
#import "FunctionNode.h"
#import "GroupEndNode.h"
#import "GroupStartNode.h"
#import "Node.h"
#import "ReferenceNode.h"

@interface NodeTest : XCTestCase

@end

@implementation NodeTest

- (void)testPrefixForOp
{
    Node *root = [[FunctionNode alloc] initWithToken:[Token tokenWithValue:@"*"] functionDefinitions:nil];
    root.children = @[
                      [[ConstantNode alloc] initWithToken:[Token tokenWithValue:@"1"]],
                      [[ConstantNode alloc] initWithToken:[Token tokenWithValue:@"2"]]
                    ];
    XCTAssertEqualObjects([root prefix], @"(* 1 2)");
}

- (void)testPrefixForFunc
{
    Node *root = [[FunctionNode alloc] initWithToken:[Token tokenWithValue:@"add"] functionDefinitions:nil];
    root.children = @[
                      [[ConstantNode alloc] initWithToken:[Token tokenWithValue:@"1"]],
                      [[ConstantNode alloc] initWithToken:[Token tokenWithValue:@"2"]]
                    ];
    XCTAssertEqualObjects([root prefix], @"(add 1 2)");
}

- (void)testBinOpIsLeftAssociative
{
    BinaryOperationNode *n = [[BinaryOperationNode alloc] initWithToken:[Token tokenWithValue:@"/"]];
    // 100/2/2 -> (100/2)/2
    XCTAssertTrue(n.leftAssociative, @"Expected '/' to be left associative");
}

- (void)testAssignmentIsRightAssociative
{
    AssignmentNode *n = [[AssignmentNode alloc] initWithToken:[Token tokenWithValue:@"="]];
    // a=b=3 -> a=(b=3)
    XCTAssertFalse(n.leftAssociative, @"Did not expect '=' to be left associative");
}

- (void)testPrecedence
{
    XCTAssertTrue([[AssignmentNode alloc] initWithToken:[Token tokenWithType:[TokenType assign]]].precedence <
                  [[BinaryOperationNode alloc] initWithToken:[Token tokenWithValue:@"-"]].precedence);
    
    XCTAssertTrue([[AssignmentNode alloc] initWithToken:[Token tokenWithType:[TokenType assign]]].precedence <
                  [[BinaryOperationNode alloc] initWithToken:[Token tokenWithValue:@"+"]].precedence);
    
    XCTAssertEqual([[BinaryOperationNode alloc] initWithToken:[Token tokenWithValue:@"-"]].precedence,
                  [[BinaryOperationNode alloc] initWithToken:[Token tokenWithValue:@"+"]].precedence);
    
    XCTAssertTrue([[BinaryOperationNode alloc] initWithToken:[Token tokenWithValue:@"-"]].precedence <
                   [[BinaryOperationNode alloc] initWithToken:[Token tokenWithValue:@"*"]].precedence);
    
    XCTAssertTrue([[BinaryOperationNode alloc] initWithToken:[Token tokenWithValue:@"-"]].precedence <
                  [[BinaryOperationNode alloc] initWithToken:[Token tokenWithValue:@"/"]].precedence);
    
    XCTAssertEqual([[BinaryOperationNode alloc] initWithToken:[Token tokenWithValue:@"*"]].precedence,
                   [[BinaryOperationNode alloc] initWithToken:[Token tokenWithValue:@"/"]].precedence);
}

@end