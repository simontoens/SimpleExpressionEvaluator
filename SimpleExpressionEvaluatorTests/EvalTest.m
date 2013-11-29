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
    root.left = [self v:@"1" t:kNodeTypeConstant];
    root.right = [self v:@"2" t:kNodeTypeConstant];
    NSInteger result = [eval evaluate:root];
    XCTAssertEqual(result, 3, @"");
}

- (void)testEval2
{
    Node *root = [self v:@"+" t:kNodeTypeBinaryOperator];
    root.left = [self v:@"1" t:kNodeTypeConstant];
    root.right = [self v:@"*" t:kNodeTypeBinaryOperator];
    root.right.left = [self v:@"4" t:kNodeTypeConstant];
    root.right.right = [self v:@"2" t:kNodeTypeConstant];
    NSInteger result = [eval evaluate:root];
    XCTAssertEqual(result, 9, @"");
}

- (void)testEval3
{
    Node *root = [self v:@"*" t:kNodeTypeBinaryOperator];
    root.left = [self v:@"+" t:kNodeTypeBinaryOperator];
    root.left.left = [self v:@"1" t:kNodeTypeConstant];
    root.left.right = [self v:@"2" t:kNodeTypeConstant];
    root.right = [self v:@"3" t:kNodeTypeConstant];
    NSInteger result = [eval evaluate:root];
    XCTAssertEqual(result, 9, @"");
}

- (Node *)v:(NSString *)value t:(NodeType)nodeType
{
    Node *n = [[Node alloc] init];
    n.value = value;
    n.type = nodeType;
    return n;
}

@end
