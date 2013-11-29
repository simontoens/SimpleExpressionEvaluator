//  Created by Simon Toens on 11/27/13.

#import <XCTest/XCTest.h>
#import "ASTBuilder.h"
#import "Node.h"

@interface ASTBuilderTest : XCTestCase

@end

@implementation ASTBuilderTest

- (void)tearDown
{
    [NSThread sleepForTimeInterval:1]; // crappy XCode bug
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

- (Node *)v:(NSString *)value t:(NodeType)nodeType
{
    return [[Node alloc] initWithValue:value nodeType:nodeType];
}

- (void)assertAST:(NSArray *)tokens expectedPreorderTokens:(NSArray *)expectedTokens
{
    ASTBuilder *astBuilder = [[ASTBuilder alloc] init];
    Node *ast = [astBuilder build:tokens];
    NSArray *preorderderNodes = [ast nodesInPreorder];
    XCTAssertEqual([preorderderNodes count], [tokens count], @"Unexpected node count");
    
    for (int i = 0; i < [preorderderNodes count]; i++)
    {
        Node *node = [preorderderNodes objectAtIndex:i];
        XCTAssertEqualObjects(node.value, [expectedTokens objectAtIndex:i], @"Unexpected token value");
    }
}

@end
