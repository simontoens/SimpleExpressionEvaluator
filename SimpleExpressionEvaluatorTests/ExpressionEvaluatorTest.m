//
//  ExpressionEvaluatorTest.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/29/13.
//  Copyright (c) 2013 Simon Toens. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ExpressionEvaluator.h"

@interface ExpressionEvaluatorTest : XCTestCase
{
    ExpressionEvaluator *evaluator;
}
@end

@implementation ExpressionEvaluatorTest

- (void)setUp
{
    [super setUp];
    evaluator = [[ExpressionEvaluator alloc] init];
}

- (void)testExample
{
    XCTAssertEqual([evaluator evaluate:@"1 + 2"], 3, @"");
    XCTAssertEqual([evaluator evaluate:@"15 * 2"], 30, @"");
    
    XCTAssertEqual([evaluator evaluate:@"15 * 2 + 1"], 31, @"");
    XCTAssertEqual([evaluator evaluate:@"15 * (2 + 1)"], 45, @"");

    XCTAssertEqual([evaluator evaluate:@"2 + 1 * 2 + 2 "], 6, @"");
    XCTAssertEqual([evaluator evaluate:@"(2 + 1) * (2 + 2)"], 12, @"");
    
    XCTAssertEqual([evaluator evaluate:@"10/2+1-4"], 2, @"");
}

@end
