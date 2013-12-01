//
//  ExpressionEvaluator.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/29/13.
//  Copyright (c) 2013 Simon Toens. All rights reserved.
//

#import "ASTBuilder.h"
#import "ASTEvaluator.h"
#import "ExpressionEvaluator.h"
#import "Node.h"
#import "Tokenizer.h"

@implementation ExpressionEvaluator

- (NSInteger)evaluate:(NSString *)expression
{
    Tokenizer *tokenizer = [[Tokenizer alloc] init];
    NSArray *tokens = [tokenizer tokenize:expression];
    
    ASTBuilder *astBuilder = [[ASTBuilder alloc] init];
    Node *ast = [astBuilder build:tokens];
    _prefix = [ast prefix];
    
    ASTEvaluator *eval = [[ASTEvaluator alloc] init];
    return [eval evaluate:ast];
}

@end
