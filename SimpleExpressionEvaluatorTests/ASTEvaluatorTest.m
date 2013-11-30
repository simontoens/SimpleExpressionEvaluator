//
//  EvalTest.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/28/13.
//  Copyright (c) 2013 Simon Toens. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ASTEvaluator.h"

@interface ASTEvaluator()
- (Node *)compute:(Node *)operator arg1:(Node *)op1 arg2:(Node *)op2;
@end

@interface ASTEvaluatorTest : XCTestCase
{
    ASTEvaluator *eval;
}

@end

@implementation ASTEvaluatorTest

- (void)setUp
{
    [super setUp];
    eval = [[ASTEvaluator alloc] init];
}

- (void)testCompute
{
    Node *result = [eval compute:[self v:@"+"] arg1:[self v:@"1"] arg2:[self v:@"3"]];
    XCTAssertEqualObjects(result.value, @"4", @"");
    
    result = [eval compute:[self v:@"*"] arg1:[self v:@"2"] arg2:[self v:@"3"]];
    XCTAssertEqualObjects(result.value, @"6", @"");
    
    result = [eval compute:[self v:@"-"] arg1:[self v:@"2"] arg2:[self v:@"3"]];
    XCTAssertEqualObjects(result.value, @"-1", @"");
    
    result = [eval compute:[self v:@"/"] arg1:[self v:@"16"] arg2:[self v:@"4"]];
    XCTAssertEqualObjects(result.value, @"4", @"");
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

- (Node *)v:(NSString *)value
{
    return [self v:value t:kNodeTypeUnknown];
}
     
- (Node *)v:(NSString *)value t:(NodeType)nodeType
{
    Node *n = [[Node alloc] init];
    n.value = value;
    n.type = nodeType;
    return n;
}

@end
