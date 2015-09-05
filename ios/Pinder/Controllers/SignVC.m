//
//  SignVC.m
//  Pinder
//
//  Created by Henri La on 05/09/15.
//  Copyright (c) 2015 OpenData. All rights reserved.
//

#import "SignVC.h"

@interface SignVC ()

@end

@implementation SignVC

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    isSigning = NO;
    isConnecting = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ()
-(BOOL)fieldsAreCorrect{
    if (![Util isValidEmail:[_txtFieldEmail text]]) {
        return NO;
    }
    if ([[_txtFieldPassword text]length] == 0) {
        return NO;
    }
    return YES;
}

-(void)goToMainStoryBoard{
    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [self presentViewController:[mainStory instantiateInitialViewController] animated:YES completion:nil];
}

#pragma mark - NetworkManagerProtocol
-(void)didRetrieveResponse:(id)response forRequest:(int)request{
    [hud removeFromSuperview];
    [hud show:NO];
    if (request == SIGNIN) {
        [self goToMainStoryBoard];
    }
    if (request == SIGNUP) {
        [self goToMainStoryBoard];
    }
}

-(void)didFailRetrievingResponse:(NSString *)response forRequest:(int)request{
    if (request == SIGNIN) {
        isSigning = NO;
    }
    if (request == SIGNUP) {
        isConnecting = NO;
    }
    [hud removeFromSuperview];
    [hud show:NO];
    [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Something bad happened..." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
}

#pragma mark - Actions
- (IBAction)signInAction:(id)sender {
    if (isSigning == YES) {
        return;
    }
    if ([self fieldsAreCorrect]) {
        hud = [[MBProgressHUD alloc]initWithView:self.view];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"Processing";
        hud.userInteractionEnabled = NO;
        [self.view addSubview:hud];
        [hud show:YES];
        isSigning = YES;
        [[NetworkManager sharedNetworkManager]signInWithEmail:[_txtFieldEmail text] andPassword:[_txtFieldPassword text] forDelegate:self];
    }else{
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Fields are incorrect" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
    }
}

- (IBAction)connectionAction:(id)sender {
    if (isConnecting == YES) {
        return;
    }
    if ([self fieldsAreCorrect]) {
        hud = [[MBProgressHUD alloc]initWithView:self.view];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"Processing";
        hud.userInteractionEnabled = NO;
        [self.view addSubview:hud];
        [hud show:YES];
        isConnecting = YES;
        [[NetworkManager sharedNetworkManager]signup:[_txtFieldEmail text] andPassword:[_txtFieldPassword text] forDelegate:self];
    }else{
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Fields are incorrect" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
    }
}
@end
