//
//  ExpressionEvaluator.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/29/13.
//  Copyright (c) 2013 Simon Toens. All rights reserved.
//

#import "ASTBuilder.h"
#import "Environment.h"
#import "ExpressionEvaluator.h"
#import "Lexer.h"
#import "Node.h"
#import "Tokenizer.h"

@implementation ExpressionEvaluator
{
    @private
    Environment *env;
}

- (instancetype)init
{
    if (self = [super init])
    {
        env = [[Environment alloc] init];
    }
    return self;
}

- (NSInteger)evaluate:(NSString *)expression
{
    Tokenizer *tokenizer = [[Tokenizer alloc] init];
    NSArray *tokens = [tokenizer tokenize:expression];
    
    Lexer *lexer = [[Lexer alloc] init];
    NSArray *nodes = [lexer lex:tokens];
    
    ASTBuilder *astBuilder = [[ASTBuilder alloc] init];
    Node *ast = [astBuilder build:nodes];
    _prefix = [ast prefix];
    
    Node *result = [ast eval:env];
    return [result.value integerValue];
}

@end
