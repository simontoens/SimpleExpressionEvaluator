//  Created by Simon Toens on 11/27/13.

#import <XCTest/XCTest.h>
#import "ASTBuilder.h"
#import "Lexer.h"
#import "Node.h"
#import "Token.h"

@interface ASTBuilderTest : XCTestCase
{
    ASTBuilder *_astBuilder;
    Lexer *_lexer;
}
@end

@implementation ASTBuilderTest

- (void)setUp
{
    [super setUp];
    _astBuilder = [[ASTBuilder alloc] init];
    _lexer = [[Lexer alloc] init];
}

- (void)testAddition
{
    NSArray *nodes = [_lexer lex:@[[Token tokenWithValue:@"1" type:[TokenType constant]],
                                   [Token tokenWithValue:@"+" type:[TokenType op]],
                                   [Token tokenWithValue:@"2" type:[TokenType constant]]]];
    [self assertAST:nodes expectedPreorderTokens:@[@"+", @"1", @"2"]];
}

- (void)testMultiplication
{
    NSArray *nodes = [_lexer lex:@[[Token tokenWithValue:@"1" type:[TokenType constant]],
                                   [Token tokenWithValue:@"*" type:[TokenType op]],
                                   [Token tokenWithValue:@"2" type:[TokenType constant]]]];
    [self assertAST:nodes expectedPreorderTokens:@[@"*", @"1", @"2"]];
}

- (void)testAdditionAndMultiplication
{
    NSArray *nodes = [_lexer lex:@[[Token tokenWithValue:@"1" type:[TokenType constant]],
                                   [Token tokenWithValue:@"+" type:[TokenType op]],
                                   [Token tokenWithValue:@"2" type:[TokenType constant]],
                                   [Token tokenWithValue:@"*" type:[TokenType op]],
                                   [Token tokenWithValue:@"3" type:[TokenType constant]]]];
    [self assertAST:nodes expectedPreorderTokens:@[@"+", @"1", @"*", @"2", @"3"]];
}

- (void)testParens
{
    NSArray *nodes = [_lexer lex:@[[Token tokenWithValue:@"(" type:[TokenType openParen]],
                                   [Token tokenWithValue:@"1" type:[TokenType constant]],
                                   [Token tokenWithValue:@"+" type:[TokenType op]],
                                   [Token tokenWithValue:@"2" type:[TokenType constant]],
                                   [Token tokenWithValue:@")" type:[TokenType closeParen]],
                                   [Token tokenWithValue:@"*" type:[TokenType op]],
                                   [Token tokenWithValue:@"3" type:[TokenType constant]]]];
    [self assertAST:nodes expectedPreorderTokens:@[@"*", @"+", @"1", @"2", @"3"]];
}

- (void)testParensAroundSingleConstant
{
    NSArray *nodes = [_lexer lex:@[[Token tokenWithValue:@"(" type:[TokenType openParen]],
                                   [Token tokenWithValue:@"(" type:[TokenType openParen]],
                                   [Token tokenWithValue:@"3" type:[TokenType constant]],
                                   [Token tokenWithValue:@")" type:[TokenType closeParen]],
                                   [Token tokenWithValue:@")" type:[TokenType closeParen]],
                                   [Token tokenWithValue:@"*" type:[TokenType op]],
                                   [Token tokenWithValue:@"(" type:[TokenType openParen]],
                                   [Token tokenWithValue:@"(" type:[TokenType openParen]],
                                   [Token tokenWithValue:@"2" type:[TokenType constant]],
                                   [Token tokenWithValue:@")" type:[TokenType closeParen]],
                                   [Token tokenWithValue:@")" type:[TokenType closeParen]]]];
    [self assertAST:nodes expectedPreorderTokens:@[@"*", @"3", @"2"]];
}

- (void)testNestedParens
{
    NSArray *nodes = [_lexer lex:@[[Token tokenWithValue:@"(" type:[TokenType openParen]],
                                   [Token tokenWithValue:@"(" type:[TokenType openParen]],
                                   [Token tokenWithValue:@"1" type:[TokenType constant]],
                                   [Token tokenWithValue:@"+" type:[TokenType op]],
                                   [Token tokenWithValue:@"2" type:[TokenType constant]],
                                   [Token tokenWithValue:@")" type:[TokenType closeParen]],
                                   [Token tokenWithValue:@")" type:[TokenType closeParen]],
                                   [Token tokenWithValue:@"*" type:[TokenType op]],
                                   [Token tokenWithValue:@"(" type:[TokenType openParen]],
                                   [Token tokenWithValue:@"(" type:[TokenType openParen]],
                                   [Token tokenWithValue:@"(" type:[TokenType openParen]],
                                   [Token tokenWithValue:@"3" type:[TokenType constant]],
                                   [Token tokenWithValue:@"-" type:[TokenType op]],
                                   [Token tokenWithValue:@"4" type:[TokenType constant]],
                                   [Token tokenWithValue:@")" type:[TokenType closeParen]],
                                   [Token tokenWithValue:@")" type:[TokenType closeParen]],
                                   [Token tokenWithValue:@")" type:[TokenType closeParen]]]];
    [self assertAST:nodes expectedPreorderTokens:@[@"*", @"+", @"1", @"2", @"-", @"3", @"4"]];
}

- (void)testAssignment1
{
    NSArray *nodes = [_lexer lex:@[[Token tokenWithValue:@"x" type:[TokenType identifier]],
                                   [Token tokenWithValue:@"=" type:[TokenType assign]],
                                   [Token tokenWithValue:@"1" type:[TokenType constant]]]];
    [self assertAST:nodes expectedPreorderTokens:@[@"=", @"x", @"1"]];
}

- (void)testAssignment2
{
    NSArray *nodes = [_lexer lex:@[[Token tokenWithValue:@"x" type:[TokenType identifier]],
                                   [Token tokenWithValue:@"=" type:[TokenType assign]],
                                   [Token tokenWithValue:@"1" type:[TokenType constant]],
                                   [Token tokenWithValue:@"*" type:[TokenType op]],
                                   [Token tokenWithValue:@"2" type:[TokenType constant]]]];
    [self assertAST:nodes expectedPreorderTokens:@[@"=", @"x", @"*", @"1", @"2"]];
}

- (void)testAssignmentIsRightAssociative
{
    NSArray *nodes = [_lexer lex:@[[Token tokenWithValue:@"a" type:[TokenType identifier]],
                                   [Token tokenWithValue:@"=" type:[TokenType assign]],
                                   [Token tokenWithValue:@"b" type:[TokenType identifier]],
                                   [Token tokenWithValue:@"=" type:[TokenType assign]],
                                   [Token tokenWithValue:@"3" type:[TokenType constant]]]];
    [self assertAST:nodes expectedPreorderTokens:@[@"=", @"a", @"=", @"b", @"3"]];
}

- (void)testOtherOperatorsAreRightAssociative
{
    NSArray *nodes = [_lexer lex:@[[Token tokenWithValue:@"3" type:[TokenType constant]],
                                   [Token tokenWithValue:@"-" type:[TokenType op]],
                                   [Token tokenWithValue:@"2" type:[TokenType constant]],
                                   [Token tokenWithValue:@"-" type:[TokenType op]],
                                   [Token tokenWithValue:@"1" type:[TokenType constant]]]];
    [self assertAST:nodes expectedPreorderTokens:@[@"-", @"-", @"3", @"2", @"1"]];
}

- (void)testFunctionWithConstantArguments
{
    NSArray *nodes = [_lexer lex:@[[Token tokenWithValue:@"f" type:[TokenType identifier]],
                                   [Token tokenWithValue:@"(" type:[TokenType openParen]],
                                   [Token tokenWithValue:@"1" type:[TokenType constant]],
                                   [Token tokenWithValue:@")" type:[TokenType closeParen]],
                                   [Token tokenWithValue:@"(" type:[TokenType openParen]],
                                   [Token tokenWithValue:@"2" type:[TokenType constant]],
                                   [Token tokenWithValue:@")" type:[TokenType closeParen]]]];
    [self assertAST:nodes expectedPreorderTokens:@[@"f", @"1", @"2"]];
}

- (void)testFunctionWithExpressionArguments
{
    NSArray *nodes = [_lexer lex:@[[Token tokenWithValue:@"f" type:[TokenType identifier]],
                                   [Token tokenWithValue:@"(" type:[TokenType openParen]],
                                   [Token tokenWithValue:@"1" type:[TokenType constant]],
                                   [Token tokenWithValue:@"+" type:[TokenType op]],
                                   [Token tokenWithValue:@"2" type:[TokenType constant]],
                                   [Token tokenWithValue:@")" type:[TokenType closeParen]],
                                   [Token tokenWithValue:@"(" type:[TokenType openParen]],
                                   [Token tokenWithValue:@"11" type:[TokenType constant]],
                                   [Token tokenWithValue:@")" type:[TokenType closeParen]]]];
    [self assertAST:nodes expectedPreorderTokens:@[@"f", @"+", @"1", @"2", @"11"]];
}

- (void)testFunctionWithPostExpression
{
    NSArray *nodes = [_lexer lex:@[[Token tokenWithValue:@"f" type:[TokenType identifier]],
                                   [Token tokenWithValue:@"(" type:[TokenType openParen]],
                                   [Token tokenWithValue:@"1" type:[TokenType constant]],
                                   [Token tokenWithValue:@")" type:[TokenType closeParen]],
                                   [Token tokenWithValue:@"(" type:[TokenType openParen]],
                                   [Token tokenWithValue:@"2" type:[TokenType constant]],
                                   [Token tokenWithValue:@")" type:[TokenType closeParen]],
                                   [Token tokenWithValue:@"+" type:[TokenType op]],
                                   [Token tokenWithValue:@"7" type:[TokenType constant]]]];
    [self assertAST:nodes expectedPreorderTokens:@[@"+", @"f", @"1", @"2", @"7"]];
}

- (void)testFunctionWithPreExpression
{
    NSArray *nodes = [_lexer lex:@[[Token tokenWithValue:@"7" type:[TokenType constant]],
                                  [Token tokenWithValue:@"-" type:[TokenType op]],
                                  [Token tokenWithValue:@"f" type:[TokenType identifier]],
                                  [Token tokenWithValue:@"(" type:[TokenType openParen]],
                                  [Token tokenWithValue:@"1" type:[TokenType constant]],
                                  [Token tokenWithValue:@")" type:[TokenType closeParen]],
                                  [Token tokenWithValue:@"(" type:[TokenType openParen]],
                                  [Token tokenWithValue:@"2" type:[TokenType constant]],
                                  [Token tokenWithValue:@")" type:[TokenType closeParen]]]];
    [self assertAST:nodes expectedPreorderTokens:@[@"-", @"7", @"f", @"1", @"2"]];
}

- (void)testTwoFunctions
{
    NSArray *nodes = [_lexer lex:@[[Token tokenWithValue:@"f" type:[TokenType identifier]],
                                   [Token tokenWithValue:@"(" type:[TokenType openParen]],
                                   [Token tokenWithValue:@"1" type:[TokenType constant]],
                                   [Token tokenWithValue:@")" type:[TokenType closeParen]],
                                   [Token tokenWithValue:@"(" type:[TokenType openParen]],
                                   [Token tokenWithValue:@"2" type:[TokenType constant]],
                                   [Token tokenWithValue:@")" type:[TokenType closeParen]],
                                   [Token tokenWithValue:@"*" type:[TokenType op]],
                                   [Token tokenWithValue:@"f" type:[TokenType identifier]],
                                   [Token tokenWithValue:@"(" type:[TokenType openParen]],
                                   [Token tokenWithValue:@"3" type:[TokenType constant]],
                                   [Token tokenWithValue:@")" type:[TokenType closeParen]],
                                   [Token tokenWithValue:@"(" type:[TokenType openParen]],
                                   [Token tokenWithValue:@"4" type:[TokenType constant]],
                                   [Token tokenWithValue:@")" type:[TokenType closeParen]]]];
    [self assertAST:nodes expectedPreorderTokens:@[@"*", @"f", @"1", @"2", @"f", @"3", @"4"]];
}

- (void)assertAST:(NSArray *)nodes expectedPreorderTokens:(NSArray *)expectedNodes
{
    ASTBuilder *astBuilder = [[ASTBuilder alloc] init];
    Node *ast = [astBuilder build:nodes];
    NSArray *preorderderNodes = [self preorder:ast];
    XCTAssertEqual([preorderderNodes count], [expectedNodes count], @"Unexpected node count, preorder nodes are %@", preorderderNodes);
    
    for (int i = 0; i < [preorderderNodes count]; i++)
    {
        Node *node = [preorderderNodes objectAtIndex:i];
        XCTAssertEqualObjects(node.value, [expectedNodes objectAtIndex:i], @"Unexpected token value");
    }
}

- (NSArray *)preorder:(Node *)rootNode
{
    NSMutableArray *nodes = [[NSMutableArray alloc] init];
    [self preorder:rootNode collectInto:nodes];
    return nodes;
}

- (void)preorder:(Node *)node collectInto:(NSMutableArray *)nodes
{
    [nodes addObject:node];
    if ([node.children count] >= 1)
    {
        [self preorder:[node.children objectAtIndex:0] collectInto:nodes];
    }
    if ([node.children count] >= 2)
    {
        [self preorder:[node.children objectAtIndex:1] collectInto:nodes];
    }
}

@end