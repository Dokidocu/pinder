//
//  NetworkManager.m
//  Pinder
//
//  Created by Henri La on 04/09/15.
//  Copyright (c) 2015 OpenData. All rights reserved.
//

#import "NetworkManager.h"

NSString *const kUrl = @"http://";

@implementation NetworkManager

#pragma mark - Lifecycle
- (instancetype)init{
    if (self = [super init]) {
        pollQuestions = [[NSMutableArray alloc]init];
        themes = [[NSMutableArray alloc]init];
    }
    return self;
}

+(instancetype)sharedNetworkManager{
    static NetworkManager *sharedNetworkManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedNetworkManager = [[self alloc]init];
    });
    return sharedNetworkManager;
}

#pragma mark - ()
-(NSArray *)getPollQuestions{
    //
    NSMutableDictionary *question;
    for (int i = 0; i < 13; i++) {
        question = [[NSMutableDictionary alloc]init];
        [question setObject:[NSNumber numberWithInt:i] forKey:@"id"];
        [question setObject:[NSString stringWithFormat:@"Title %@", @(i)] forKey:@"title"];
        [question setObject:[NSString stringWithFormat:@"Statement blablablabablablbla %@", @(i)] forKey:@"text"];
        [question setObject:[NSDate new] forKey:@"ends_at"];
        [pollQuestions addObject:question];
    }
    //
    return pollQuestions;
}

-(NSArray *)getThemes{
    NSMutableDictionary *theme;
    for (int i = 0; i < 15; i++) {
        theme = [[NSMutableDictionary alloc]init];
        [theme setObject:[NSNumber numberWithInt:i] forKey:@"id"];
        [theme setObject:[NSString stringWithFormat:@"Theme %@", @(i)] forKey:@"name"];
        [themes addObject:theme];
    }
    return themes;
}


-(void)retrieveAllQuestionsNotAnswered:(id<NetworkManagerProtocol>)delegate{
    NSString *url = nil;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [delegate didRetrieveResponse:responseObject forRequest:RETRIEVE_ALL_QUESTIONS];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate didFailRetrievingResponse:url forRequest:RETRIEVE_ALL_QUESTIONS];
    }];
}

-(void)retrieveMyQuestionsAnswered:(id<NetworkManagerProtocol>)delegate{
    NSString *url = nil;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [delegate didRetrieveResponse:responseObject forRequest:RETRIEVE_ALL_QUESTIONS];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate didFailRetrievingResponse:url forRequest:RETRIEVE_ALL_QUESTIONS];
    }];
}

-(void)answerQuestionId:(int)questionId withAnswer:(int)answer forDelegate:(id<NetworkManagerProtocol>)delegate{
    NSString *url = nil;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [delegate didRetrieveResponse:responseObject forRequest:RETRIEVE_ALL_QUESTIONS];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate didFailRetrievingResponse:url forRequest:RETRIEVE_ALL_QUESTIONS];
    }];
}

-(void)retrieveThemes:(id<NetworkManagerProtocol>)delegate{
    NSString *url = nil;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [delegate didRetrieveResponse:responseObject forRequest:RETRIEVE_ALL_QUESTIONS];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate didFailRetrievingResponse:url forRequest:RETRIEVE_ALL_QUESTIONS];
    }];
}

-(void)retrieveParties:(id<NetworkManagerProtocol>)delegate{
    NSString *url = nil;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [delegate didRetrieveResponse:responseObject forRequest:RETRIEVE_ALL_QUESTIONS];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate didFailRetrievingResponse:url forRequest:RETRIEVE_ALL_QUESTIONS];
    }];
}

-(void)sendQuestion:(NSDictionary *)question forDelegate:(id<NetworkManagerProtocol>)delegate{
    NSString *url = nil;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [delegate didRetrieveResponse:responseObject forRequest:RETRIEVE_ALL_QUESTIONS];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate didFailRetrievingResponse:url forRequest:RETRIEVE_ALL_QUESTIONS];
    }];
}


@end
