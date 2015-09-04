//
//  PollVC.m
//  Pinder
//
//  Created by Henri La on 04/09/15.
//  Copyright (c) 2015 OpenData. All rights reserved.
//

#import "PollVC.h"

@interface PollVC ()

@end

@implementation PollVC

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    pollQuestionsIndex = 0;
    pollQuestions = [[NetworkManager sharedNetworkManager]getPollQuestions];
    
    /*
    self.colorIndex = 0;
    self.colors = @[
                    @"Turquoise",
                    @"Green Sea",
                    @"Emerald",
                    @"Nephritis",
                    @"Peter River",
                    @"Belize Hole",
                    @"Amethyst",
                    @"Wisteria",
                    @"Wet Asphalt",
                    @"Midnight Blue",
                    @"Sun Flower",
                    @"Orange",
                    @"Carrot",
                    @"Pumpkin",
                    @"Alizarin",
                    @"Pomegranate",
                    @"Clouds",
                    @"Silver",
                    @"Concrete",
                    @"Asbestos"
                    ];*/
    
    // Optional Delegate
    self.swipeableView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLayoutSubviews {
    // Required Data Source
    self.swipeableView.dataSource = self;
}

#pragma mark - ZLSwipeableViewDataSource
-(UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView{
    if (pollQuestionsIndex < pollQuestions.count - 1) {
        CardView *view = [[CardView alloc] initWithFrame:swipeableView.bounds];
        pollQuestionsIndex++;
        if (self.loadCardFromXib) {
            UIView *contentView =
            [[[NSBundle mainBundle] loadNibNamed:@"CardContentView"
                                           owner:self
                                         options:nil] objectAtIndex:0];
            contentView.translatesAutoresizingMaskIntoConstraints = NO;
            [view addSubview:contentView];
            
            // This is important:
            // https://github.com/zhxnlai/ZLSwipeableView/issues/9
            NSDictionary *metrics = @{
                                      @"height" : @(view.bounds.size.height),
                                      @"width" : @(view.bounds.size.width)
                                      };
            NSDictionary *views = NSDictionaryOfVariableBindings(contentView);
            [view addConstraints:
             [NSLayoutConstraint
              constraintsWithVisualFormat:@"H:|[contentView(width)]"
              options:0
              metrics:metrics
              views:views]];
            [view addConstraints:[NSLayoutConstraint
                                  constraintsWithVisualFormat:
                                  @"V:|[contentView(height)]"
                                  options:0
                                  metrics:metrics
                                  views:views]];
        } else {
            UITextView *textView =
            [[UITextView alloc] initWithFrame:view.bounds];
            textView.text = [[pollQuestions objectAtIndex:pollQuestionsIndex]objectForKey:@"text"];
            //textView.text = @"This UITextView was created programmatically.";
            textView.backgroundColor = [UIColor whiteColor];
            textView.font = [UIFont systemFontOfSize:24];
            textView.editable = NO;
            textView.selectable = NO;
            [view addSubview:textView];
        }
        return view;
        
        
    }
    /*
    if (self.colorIndex < self.colors.count) {
        CardView *view = [[CardView alloc] initWithFrame:swipeableView.bounds];
        view.backgroundColor = [self colorForName:self.colors[self.colorIndex]];
        self.colorIndex++;
        
        if (self.loadCardFromXib) {
            UIView *contentView =
            [[[NSBundle mainBundle] loadNibNamed:@"CardContentView"
                                           owner:self
                                         options:nil] objectAtIndex:0];
            contentView.translatesAutoresizingMaskIntoConstraints = NO;
            [view addSubview:contentView];
            
            // This is important:
            // https://github.com/zhxnlai/ZLSwipeableView/issues/9
            NSDictionary *metrics = @{
                                      @"height" : @(view.bounds.size.height),
                                      @"width" : @(view.bounds.size.width)
                                      };
            NSDictionary *views = NSDictionaryOfVariableBindings(contentView);
            [view addConstraints:
             [NSLayoutConstraint
              constraintsWithVisualFormat:@"H:|[contentView(width)]"
              options:0
              metrics:metrics
              views:views]];
            [view addConstraints:[NSLayoutConstraint
                                  constraintsWithVisualFormat:
                                  @"V:|[contentView(height)]"
                                  options:0
                                  metrics:metrics
                                  views:views]];
        } else {
            UITextView *textView =
            [[UITextView alloc] initWithFrame:view.bounds];
            textView.text = @"This UITextView was created programmatically.";
            textView.backgroundColor = [UIColor clearColor];
            textView.font = [UIFont systemFontOfSize:24];
            textView.editable = NO;
            textView.selectable = NO;
            [view addSubview:textView];
        }
        
        return view;
    }*/
    return nil;
}

#pragma mark - ZLSwipeableViewDelegate
- (void)swipeableView:(ZLSwipeableView *)swipeableView
         didSwipeView:(UIView *)view
          inDirection:(ZLSwipeableViewDirection)direction {
    if (direction == 1) {//left
        //[[NetworkManager sharedNetworkManager]sendQuestion:nil forDelegate:nil];
    }else if (direction == 2){//right
        //[[NetworkManager sharedNetworkManager]sendQuestion:nil forDelegate:nil];
    }else if(direction == 4){//up
        //[[NetworkManager sharedNetworkManager]sendQuestion:nil forDelegate:nil];
    }
    NSLog(@"did swipe in direction: %zd", direction);
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
       didCancelSwipe:(UIView *)view {
    //NSLog(@"did cancel swipe");
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
  didStartSwipingView:(UIView *)view
           atLocation:(CGPoint)location {
    //NSLog(@"did start swiping at location: x %f, y %f", location.x, location.y);
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
          swipingView:(UIView *)view
           atLocation:(CGPoint)location
          translation:(CGPoint)translation {
    //NSLog(@"swiping at location: x %f, y %f, translation: x %f, y %f", location.x, location.y, translation.x, translation.y);
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
    didEndSwipingView:(UIView *)view
           atLocation:(CGPoint)location {
    //NSLog(@"did end swiping at location: x %f, y %f", location.x, location.y);
}

#pragma mark - ()
- (UIColor *)colorForName:(NSString *)name {
    NSString *sanitizedName =
    [name stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *selectorString =
    [NSString stringWithFormat:@"flat%@Color", sanitizedName];
    Class colorClass = [UIColor class];
    return [colorClass performSelector:NSSelectorFromString(selectorString)];
}

#pragma mark - Action

- (IBAction)swipeLeftButtonAction:(UIButton *)sender {
    //NSLog(@"swipeLeftButtonAction");
    [self.swipeableView swipeTopViewToLeft];
}

- (IBAction)swipeRightButtonAction:(UIButton *)sender {
    //NSLog(@"swipeRightButtonAction");
    [self.swipeableView swipeTopViewToRight];
}
- (IBAction)swipeUpButtonAction:(UIButton *)sender {
    //NSLog(@"swipeUpButtonAction");
    [self.swipeableView swipeTopViewToUp];
}
- (IBAction)swipeDownButtonAction:(UIButton *)sender {
    //NSLog(@"swipeDownButtonAction");
    [self.swipeableView swipeTopViewToDown];
}


@end
