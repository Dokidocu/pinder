//
//  StatementCell.h
//  Pinder
//
//  Created by Henri La on 05/09/15.
//  Copyright (c) 2015 OpenData. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatementCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblStatement;
@property (weak, nonatomic) IBOutlet UILabel *lblAgree;
@property (weak, nonatomic) IBOutlet UILabel *lblDisagree;
@property (weak, nonatomic) IBOutlet UILabel *lblUnsure;

@end
