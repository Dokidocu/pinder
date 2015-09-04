//
//  PollVC.h
//  Pinder
//
//  Created by Henri La on 04/09/15.
//  Copyright (c) 2015 OpenData. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLSwipeableView.h"
#import "CardView.h"

@interface PollVC : UIViewController<ZLSwipeableViewDataSource, ZLSwipeableViewDelegate>

@property (weak, nonatomic) IBOutlet ZLSwipeableView *swipeableView;

@property (nonatomic, strong) NSArray *colors;
@property (nonatomic) NSUInteger colorIndex;

@property (nonatomic) BOOL loadCardFromXib;
@end
