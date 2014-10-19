//
//  NodeType.h
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 10/19/14.
//  Copyright (c) 2014 Simon Toens. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Symantical types: type information that requires context.
 */
@interface NodeType : NSObject

- (id)init __unavailable;

+ (NodeType *)func;

@end
