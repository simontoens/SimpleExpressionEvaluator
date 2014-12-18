//
//  LexerTest.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 10/18/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Lexer.h"
#import "Node.h"
#import "Token.h"

@interface LexerTest : XCTestCase
@end

@implementation LexerTest
{
    Lexer *_lexer;
}

- (void)setUp
{
    [super setUp];
    _lexer = [[Lexer alloc] init];
}

- (void)testProcessArgSeparators
{
    NSArray *inputTokens = @[[Token tokenWithValue:@"f" type:[TokenType identifier]],
                             [Token tokenWithValue:@"(" type:[TokenType openParen]],
                             [Token tokenWithValue:@"3" type:[TokenType constant]],
                             [Token tokenWithValue:@"," type:[TokenType argSep]],
                             [Token tokenWithValue:@"4" type:[TokenType constant]],
                             [Token tokenWithValue:@"," type:[TokenType argSep]],
                             [Token tokenWithValue:@"5" type:[TokenType constant]],
                             [Token tokenWithValue:@")" type:[TokenType closeParen]]];
    
    NSArray *expectedValues = @[@"f", @"[", @"3", @"]", @"[", @"4", @"]", @"[", @"5", @"]"];
    
    [self assertNodeValues:expectedValues nodes:[_lexer lex:inputTokens]];
    
}

- (void)assertNodeValues:(NSArray *)expectedNodeValues nodes:(NSArray *)nodes
{
    NSMutableArray *actualNodeValues = [[NSMutableArray alloc] init];
    for (Node *node in nodes)
    {
        [actualNodeValues addObject:node.value];
    }
    XCTAssertEqualObjects(actualNodeValues, expectedNodeValues);
}

@end