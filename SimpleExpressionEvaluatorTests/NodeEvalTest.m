//
//  EvalTest.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/28/13.
//  Copyright (c) 2013 Simon Toens. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Environment.h"
#import "Lexer.h"
#import "Node.h"

@interface NodeEvalTest : XCTestCase
{
    Environment *env;
    Lexer *lexer;
}

@end

@interface Lexer()
- (id)getNodesForTokenAt:(NSUInteger)currentTokenIndex allTokens:(NSArray *)allTokens;
@end

@implementation NodeEvalTest

- (void)setUp
{
    [super setUp];
    env = [[Environment alloc] init];
    lexer = [[Lexer alloc] init];
}

- (void)testAddition
{
    Node *root = [self nodeFor:@"+"];
    root.children = @[[self nodeFor:@"1"], [self nodeFor:@"2"]];
    XCTAssertEqual([self eval:root], (NSInteger)3);
}

- (void)testRightHandSideChildren
{
    Node *root = [self nodeFor:@"+"];
    Node *lc = [self nodeFor:@"1"];
    Node *rc = [self nodeFor:@"*"];
    root.children = @[lc, rc];
    rc.children = @[[self nodeFor:@"4"], [self nodeFor:@"2"]];
    XCTAssertEqual([self eval:root], (NSInteger)9);
}

- (void)testLeftHandSideChildren
{
    Node *root = [self nodeFor:@"*"];
    Node *lc = [self nodeFor:@"+"];
    Node *rc = [self nodeFor:@"3"];
    root.children = @[lc, rc];
    lc.children = @[[self nodeFor:@"1"], [self nodeFor:@"2"]];
    XCTAssertEqual([self eval:root], (NSInteger)9);
}

- (void)testAssignment
{
    Node *root = [self nodeFor:@"="];
    root.children = @[[self nodeFor:@"x"], [self nodeFor:@"2"]];
    XCTAssertEqual([self eval:root], (NSInteger)2);
}

- (void)testFunction
{
    Node *root = [self functionNodeFor:@"add"];
    root.children = @[[self nodeFor:@"1"], [self nodeFor:@"10"]];
    XCTAssertEqual([self eval:root], 11);
}

- (NSUInteger)eval:(Node *)node
{
    Node *result = [node eval:env];
    return [result.token.value integerValue];
}

- (Node *)nodeFor:(NSString *)value
{
    return [lexer getNodesForTokenAt:0 allTokens:@[[Token tokenWithValue:value]]];
}

- (Node *)functionNodeFor:(NSString *)value
{
    return [lexer getNodesForTokenAt:0 allTokens:@[[Token tokenWithValue:value], [Token tokenWithType:[TokenType openParen]]]];
}

@end