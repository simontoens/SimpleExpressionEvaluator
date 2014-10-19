//  Created by Simon Toens on 11/27/13.

#import <XCTest/XCTest.h>
#import "ASTBuilder.h"
#import "Lexer.h"
#import "Node.h"
#import "Token.h"

@interface ASTBuilderTest : XCTestCase
{
    Lexer *_lexer;
}
@end

@interface Node()
- (NSArray *)preorder;
@end;

@interface Lexer()
- (NSUInteger)getPrecedenceForToken:(Token *)token;
@end

@implementation ASTBuilderTest

- (void)setUp
{
    [super setUp];
    _lexer = [[Lexer alloc] init];
}

- (void)testSimpleAddition
{
    NSArray *tokens = @[[self v:@"1" t:[TokenType constant]],
                        [self v:@"+" t:[TokenType op]],
                        [self v:@"2" t:[TokenType constant]]];
    [self assertAST:tokens expectedPreorderTokens:@[@"+", @"1", @"2"]];
}

- (void)testSimpleMultiplication
{
    NSArray *tokens = @[[self v:@"1" t:[TokenType constant]],
                        [self v:@"*" t:[TokenType op]],
                        [self v:@"2" t:[TokenType constant]]];
    [self assertAST:tokens expectedPreorderTokens:@[@"*", @"1", @"2"]];
}

- (void)testExpr2
{
    NSArray *tokens = @[[self v:@"1" t:[TokenType constant]],
                        [self v:@"+" t:[TokenType op]],
                        [self v:@"2" t:[TokenType constant]],
                        [self v:@"*" t:[TokenType op]],
                        [self v:@"3" t:[TokenType constant]]];
    [self assertAST:tokens expectedPreorderTokens:@[@"+", @"1", @"*", @"2", @"3"]];
}

- (void)testExprWithParens1
{
    NSArray *tokens = @[[self v:@"(" t:[TokenType openParen]],
                        [self v:@"1" t:[TokenType constant]],
                        [self v:@"+" t:[TokenType op]],
                        [self v:@"2" t:[TokenType constant]],
                        [self v:@")" t:[TokenType closeParen]],
                        [self v:@"*" t:[TokenType op]],
                        [self v:@"3" t:[TokenType constant]]];
    [self assertAST:tokens expectedPreorderTokens:@[@"*", @"+", @"1", @"2", @"3"]];
}

- (void)testAssignment1
{
    NSArray *tokens = @[[self v:@"x" t:[TokenType identifier]],
                        [self v:@"=" t:[TokenType assign]],
                        [self v:@"1" t:[TokenType constant]]];
    [self assertAST:tokens expectedPreorderTokens:@[@"=", @"x", @"1"]];
}

- (void)testAssignment2
{
    NSArray *tokens = @[[self v:@"x" t:[TokenType identifier]],
                        [self v:@"=" t:[TokenType assign]],
                        [self v:@"1" t:[TokenType constant]],
                        [self v:@"*" t:[TokenType op]],
                        [self v:@"2" t:[TokenType constant]]];
    [self assertAST:tokens expectedPreorderTokens:@[@"=", @"x", @"*", @"1", @"2"]];
}

- (void)testAssignmentIsRightAssociative
{
    NSArray *tokens = @[[self v:@"a" t:[TokenType identifier]],
                        [self v:@"=" t:[TokenType assign]],
                        [self v:@"b" t:[TokenType identifier]],
                        [self v:@"=" t:[TokenType assign]],
                        [self v:@"3" t:[TokenType constant]]];
    [self assertAST:tokens expectedPreorderTokens:@[@"=", @"a", @"=", @"b", @"3"]];
}

- (void)testOtherOperatorsAreRightAssociative
{
    NSArray *tokens = @[[self v:@"3" t:[TokenType constant]],
                        [self v:@"-" t:[TokenType op]],
                        [self v:@"2" t:[TokenType constant]],
                        [self v:@"-" t:[TokenType op]],
                        [self v:@"1" t:[TokenType constant]]];
    [self assertAST:tokens expectedPreorderTokens:@[@"-", @"-", @"3", @"2", @"1"]];
}

- (Node *)v:(NSString *)value t:(TokenType *)type
{
    Node *n = [[Node alloc] init];
    n.token = [[Token alloc] initWithValue:value type:type];
    n.precedence = [_lexer getPrecedenceForToken:[[Token alloc] initWithValue:value type:type]];
    return n;
}

- (void)assertAST:(NSArray *)nodes expectedPreorderTokens:(NSArray *)expectedNodes
{
    ASTBuilder *astBuilder = [[ASTBuilder alloc] init];
    Node *ast = [astBuilder build:nodes];
    NSArray *preorderderNodes = [ast preorder];
    XCTAssertEqual([preorderderNodes count], [expectedNodes count], @"Unexpected node count");
    
    for (int i = 0; i < [preorderderNodes count]; i++)
    {
        Node *node = [preorderderNodes objectAtIndex:i];
        XCTAssertEqualObjects(node.token.value, [expectedNodes objectAtIndex:i], @"Unexpected token value");
    }
}

@end