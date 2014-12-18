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
#import "Node.h"
#import "ReferenceNode.h"

@interface NodeTest : XCTestCase

@end

@implementation NodeTest

- (void)testPrefixForOp
{
    Node *root = [[BinaryOperationNode alloc] initWithValue:@"*" functionDefinitions:nil];
    root.children = @[
                      [[ConstantNode alloc] initWithValue:@"1"],
                      [[ConstantNode alloc] initWithValue:@"2"]
                    ];
    XCTAssertEqualObjects([root prefix], @"(* 1 2)");
}

- (void)testPrefixForFunc
{
    Node *root = [[FunctionNode alloc] initWithValue:@"add" functionDefinitions:nil];
    root.children = @[
                      [[ConstantNode alloc] initWithValue:@"1"],
                      [[ConstantNode alloc] initWithValue:@"2"]
                    ];
    XCTAssertEqualObjects([root prefix], @"(add 1 2)");
}

- (void)testBinOpIsLeftAssociative
{
    BinaryOperationNode *n = [[BinaryOperationNode alloc] initWithValue:@"/"];
    // 100/2/2 -> (100/2)/2
    XCTAssertTrue(n.leftAssociative, @"Expected '/' to be left associative");
}

- (void)testAssignmentIsRightAssociative
{
    AssignmentNode *n = [[AssignmentNode alloc] initWithValue:@"="];
    // a=b=3 -> a=(b=3)
    XCTAssertFalse(n.leftAssociative, @"Did not expect '=' to be left associative");
}

- (void)testPrecedence
{
    XCTAssertTrue([AssignmentNode assign].precedence <
                  [[BinaryOperationNode alloc] initWithValue:@"-" functionDefinitions:nil].precedence);
    
    XCTAssertTrue([AssignmentNode assign].precedence <
                  [[BinaryOperationNode alloc] initWithValue:@"+" functionDefinitions:nil].precedence);
    
    XCTAssertEqual([[BinaryOperationNode alloc] initWithValue:@"-" functionDefinitions:nil].precedence,
                   [[BinaryOperationNode alloc] initWithValue:@"+" functionDefinitions:nil].precedence);
    
    XCTAssertTrue([[BinaryOperationNode alloc] initWithValue:@"-" functionDefinitions:nil].precedence <
                  [[BinaryOperationNode alloc] initWithValue:@"*" functionDefinitions:nil].precedence);
    
    XCTAssertTrue([[BinaryOperationNode alloc] initWithValue:@"-" functionDefinitions:nil].precedence <
                  [[BinaryOperationNode alloc] initWithValue:@"/" functionDefinitions:nil].precedence);
    
    XCTAssertEqual([[BinaryOperationNode alloc] initWithValue:@"*" functionDefinitions:nil].precedence,
                   [[BinaryOperationNode alloc] initWithValue:@"/" functionDefinitions:nil].precedence);
}

@end