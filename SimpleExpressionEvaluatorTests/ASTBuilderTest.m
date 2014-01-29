//  Created by Simon Toens on 11/27/13.

#import <XCTest/XCTest.h>
#import "ASTBuilder.h"
#import "Node.h"
#import "Tokenizer.h"

@interface ASTBuilderTest : XCTestCase
{
    Tokenizer *tokenizer;
}
@end

@interface Node()
- (NSArray *)preorder;
@end;

@interface Tokenizer()
- (NSUInteger)getPrecedenceForToken:(NSString *)token ofType:(TokenType *)type;
@end

@implementation ASTBuilderTest

- (void)setUp
{
    [super setUp];
    tokenizer = [[Tokenizer alloc] init];
}

- (void)tearDown
{
    [NSThread sleepForTimeInterval:1]; // crappy Xcode bug, utests can't run too fast
    [super tearDown];
}

- (void)testExpr1
{
    NSArray *tokens = @[[self v:@"1" t:[TokenType constant]],
                        [self v:@"+" t:[TokenType op]],
                        [self v:@"2" t:[TokenType constant]]];
    [self assertAST:tokens expectedPreorderTokens:@[@"+", @"1", @"2"]];
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
    NSArray *tokens = @[[self v:@"(" t:[TokenType paren]],
                        [self v:@"1" t:[TokenType constant]],
                        [self v:@"+" t:[TokenType op]],
                        [self v:@"2" t:[TokenType constant]],
                        [self v:@")" t:[TokenType paren]],
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

- (Node *)v:(NSString *)value t:(TokenType *)tokenType
{
    Node *n = [[Node alloc] init];
    n.value = value;
    n.type = tokenType;
    n.precedence = [tokenizer getPrecedenceForToken:value ofType:tokenType];
    return n;
}

- (void)assertAST:(NSArray *)tokens expectedPreorderTokens:(NSArray *)expectedTokens
{
    ASTBuilder *astBuilder = [[ASTBuilder alloc] init];
    Node *ast = [astBuilder build:tokens];
    NSArray *preorderderNodes = [ast preorder];
    XCTAssertEqual([preorderderNodes count], [expectedTokens count], @"Unexpected node count");
    
    for (int i = 0; i < [preorderderNodes count]; i++)
    {
        Node *node = [preorderderNodes objectAtIndex:i];
        XCTAssertEqualObjects(node.value, [expectedTokens objectAtIndex:i], @"Unexpected token value");
    }
}

@end
