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
@property (nonatomic, strong) IBOutlet UITextField *outputTextView;
@end

@implementation MainViewController

- (IBAction)onEval:(id)sender
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
    NSLog(@"EXPR %@", exprToEval);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    ExpressionEvaluator *eval = [[ExpressionEvaluator alloc] init];
//    NSInteger result = [eval evaluate:self.textField.text];
//    self.resultLabel.text = [NSString stringWithFormat:@"%i", result];
//    self.astTextView.text = eval.prefix;
    return YES;
}

@end
