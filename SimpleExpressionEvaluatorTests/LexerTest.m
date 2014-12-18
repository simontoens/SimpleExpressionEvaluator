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

@interface Lexer()
- (NSUInteger)getPrecedence:(Token *)token;
@end;

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
    
    NSArray *expectedTokens = @[[Token tokenWithValue:@"f" type:[TokenType identifier]],
                                [Token tokenWithValue:@"(" type:[TokenType openParen]],
                                [Token tokenWithValue:@"3" type:[TokenType constant]],
                                [Token tokenWithValue:@")" type:[TokenType closeParen]],
                                [Token tokenWithValue:@"(" type:[TokenType openParen]],
                                [Token tokenWithValue:@"4" type:[TokenType constant]],
                                [Token tokenWithValue:@")" type:[TokenType closeParen]],
                                [Token tokenWithValue:@"(" type:[TokenType openParen]],
                                [Token tokenWithValue:@"5" type:[TokenType constant]],
                                [Token tokenWithValue:@")" type:[TokenType closeParen]]];
    
    [self assertTokenTypes:expectedTokens nodes:[_lexer lex:inputTokens]];
    
}

- (void)assertTokenTypes:(NSArray *)expectedTokenTypes nodes:(NSArray *)nodes
{
    NSMutableArray *actualTokenTypes = [[NSMutableArray alloc] init];
    for (Node *node in nodes)
    {
        [actualTokenTypes addObject:node.token];
    }
    XCTAssertEqualObjects(actualTokenTypes, expectedTokenTypes);
}

@end