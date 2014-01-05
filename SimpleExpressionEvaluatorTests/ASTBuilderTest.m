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
- (NSUInteger)getPrecedenceForToken:(NSString *)token ofType:(NodeType)type;
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
    NSArray *tokens = [NSArray arrayWithObjects:
                       [self v:@"1" t:kNodeTypeConstant],
                       [self v:@"+" t:kNodeTypeBinaryOperator],
                       [self v:@"2" t:kNodeTypeConstant], nil];
    [self assertAST:tokens expectedPreorderTokens:[NSArray arrayWithObjects:@"+", @"1", @"2", nil]];
}

- (void)testExpr2
{
    NSArray *tokens = [NSArray arrayWithObjects:
                       [self v:@"1" t:kNodeTypeConstant],
                       [self v:@"+" t:kNodeTypeBinaryOperator],
                       [self v:@"2" t:kNodeTypeConstant],
                       [self v:@"*" t:kNodeTypeBinaryOperator],
                       [self v:@"3" t:kNodeTypeConstant], nil];
    [self assertAST:tokens expectedPreorderTokens:[NSArray arrayWithObjects:@"+", @"1", @"*", @"2", @"3", nil]];
}

- (void)testExprWithParens1
{
    NSArray *tokens = [NSArray arrayWithObjects:
                       [self v:@"(" t:kNodeTypeParen],
                       [self v:@"1" t:kNodeTypeConstant],
                       [self v:@"+" t:kNodeTypeBinaryOperator],
                       [self v:@"2" t:kNodeTypeConstant],
                       [self v:@")" t:kNodeTypeParen],
                       [self v:@"*" t:kNodeTypeBinaryOperator],
                       [self v:@"3" t:kNodeTypeConstant], nil];
    [self assertAST:tokens expectedPreorderTokens:[NSArray arrayWithObjects:@"*", @"+", @"1", @"2", @"3", nil]];
}

- (void)testAssignment1
{
    NSArray *tokens = [NSArray arrayWithObjects:
                       [self v:@"x" t:kNodeTypeIdentifier],
                       [self v:@"=" t:kNodeTypeAssignment],
                       [self v:@"1" t:kNodeTypeConstant], nil];
    [self assertAST:tokens expectedPreorderTokens:[NSArray arrayWithObjects:@"=", @"x", @"1", nil]];
}

- (void)testAssignment2
{
    NSArray *tokens = [NSArray arrayWithObjects:
                       [self v:@"x" t:kNodeTypeIdentifier],
                       [self v:@"=" t:kNodeTypeAssignment],
                       [self v:@"1" t:kNodeTypeConstant],
                       [self v:@"*" t:kNodeTypeBinaryOperator],
                       [self v:@"2" t:kNodeTypeConstant], nil];
    [self assertAST:tokens expectedPreorderTokens:[NSArray arrayWithObjects:@"=", @"x", @"*", @"1", @"2", nil]];
}

- (void)testAssignmentIsRightAssociative
{
    NSArray *tokens = [NSArray arrayWithObjects:
                       [self v:@"a" t:kNodeTypeIdentifier],
                       [self v:@"=" t:kNodeTypeAssignment],
                       [self v:@"b" t:kNodeTypeIdentifier],
                       [self v:@"=" t:kNodeTypeAssignment],
                       [self v:@"3" t:kNodeTypeConstant], nil];
    [self assertAST:tokens expectedPreorderTokens:[NSArray arrayWithObjects:@"=", @"a", @"=", @"b", @"3", nil]];
}

- (void)testOtherOperatorsAreRightAssociative
{
    NSArray *tokens = [NSArray arrayWithObjects:
                       [self v:@"3" t:kNodeTypeConstant],
                       [self v:@"-" t:kNodeTypeBinaryOperator],
                       [self v:@"2" t:kNodeTypeConstant],
                       [self v:@"-" t:kNodeTypeBinaryOperator],
                       [self v:@"1" t:kNodeTypeConstant], nil];
    [self assertAST:tokens expectedPreorderTokens:[NSArray arrayWithObjects:@"-", @"-", @"3", @"2", @"1", nil]];
}

- (Node *)v:(NSString *)value t:(NodeType)nodeType
{
    Node *n = [[Node alloc] init];
    n.value = value;
    n.type = nodeType;
    n.precedence = [tokenizer getPrecedenceForToken:value ofType:nodeType];
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
