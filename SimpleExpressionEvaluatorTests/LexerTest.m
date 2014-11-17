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

- (void)testNodeType
{
    NSArray *tokens = @[[Token tokenWithValue:@"1" type:[TokenType constant]]];
    [self assertNodeTypes:@[[NSNull null]] nodes:[_lexer lex:tokens]];
    
    tokens = @[[Token tokenWithValue:@"f" type:[TokenType identifier]],
               [Token tokenWithValue:@"=" type:[TokenType assign]],
               [Token tokenWithValue:@"3" type:[TokenType constant]]];
    [self assertNodeTypes:@[[NSNull null], [NSNull null], [NSNull null]] nodes:[_lexer lex:tokens]];
    
    tokens = @[[Token tokenWithValue:@"f" type:[TokenType identifier]],
               [Token tokenWithValue:@"(" type:[TokenType openParen]],
               [Token tokenWithValue:@"3" type:[TokenType constant]]];
    [self assertNodeTypes:@[[NodeType func], [NSNull null], [NSNull null]] nodes:[_lexer lex:tokens]];
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

- (void)testPrecedence
{
    XCTAssertTrue([_lexer getPrecedence:[Token tokenWithValue:@"=" type:[TokenType assign]]] ==
                  [_lexer getPrecedence:[Token tokenWithValue:@"2" type:[TokenType constant]]]);
                    
    XCTAssertTrue([_lexer getPrecedence:[Token tokenWithValue:@"a" type:[TokenType identifier]]] ==
                  [_lexer getPrecedence:[Token tokenWithValue:@"2" type:[TokenType constant]]]);
                                                                                                                      
    XCTAssertTrue([_lexer getPrecedence:[Token tokenWithValue:@"+" type:[TokenType op]]] >
                  [_lexer getPrecedence:[Token tokenWithValue:@"(" type:[TokenType openParen]]]);
                                                                                                  
    XCTAssertTrue([_lexer getPrecedence:[Token tokenWithValue:@"+" type:[TokenType op]]] ==
                  [_lexer getPrecedence:[Token tokenWithValue:@"-" type:[TokenType op]]]);
                                                                                                                  
    XCTAssertTrue([_lexer getPrecedence:[Token tokenWithValue:@"*" type:[TokenType op]]] >
                  [_lexer getPrecedence:[Token tokenWithValue:@"-" type:[TokenType op]]]);
                                                                                                                                  
    XCTAssertTrue([_lexer getPrecedence:[Token tokenWithValue:@"*" type:[TokenType op]]] ==
                  [_lexer getPrecedence:[Token tokenWithValue:@"/" type:[TokenType op]]]);
                                                                                                                                                  
    XCTAssertTrue([_lexer getPrecedence:[Token tokenWithValue:@")" type:[TokenType closeParen]]] >
                  [_lexer getPrecedence:[Token tokenWithValue:@"*" type:[TokenType op]]]);
}

- (void)assertNodeTypes:(NSArray *)expectedNodeTypes nodes:(NSArray *)nodes
{
    XCTAssertEqual([nodes count], [expectedNodeTypes count], @"Unexpected number of nodes");
    for (NSUInteger i = 0 ; i < [nodes count]; i++)
    {
        if ([expectedNodeTypes objectAtIndex:i] == [NSNull null])
        {
            XCTAssertNil(((Node *)[nodes objectAtIndex:i]).type, @"Expected Node.type to be nil");
        }
        else
        {
            XCTAssertEqual(((Node *)[nodes objectAtIndex:i]).type, [expectedNodeTypes objectAtIndex:i], @"Unexpected node type at index %lu", i);
        }
    }
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