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
    themes = [[NetworkManager sharedNetworkManager] getThemes];
    choices = [NSArray arrayWithObjects:@"I agree", @"I disagree", @"I am unsure", nil];
    //
    isDisplayingThemes = NO;
    indexThemes = -1;
    indexChoices = -1;
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
    //NSLog(@"focusTheme");
    isDisplayingThemes = YES;
    [_pickerView reloadAllComponents];
    [_txtViewStatement resignFirstResponder];
    _layoutConstraintPickerBottom.constant = pickerHeightConstraintVisible;
    [UIView animateWithDuration:0.2 animations:^{
        [_pickerView layoutIfNeeded];
    }];
}

-(void)focusPosition{
    //NSLog(@"focusPosition");
    isDisplayingThemes = NO;
    [_pickerView reloadAllComponents];
    [_txtViewStatement resignFirstResponder];
    _layoutConstraintPickerBottom.constant = pickerHeightConstraintVisible;
    [UIView animateWithDuration:0.2 animations:^{
        [_pickerView layoutIfNeeded];
    }];
}

#pragma mark - UIPickerViewDataSource, UIPickerViewDelegate
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (isDisplayingThemes) {
        return [themes count];
    }
    return [choices count];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (isDisplayingThemes) {
        NSDictionary *theme = [themes objectAtIndex:row];
        return [theme objectForKey:@"name"];
    }
    return [choices objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (isDisplayingThemes) {
        NSDictionary *theme = [themes objectAtIndex:row];
        [_lblTheme setText:[theme objectForKey:@"name"]];
        indexThemes = (int)row;
    }else{
        [_lblPosition setText:[choices objectAtIndex:row]];
        indexChoices = (int)row;
    }
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
    if ([[textView text] length] > 0 && indexChoices >= 0 && indexThemes >= 0) {
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

#pragma mark - NetworkManagerProtocol
-(void)didRetrieveResponse:(id)response forRequest:(int)request{
    //NSLog(@"sendQuestion : %@", response);
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didFailRetrievingResponse:(NSString *)response forRequest:(int)request{
    //NSLog(@"failed : %@", response);
}

#pragma mark - Actions
- (IBAction)postAction:(id)sender {
    NSMutableDictionary *question = [[NSMutableDictionary alloc]init];
    [question setObject:[_txtViewStatement text] forKey:@"text"];
    [question setObject:[[themes objectAtIndex:indexThemes] objectForKey:@"id"] forKey:@"theme"];
    NSString *answer;
    if (indexChoices == 0) {
        answer = @"YES";
    }else if (indexChoices == 1){
        answer = @"NO";
    }else{
        answer = @"NONE";
    }
    [question setObject:answer forKey:@"answer"];
    [[NetworkManager sharedNetworkManager]sendQuestion:question forDelegate:self];
}

- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
