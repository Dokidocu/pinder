//
//  SignVC.h
//  Pinder
//
//  Created by Henri La on 05/09/15.
//  Copyright (c) 2015 OpenData. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkManager.h"
#import "Util.h"
#import <MBProgressHUD.h>

@interface SignVC : UIViewController<NetworkManagerProtocol>{
    BOOL isSigning;
    BOOL isConnecting;
    MBProgressHUD *hud;
}


@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnConnection;


- (IBAction)signInAction:(id)sender;
- (IBAction)connectionAction:(id)sender;

@end
