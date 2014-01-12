//
//  InvalidTokenException.h
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 1/12/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Node.h"

@interface InvalidTokenException : NSException

- (instancetype)init __unavailable;

- (instancetype)initWithInvalidNode:(Node *)node atPosition:(NSUInteger)position;

@property (nonatomic, strong, readonly) Node *node;
@property (nonatomic, assign, readonly) NSUInteger position;

@end
