//
//  AddStatementVC.m
//  Pinder
//
//  Created by Henri La on 04/09/15.
//  Copyright (c) 2015 OpenData. All rights reserved.
//

#import "AddStatementVC.h"

NSString *const defaultText = @"Write an opinion someone can agree or disagree with i.e Congress should balance the budget";
NSInteger const pickerHeightConstraintVisible = 50;
NSInteger const pickerHeightConstraintInvisible = -300;

@interface AddStatementVC ()

@end

@implementation AddStatementVC

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [_txtViewStatement setDelegate:self];
    [_txtViewStatement setTextColor:[UIColor lightGrayColor]];
    //
    UITapGestureRecognizer *tapTheme = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusTheme)];
    UITapGestureRecognizer *tapPosition = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusPosition)];
    [_lblTheme addGestureRecognizer:tapTheme];
    [_lblPosition addGestureRecognizer:tapPosition];
    //
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma mark - Private methods
-(void)focusTheme{
    NSLog(@"focusTheme");
    [_txtViewStatement resignFirstResponder];
    _layoutConstraintPickerBottom.constant = pickerHeightConstraintVisible;
    [UIView animateWithDuration:0.2 animations:^{
        [_pickerView layoutIfNeeded];
    }];
}

-(void)focusPosition{
    NSLog(@"focusPosition");
    [_txtViewStatement resignFirstResponder];
    _layoutConstraintPickerBottom.constant = pickerHeightConstraintVisible;
    [UIView animateWithDuration:0.2 animations:^{
        [_pickerView layoutIfNeeded];
    }];
}


#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    if ([[textView text] length] > 0) {
        [_btnPost setUserInteractionEnabled:YES];
        [_btnPost setEnabled:YES];
        [_btnPost setAlpha:1.0];
    }else{
        [_btnPost setUserInteractionEnabled:NO];
        [_btnPost setEnabled:NO];
        [_btnPost setAlpha:0.4];
    }
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([textView textColor] == [UIColor lightGrayColor]) {
        [textView setText:@""];
        [textView setTextColor:[UIColor blackColor]];
    }
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if ([[textView text] length] == 0) {
        [textView setText:defaultText];
        [textView setTextColor:[UIColor lightGrayColor]];
        [_btnPost setEnabled:NO];
    }
    return YES;
}

#pragma mark - Actions
- (IBAction)postAction:(id)sender {
}

- (IBAction)cancelAction:(id)sender {
}
@end
