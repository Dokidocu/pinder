//
//  NetworkManager.h
//  Pinder
//
//  Created by Henri La on 04/09/15.
//  Copyright (c) 2015 OpenData. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkManagerProtocol.h"
#import <AFNetworking.h>

enum requests{
    RETRIEVE_ALL_QUESTIONS,
    RETRIEVE_MY_QUESTIONS,
    ANSWER_QUESTION,
    RETRIEVE_THEMES,
    RETIREVE_PARTIES,
    SEND_QUESTION
};

@interface NetworkManager : NSObject{
    NSMutableArray *pollQuestions;
    NSMutableArray *themes;
}

+(instancetype)sharedNetworkManager;

-(NSArray *)getPollQuestions;
-(NSArray *)getThemes;

-(void)retrieveAllQuestionsNotAnswered:(id<NetworkManagerProtocol>)delegate;
-(void)retrieveMyQuestionsAnswered:(id<NetworkManagerProtocol>)delegate;
-(void)answerQuestionId:(int)questionId withAnswer:(int)answer forDelegate:(id<NetworkManagerProtocol>)delegate;
-(void)retrieveThemes:(id<NetworkManagerProtocol>)delegate;
-(void)retrieveParties:(id<NetworkManagerProtocol>)delegate;
-(void)sendQuestion:(NSDictionary *)question forDelegate:(id<NetworkManagerProtocol>)delegate;


@end
