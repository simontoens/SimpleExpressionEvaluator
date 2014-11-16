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

- (void)testEvaluateExpressions
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
}

- (void)testEvaluateExpressionsWithVariables
{
    XCTAssertEqual([evaluator evaluate:@"x=2*3+1"], (NSInteger)7);
    XCTAssertEqual([evaluator evaluate:@"x"], (NSInteger)7);

    XCTAssertEqual([evaluator evaluate:@"a=1"], (NSInteger)1);
    XCTAssertEqual([evaluator evaluate:@"b=2"], (NSInteger)2);
    XCTAssertEqual([evaluator evaluate:@"a"], (NSInteger)1);
    XCTAssertEqual([evaluator evaluate:@"b"], (NSInteger)2);
    XCTAssertEqual([evaluator evaluate:@"a+b"], (NSInteger)3);
    
    XCTAssertEqual([evaluator evaluate:@"x*a+b"], (NSInteger)9);
}

- (void)testEvaluateUndefinedVariable
{
    XCTAssertEqual([evaluator evaluate:@"x"], (NSInteger)0);
}

- (void)testReassignVariables
{
    XCTAssertEqual([evaluator evaluate:@"a=1"], (NSInteger)1);
    XCTAssertEqual([evaluator evaluate:@"a=2"], (NSInteger)2);
    XCTAssertEqual([evaluator evaluate:@"a"], (NSInteger)2);
}

- (void)testMultipleAssignmentsInOneStatement
{
    XCTAssertEqual([evaluator evaluate:@"a=b=3"], (NSInteger)3);
    XCTAssertEqual([evaluator evaluate:@"a"], (NSInteger)3);
    XCTAssertEqual([evaluator evaluate:@"b"], (NSInteger)3);
}

- (void)testEvaluateFunction
{
    XCTAssertEqual([evaluator evaluate:@"f((1+2) (2*2))"], (NSInteger)7);
    XCTAssertEqual([evaluator evaluate:@"f(1 2)"], (NSInteger)3);
}

@end