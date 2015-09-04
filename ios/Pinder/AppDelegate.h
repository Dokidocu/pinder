//
//  AppDelegate.h
//  Pinder
//
//  Created by Henri La on 04/09/15.
//  Copyright (c) 2015 OpenData. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, NetworkManagerProtocol>

@property (strong, nonatomic) UIWindow *window;


@end

