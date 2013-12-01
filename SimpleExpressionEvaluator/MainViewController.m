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
@property (nonatomic, strong) IBOutlet UITextField *textField;
@property (nonatomic, strong) IBOutlet UILabel *resultLabel;
@property (nonatomic, strong) IBOutlet UITextView *astTextView;
@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textField.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    ExpressionEvaluator *eval = [[ExpressionEvaluator alloc] init];
    NSInteger result = [eval evaluate:self.textField.text];
    self.resultLabel.text = [NSString stringWithFormat:@"%i", result];
    self.astTextView.text = eval.prefix;
    return YES;
}

@end
