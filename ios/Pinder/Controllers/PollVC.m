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
    currentIndex = 0;
    pollQuestions = [[NetworkManager sharedNetworkManager]getPollQuestions];
    // Optional Delegate
    self.swipeableView.delegate = self;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    pollQuestionsIndex = 0;
    currentIndex = 0;
    [[NetworkManager sharedNetworkManager]retrieveAllQuestionsNotAnswered:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLayoutSubviews {
    // Required Data Source
    //self.swipeableView.dataSource = self;
}

#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier]isEqualToString:@"AddStatementVC"]) {
        AddStatementVC *dest = [segue destinationViewController];
        dest.providesPresentationContextTransitionStyle = YES;
        dest.definesPresentationContext = YES;
        [dest setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    }
}

#pragma mark - ZLSwipeableViewDataSource
-(UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView{
    if (pollQuestionsIndex < pollQuestions.count) {
        CardView *view = [[CardView alloc] initWithFrame:swipeableView.bounds];
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
        pollQuestionsIndex++;
        return view;
    }
    return nil;
}

#pragma mark - ZLSwipeableViewDelegate
- (void)swipeableView:(ZLSwipeableView *)swipeableView
         didSwipeView:(UIView *)view
          inDirection:(ZLSwipeableViewDirection)direction {
    NSLog(@"Statement : %@", [[pollQuestions objectAtIndex:currentIndex ]objectForKey:@"text"]);
    NSString *questionId = [[pollQuestions objectAtIndex:currentIndex]objectForKey:@"id"];
    if (direction == 1) {//left
        [[NetworkManager sharedNetworkManager]answerQuestionId:questionId withAnswer:@"NO" forDelegate:self];
        currentIndex++;
    }else if (direction == 2){//right
        [[NetworkManager sharedNetworkManager]answerQuestionId:questionId withAnswer:@"YES" forDelegate:self];
        currentIndex++;
    }else if(direction == 4){//up
        [[NetworkManager sharedNetworkManager]answerQuestionId:questionId withAnswer:@"NONE" forDelegate:self];
        currentIndex++;
    }
    //NSLog(@"questionId : %@", [[pollQuestions objectAtIndex:pollQuestionsIndex-1]objectForKey:@"id"]);
    //NSLog(@"did swipe in direction: %zd", direction);
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
/*
- (UIColor *)colorForName:(NSString *)name {
    NSString *sanitizedName =
    [name stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *selectorString =
    [NSString stringWithFormat:@"flat%@Color", sanitizedName];
    Class colorClass = [UIColor class];
    return [colorClass performSelector:NSSelectorFromString(selectorString)];
}*/

#pragma mark - NetworkManagerProtocol
-(void)didRetrieveResponse:(id)response forRequest:(int)request{
    if (RETRIEVE_ALL_QUESTIONS) {
        pollQuestions = [[NetworkManager sharedNetworkManager]getPollQuestions];
        //NSLog(@"poll : %@", pollQuestions);
        self.swipeableView.dataSource = self;
    }
}

-(void)didFailRetrievingResponse:(NSString *)response forRequest:(int)request{
    if (RETRIEVE_ALL_QUESTIONS) {
        //NSLog(@"poll failed : %@", response);
    }
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

- (IBAction)addStatementAction:(id)sender {
    [self performSegueWithIdentifier:@"AddStatementVC" sender:nil];
}
- (IBAction)swipeDownButtonAction:(UIButton *)sender {
    //NSLog(@"swipeDownButtonAction");
    [self.swipeableView swipeTopViewToDown];
}


@end
