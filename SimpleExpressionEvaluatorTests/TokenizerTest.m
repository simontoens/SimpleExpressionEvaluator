//
//  TokenizerTest.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/29/13.
//  Copyright (c) 2013 Simon Toens. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Node.h"
#import "Tokenizer.h"

@interface Tokenizer()
- (NSArray *)split:(NSString *)expression;
- (NodeType)getNodeType:(NSString *)token;
- (NSUInteger)getPrecedenceForToken:(NSString *)token ofType:(NodeType)type;
@end

@interface TokenizerTest : XCTestCase
{
    Tokenizer *tokenizer;
}

@end

@implementation TokenizerTest

- (void)setUp
{
    [super setUp];
    tokenizer = [[Tokenizer alloc] init];
}

- (void)testSplit
{
    NSArray *expected = [NSArray arrayWithObjects:@"1", nil];
    XCTAssertEqualObjects([tokenizer split:@"1"], expected);
    
    [NSArray arrayWithObjects:@" 1  ", nil];
    XCTAssertEqualObjects([tokenizer split:@"1"], expected);
    
    expected = [NSArray arrayWithObjects:@"1", @"2", @"3", nil];
    XCTAssertEqualObjects([tokenizer split:@" 1  2   3  "], expected);
    
    expected = [NSArray arrayWithObjects:@"1", @"+", @"3", nil];
    XCTAssertEqualObjects([tokenizer split:@"1 + 3"], expected);
    
    expected = [NSArray arrayWithObjects:@"1", @"+", @"3", nil];
    XCTAssertEqualObjects([tokenizer split:@"1+3"], expected);
    
    expected = [NSArray arrayWithObjects:@"1", @"+", @"(", @"3", @")", nil];
    XCTAssertEqualObjects([tokenizer split:@"1+(3)"], expected);
    
    expected = [NSArray arrayWithObjects:@"1", @"/", @"2", @"-", @"3", nil];
    XCTAssertEqualObjects([tokenizer split:@"1/2-3"], expected);
    
    expected = [NSArray arrayWithObjects:@"-1", nil];
    XCTAssertEqualObjects([tokenizer split:@"-1"], expected);
    
    expected = [NSArray arrayWithObjects:@"-1", @"+", @"3", nil];
    XCTAssertEqualObjects([tokenizer split:@"-1+3"], expected);
    
    expected = [NSArray arrayWithObjects:@"-1", @"*", @"-3", nil];
    XCTAssertEqualObjects([tokenizer split:@"-1*-3"], expected);
    
    expected = [NSArray arrayWithObjects:@"-1", @"*", @"(", @"-3", @")", nil];
    XCTAssertEqualObjects([tokenizer split:@"-1*(-3)"], expected);
    
    expected = [NSArray arrayWithObjects:@"=", nil];
    XCTAssertEqualObjects([tokenizer split:@"="], expected);
    
    expected = [NSArray arrayWithObjects:@"x", @"=", @"1", nil];
    XCTAssertEqualObjects([tokenizer split:@"x=1"], expected);

    expected = [NSArray arrayWithObjects:@"myvar", @"=", @"1", nil];
    XCTAssertEqualObjects([tokenizer split:@"myvar=1"], expected);
}

- (void)testGetNodeType
{
    XCTAssertEqual([tokenizer getNodeType:@"2a3"], kNodeTypeUnknown);
    XCTAssertEqual([tokenizer getNodeType:@"1.533"], kNodeTypeUnknown);
    XCTAssertEqual([tokenizer getNodeType:@"1,533"], kNodeTypeUnknown);

    XCTAssertEqual([tokenizer getNodeType:@"1533"], kNodeTypeConstant);
    XCTAssertEqual([tokenizer getNodeType:@"+"], kNodeTypeBinaryOperator);
    XCTAssertEqual([tokenizer getNodeType:@"-"], kNodeTypeBinaryOperator);
    XCTAssertEqual([tokenizer getNodeType:@"*"], kNodeTypeBinaryOperator);
    XCTAssertEqual([tokenizer getNodeType:@"/"], kNodeTypeBinaryOperator);
    XCTAssertEqual([tokenizer getNodeType:@"("], kNodeTypeParen);
    XCTAssertEqual([tokenizer getNodeType:@")"], kNodeTypeParen);
    
    XCTAssertEqual([tokenizer getNodeType:@"-1"], kNodeTypeConstant);
    XCTAssertEqual([tokenizer getNodeType:@"+3"], kNodeTypeConstant);
    XCTAssertEqual([tokenizer getNodeType:@"*3"], kNodeTypeUnknown);
    XCTAssertEqual([tokenizer getNodeType:@"/3"], kNodeTypeUnknown);
    
    XCTAssertEqual([tokenizer getNodeType:@"="], kNodeTypeAssignment);
    
    XCTAssertEqual([tokenizer getNodeType:@"a"], kNodeTypeIdentifier);
    XCTAssertEqual([tokenizer getNodeType:@"abc"], kNodeTypeIdentifier);
    XCTAssertEqual([tokenizer getNodeType:@"abc1"], kNodeTypeUnknown);
}

- (void)testPrecedence
{
    XCTAssertTrue([tokenizer getPrecedenceForToken:@"+" ofType:kNodeTypeBinaryOperator] >
                  [tokenizer getPrecedenceForToken:@"(" ofType:kNodeTypeParen]);
    
    XCTAssertTrue([tokenizer getPrecedenceForToken:@"+" ofType:kNodeTypeBinaryOperator] ==
                  [tokenizer getPrecedenceForToken:@"-" ofType:kNodeTypeBinaryOperator]);
    
    XCTAssertTrue([tokenizer getPrecedenceForToken:@"*" ofType:kNodeTypeBinaryOperator] >
                  [tokenizer getPrecedenceForToken:@"-" ofType:kNodeTypeBinaryOperator]);
    
    XCTAssertTrue([tokenizer getPrecedenceForToken:@"*" ofType:kNodeTypeBinaryOperator] ==
                  [tokenizer getPrecedenceForToken:@"/" ofType:kNodeTypeBinaryOperator]);
    
    XCTAssertTrue([tokenizer getPrecedenceForToken:@")" ofType:kNodeTypeParen] >
                  [tokenizer getPrecedenceForToken:@"*" ofType:kNodeTypeBinaryOperator]);
}

- (void)testTokenize
{
    NSString *expression = @"1 + 2";
    NSArray *tokens = [tokenizer tokenize:expression];
    XCTAssertEqual([tokens count], (NSUInteger)3);
    
    XCTAssertEqualObjects(((Node *)[tokens objectAtIndex:0]).value, @"1");
    XCTAssertTrue(((Node *)[tokens objectAtIndex:0]).precedence > 0);
    
    XCTAssertEqualObjects(((Node *)[tokens objectAtIndex:1]).value, @"+");
    XCTAssertTrue(((Node *)[tokens objectAtIndex:1]).precedence > 0);
    
    XCTAssertEqualObjects(((Node *)[tokens objectAtIndex:2]).value, @"2");
    XCTAssertTrue(((Node *)[tokens objectAtIndex:2]).precedence > 0);
}

@end
