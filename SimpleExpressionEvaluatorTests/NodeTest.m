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

- (void)testPrecedence
{
    XCTAssertTrue([[Node alloc] initWithValue:@"+" nodeType:kNodeTypeBinaryOperator].precedence >
                  [[Node alloc] initWithValue:@"(" nodeType:kNodeTypeParen].precedence, @"");

    XCTAssertTrue([[Node alloc] initWithValue:@"+" nodeType:kNodeTypeBinaryOperator].precedence ==
                  [[Node alloc] initWithValue:@"-" nodeType:kNodeTypeBinaryOperator].precedence, @"");
    
    XCTAssertTrue([[Node alloc] initWithValue:@"*" nodeType:kNodeTypeBinaryOperator].precedence >
                  [[Node alloc] initWithValue:@"-" nodeType:kNodeTypeBinaryOperator].precedence, @"");
    
    XCTAssertTrue([[Node alloc] initWithValue:@"*" nodeType:kNodeTypeBinaryOperator].precedence ==
                  [[Node alloc] initWithValue:@"/" nodeType:kNodeTypeBinaryOperator].precedence, @"");
    
    XCTAssertTrue([[Node alloc] initWithValue:@")" nodeType:kNodeTypeParen].precedence >
                  [[Node alloc] initWithValue:@"*" nodeType:kNodeTypeBinaryOperator].precedence, @"");
}

@end
