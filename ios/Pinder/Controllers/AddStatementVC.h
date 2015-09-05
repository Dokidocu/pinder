//
//  AddStatementVC.h
//  Pinder
//
//  Created by Henri La on 04/09/15.
//  Copyright (c) 2015 OpenData. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkManager.h"

@interface AddStatementVC : UIViewController<UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, NetworkManagerProtocol>{
    NSArray *themes;
    NSArray *choices;
    BOOL isDisplayingThemes;
    int indexThemes;
    int indexChoices;
}

@property (weak, nonatomic) IBOutlet UILabel *lblTheme;
@property (weak, nonatomic) IBOutlet UILabel *lblPosition;
@property (weak, nonatomic) IBOutlet UITextView *txtViewStatement;
@property (weak, nonatomic) IBOutlet UIButton *btnPost;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintPickerBottom;

- (IBAction)postAction:(id)sender;
- (IBAction)cancelAction:(id)sender;

@end
