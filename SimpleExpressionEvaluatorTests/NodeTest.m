//
//  NodeTest.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/28/13.
//  Copyright (c) 2013 Simon Toens. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AssignmentNode.h"
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

//- (void)testPrecedence
//{
//    XCTAssertEqual([[AssignmentNode alloc] initWithToken:[Token tokenWithType:[TokenType assign]]].precedence,
//                   [[ConstantNode alloc] initWithToken:[Token tokenWithType:[TokenType constant]]].precedence);
//    
//    XCTAssertEqual([[ReferenceNode alloc] initWithToken:[Token tokenWithType:[TokenType identifier]]].precedence,
//                   [[ConstantNode alloc] initWithToken:[Token tokenWithType:[TokenType constant]]].precedence);
//    
//    XCTAssertTrue([[FunctionNode alloc] initWithToken:[Token tokenWithType:[TokenType op]]].precedence >
//                  [[GroupStartNode alloc] initWithToken:[Token tokenWithType:[TokenType openParen]]].precedence);
//    
//    XCTAssertEqual([[FunctionNode alloc] initWithToken:[Token tokenWithValue:@"+" type:[TokenType op]]].precedence,
//                   [[FunctionNode alloc] initWithToken:[Token tokenWithValue:@"-" type:[TokenType op]]].precedence);
//
//    XCTAssertTrue([[FunctionNode alloc] initWithToken:[Token tokenWithValue:@"*" type:[TokenType op]]].precedence >
//                  [[FunctionNode alloc] initWithToken:[Token tokenWithValue:@"-" type:[TokenType op]]].precedence);
//    
//    XCTAssertEqual([[FunctionNode alloc] initWithToken:[Token tokenWithValue:@"*" type:[TokenType op]]].precedence,
//                   [[FunctionNode alloc] initWithToken:[Token tokenWithValue:@"/" type:[TokenType op]]].precedence);
//    
//    XCTAssertTrue([[GroupEndNode alloc] initWithToken:[Token tokenWithType:[TokenType closeParen]]].precedence >
//                  [[FunctionNode alloc] initWithToken:[Token tokenWithValue:@"*" type:[TokenType op]]].precedence);
//    
////    XCTAssertEqual([[FunctionNode alloc] initWithToken:[Token tokenWithType:[TokenType identifier]]].precedence,
////                  [[FunctionNode alloc] initWithToken:[Token tokenWithValue:@"*" type:[TokenType op]]].precedence);
//}

@end