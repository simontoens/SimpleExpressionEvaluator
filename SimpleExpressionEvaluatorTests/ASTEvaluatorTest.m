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
    Node *result = [eval compute:[self v:@"+" t:[TokenType op]] arg1:[self v:@"1"] arg2:[self v:@"3"]];
    XCTAssertEqualObjects(result.value, @"4");
    
    result = [eval compute:[self v:@"*" t:[TokenType op]] arg1:[self v:@"2"] arg2:[self v:@"3"]];
    XCTAssertEqualObjects(result.value, @"6");
    
    result = [eval compute:[self v:@"-" t:[TokenType op]] arg1:[self v:@"2"] arg2:[self v:@"3"]];
    XCTAssertEqualObjects(result.value, @"-1");
    
    result = [eval compute:[self v:@"/" t:[TokenType op]] arg1:[self v:@"16"] arg2:[self v:@"4"]];
    XCTAssertEqualObjects(result.value, @"4");
    
    result = [eval compute:[self v:@"=" t:[TokenType assign]] arg1:[self v:@"x"] arg2:[self v:@"4"]];
    XCTAssertEqualObjects(result.value, @"4");
}

- (void)testEvalBinOp1
{
    Node *root = [self v:@"+" t:[TokenType op]];
    root.left = [self v:@"1" t:[TokenType constant]];
    root.right = [self v:@"2" t:[TokenType constant]];
    NSInteger result = [eval evaluate:root];
    XCTAssertEqual(result, (NSInteger)3);
}

- (void)testEvalBinOp2
{
    Node *root = [self v:@"+" t:[TokenType op]];
    root.left = [self v:@"1" t:[TokenType constant]];
    root.right = [self v:@"*" t:[TokenType op]];
    root.right.left = [self v:@"4" t:[TokenType constant]];
    root.right.right = [self v:@"2" t:[TokenType constant]];
    NSInteger result = [eval evaluate:root];
    XCTAssertEqual(result, (NSInteger)9);
}

- (void)testEvalBinOp3
{
    Node *root = [self v:@"*" t:[TokenType op]];
    root.left = [self v:@"+" t:[TokenType op]];
    root.left.left = [self v:@"1" t:[TokenType constant]];
    root.left.right = [self v:@"2" t:[TokenType constant]];
    root.right = [self v:@"3" t:[TokenType constant]];
    NSInteger result = [eval evaluate:root];
    XCTAssertEqual(result, (NSInteger)9);
}

- (void)testEvalAssignment
{
    Node *root = [self v:@"=" t:[TokenType assign]];
    root.left = [self v:@"x" t:[TokenType identifier]];
    root.right = [self v:@"2" t:[TokenType constant]];
    NSInteger result = [eval evaluate:root];
    XCTAssertEqual(result, (NSInteger)2);
}

- (Node *)v:(NSString *)value
{
    return [self v:value t:nil];
}
     
- (Node *)v:(NSString *)value t:(TokenType *)tokenType
{
    Node *n = [[Node alloc] init];
    n.value = value;
    n.type = tokenType;
    return n;
}

@end
