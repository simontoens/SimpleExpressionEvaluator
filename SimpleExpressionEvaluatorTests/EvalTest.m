//
//  EvalTest.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/28/13.
//  Copyright (c) 2013 Simon Toens. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Eval.h"

@interface EvalTest : XCTestCase
{
    Eval *eval;
}

@end

@implementation EvalTest

- (void)setUp
{
    [super setUp];
    eval = [[Eval alloc] init];
}

- (void)testEval1
{
    Node *root = [self v:@"+" t:kNodeTypeBinaryOperator];
    root.leftNode = [self v:@"1" t:kNodeTypeConstant];
    root.rightNode = [self v:@"2" t:kNodeTypeConstant];
    NSInteger result = [eval evaluate:root];
    XCTAssertEqual(result, 3, @"");
}

- (void)testEval2
{
    Node *root = [self v:@"+" t:kNodeTypeBinaryOperator];
    root.leftNode = [self v:@"1" t:kNodeTypeConstant];
    root.rightNode = [self v:@"*" t:kNodeTypeBinaryOperator];
    root.rightNode.leftNode = [self v:@"4" t:kNodeTypeConstant];
    root.rightNode.rightNode = [self v:@"2" t:kNodeTypeConstant];
    NSInteger result = [eval evaluate:root];
    XCTAssertEqual(result, 9, @"");
}

- (Node *)v:(NSString *)value t:(NodeType)nodeType
{
    return [[Node alloc] initWithValue:value nodeType:nodeType];
}

@end
