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
    XCTAssertEqualObjects(result.token.value, @"4");
    
    result = [eval compute:[self v:@"*" t:[TokenType op]] arg1:[self v:@"2"] arg2:[self v:@"3"]];
    XCTAssertEqualObjects(result.token.value, @"6");
    
    result = [eval compute:[self v:@"-" t:[TokenType op]] arg1:[self v:@"2"] arg2:[self v:@"3"]];
    XCTAssertEqualObjects(result.token.value, @"-1");
    
    result = [eval compute:[self v:@"/" t:[TokenType op]] arg1:[self v:@"16"] arg2:[self v:@"4"]];
    XCTAssertEqualObjects(result.token.value, @"4");
   
    result = [eval compute:[self v:@"=" t:[TokenType assign]] arg1:[self v:@"x"] arg2:[self v:@"4"]];
    XCTAssertEqualObjects(result.token.value, @"4");
}

- (void)testAddition
{
    Node *root = [self v:@"+" t:[TokenType op]];
    root.childNodes = @[[self v:@"1" t:[TokenType constant]],
                        [self v:@"2" t:[TokenType constant]]];
    XCTAssertEqual([eval evaluate:root], (NSInteger)3);
}

- (void)testRightHandSideChildren
{
    Node *root = [self v:@"+" t:[TokenType op]];
    Node *lc = [self v:@"1" t:[TokenType constant]];
    Node *rc = [self v:@"*" t:[TokenType op]];
    root.childNodes = @[lc, rc];
    rc.childNodes = @[[self v:@"4" t:[TokenType constant]],
                      [self v:@"2" t:[TokenType constant]]];
    NSInteger result = [eval evaluate:root];
    XCTAssertEqual(result, (NSInteger)9);
}

- (void)testLeftHandSideChildren
{
    Node *root = [self v:@"*" t:[TokenType op]];
    Node *lc = [self v:@"+" t:[TokenType op]];
    Node *rc = [self v:@"3" t:[TokenType constant]];
    root.childNodes = @[lc, rc];
    lc.childNodes = @[[self v:@"1" t:[TokenType constant]],
                      [self v:@"2" t:[TokenType constant]]];
    NSInteger result = [eval evaluate:root];
    XCTAssertEqual(result, (NSInteger)9);
}

- (void)testAssignment
{
    Node *root = [self v:@"=" t:[TokenType assign]];
    root.childNodes = @[[self v:@"x" t:[TokenType identifier]], [self v:@"2" t:[TokenType constant]]];
    NSInteger result = [eval evaluate:root];
    XCTAssertEqual(result, (NSInteger)2);
}

- (void)testFunction
{
    Node *root = [Node nodeWithToken:[Token tokenWithValue:@"add"] nodeType:[NodeType func]];
    root.childNodes = @[[self v:@"1"],
                        [self v:@"10"]];
    XCTAssertEqual([eval evaluate:root], 11);
}

- (Node *)v:(NSString *)value
{
    return [self v:value t:[TokenType constant]];
}
     
- (Node *)v:(NSString *)value t:(TokenType *)type
{
    return [Node nodeWithToken:[Token tokenWithValue:value type:type]];
}

@end