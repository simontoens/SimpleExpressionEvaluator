//
//  LexerTest.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 10/18/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Lexer.h"
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

- (void)testPrecedence
{
    XCTAssertTrue([_lexer getPrecedence:[[Token alloc] initWithValue:@"=" type:[TokenType assign]]] ==
                  [_lexer getPrecedence:[[Token alloc] initWithValue:@"2" type:[TokenType constant]]]);
                    
    XCTAssertTrue([_lexer getPrecedence:[[Token alloc] initWithValue:@"a" type:[TokenType identifier]]] ==
                  [_lexer getPrecedence:[[Token alloc] initWithValue:@"2" type:[TokenType constant]]]);
                                                                                                                      
    XCTAssertTrue([_lexer getPrecedence:[[Token alloc] initWithValue:@"+" type:[TokenType op]]] >
                  [_lexer getPrecedence:[[Token alloc] initWithValue:@"(" type:[TokenType openParen]]]);
                                                                                                  
    XCTAssertTrue([_lexer getPrecedence:[[Token alloc] initWithValue:@"+" type:[TokenType op]]] ==
                  [_lexer getPrecedence:[[Token alloc] initWithValue:@"-" type:[TokenType op]]]);
                                                                                                                  
    XCTAssertTrue([_lexer getPrecedence:[[Token alloc] initWithValue:@"*" type:[TokenType op]]] >
                  [_lexer getPrecedence:[[Token alloc] initWithValue:@"-" type:[TokenType op]]]);
                                                                                                                                  
    XCTAssertTrue([_lexer getPrecedence:[[Token alloc] initWithValue:@"*" type:[TokenType op]]] ==
                  [_lexer getPrecedence:[[Token alloc] initWithValue:@"/" type:[TokenType op]]]);
                                                                                                                                                  
    XCTAssertTrue([_lexer getPrecedence:[[Token alloc] initWithValue:@")" type:[TokenType closeParen]]] >
                  [_lexer getPrecedence:[[Token alloc] initWithValue:@"*" type:[TokenType op]]]);
}

@end