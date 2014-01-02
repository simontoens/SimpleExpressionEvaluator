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

- (void)testEvaluate
{
    XCTAssertEqual([evaluator evaluate:@"1 + 2"], (NSInteger)3);
    XCTAssertEqual([evaluator evaluate:@"15 * 2"], (NSInteger)30);
    
    XCTAssertEqual([evaluator evaluate:@"15 * 2 + 1"], (NSInteger)31);
    XCTAssertEqual([evaluator evaluate:@"15 * (2 + 1)"], (NSInteger)45);

    XCTAssertEqual([evaluator evaluate:@"2 + 1 * 2 + 2 "], (NSInteger)6);
    XCTAssertEqual([evaluator evaluate:@"(2 + 1) * (2 + 2)"], (NSInteger)12);
    
    XCTAssertEqual([evaluator evaluate:@"10/2+1-4"], (NSInteger)2);
    
    XCTAssertEqual([evaluator evaluate:@"100/2"], (NSInteger)50);
    
    XCTAssertEqual([evaluator evaluate:@"100/2/2"], (NSInteger)25);
    XCTAssertEqual([evaluator evaluate:@"(100/2)/2"], (NSInteger)25);
    XCTAssertEqual([evaluator evaluate:@"100/(2/2)"], (NSInteger)100);
    
    XCTAssertEqual([evaluator evaluate:@"-1*2"], (NSInteger)-2);
    XCTAssertEqual([evaluator evaluate:@"-1*-1"], (NSInteger)1);
    XCTAssertEqual([evaluator evaluate:@"-1*(-1+-3)"], (NSInteger)4);
    
    XCTAssertEqual([evaluator evaluate:@"x=2*3+1"], (NSInteger)7);
}

@end
