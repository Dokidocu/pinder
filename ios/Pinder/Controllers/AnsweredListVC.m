//
//  AnsweredListVC.m
//  Pinder
//
//  Created by Henri La on 05/09/15.
//  Copyright (c) 2015 OpenData. All rights reserved.
//

#import "AnsweredListVC.h"

@interface AnsweredListVC ()

@end

@implementation AnsweredListVC

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NetworkManager sharedNetworkManager]retrieveMyQuestionsAnswered:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [elements count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"StatementCell";
    StatementCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    NSDictionary *value = [elements objectAtIndex:indexPath.row];
    [[cell lblStatement]setText:[value objectForKey:@"text"]];
    if ([value objectForKey:@"yes_count"] != [NSNull null]) {
        [[cell lblAgree]setText:[NSString stringWithFormat:@"Agree : %@",[[value objectForKey:@"yes_count"]objectForKey:@"yes_count"]]];
    }else{
        [[cell lblAgree]setText:@"Agree : 0"];
    }
    if ([value objectForKey:@"no_count"] != [NSNull null]) {
        [[cell lblUnsure]setText:[NSString stringWithFormat:@"Disagree : %@",[[value objectForKey:@"no_count"]objectForKey:@"no_count"]]];
    }else{
        [[cell lblUnsure]setText:@"Disagree :0"];
    }

    return cell;
}

#pragma mark - NetworkManagerProtocol
-(void)didRetrieveResponse:(id)response forRequest:(int)request{
    elements = [[NetworkManager sharedNetworkManager]getMyQuestions];
    //NSLog(@"elements : %@", elements);
    [[self tableView]reloadData];
}

-(void)didFailRetrievingResponse:(NSString *)response forRequest:(int)request{
    
}

@end
