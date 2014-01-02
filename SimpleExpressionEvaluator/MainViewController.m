//
//  MainViewController.m
//  SimpleExpressionEvaluator
//
//  Created by Simon Toens on 11/29/13.
//  Copyright (c) 2013 Simon Toens. All rights reserved.
//

#import "ExpressionEvaluator.h"
#import "MainViewController.h"

@interface MainViewController()
@property (nonatomic, strong) IBOutlet UITextView *inputTextView;
@property (nonatomic, strong) IBOutlet UILabel *outputLabel;
@property (nonatomic, strong) IBOutlet UILabel *outputPrefix;
@end

@implementation MainViewController
{
    ExpressionEvaluator *eval;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    eval = [[ExpressionEvaluator alloc] init];
}

- (IBAction)onEval:(id)sender
{
    NSString *expr = [self getExprLeftOfCursor];
    NSInteger result = [eval evaluate:expr];
    self.outputLabel.text = [NSString stringWithFormat:@"%li", (long)result];
    self.outputPrefix.text = eval.prefix;
}

- (NSString *)getExprLeftOfCursor
{
    NSString *allText = self.inputTextView.text;
    NSUInteger currentPosition = self.inputTextView.selectedRange.location;
    NSRange searchRange = NSMakeRange(0, currentPosition);
    NSRange resultRange = [allText rangeOfString:@"\n" options:NSBackwardsSearch range:searchRange];
    NSString *exprToEval = [allText substringWithRange:searchRange];
    if (resultRange.location != NSNotFound)
    {
        NSRange exprRange = NSMakeRange(resultRange.location, currentPosition - resultRange.location);
        exprToEval = [allText substringWithRange:exprRange];
    }
    return exprToEval;
}

@end
