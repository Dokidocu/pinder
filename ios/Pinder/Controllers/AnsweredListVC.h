//
//  AnsweredListVC.h
//  Pinder
//
//  Created by Henri La on 05/09/15.
//  Copyright (c) 2015 OpenData. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkManager.h"
#import "StatementCell.h"

@interface AnsweredListVC : UITableViewController<NetworkManagerProtocol>{
    NSArray *elements;
}

@end
