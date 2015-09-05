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
#import <Security/Security.h>

enum requests{
    SIGNIN,
    SIGNUP,
    REFRESH_TOKEN,
    RETRIEVE_MY_QUESTIONS,
    RETRIEVE_ALL_QUESTIONS,
    RETRIEVE_QUESTION,
    ANSWER_QUESTION,
    SEND_QUESTION,
    RETRIEVE_PARTIES,
    RETRIEVE_THEMES
};

@interface NetworkManager : NSObject{
    NSMutableArray *pollQuestions;
    NSMutableArray *themes;
    NSMutableArray *parties;
    NSMutableArray *myQuestions;
}

+(instancetype)sharedNetworkManager;

-(NSArray *)getPollQuestions;
-(NSArray *)getThemes;
-(NSArray *)getParties;
-(NSArray *)getMyQuestions;

-(NSString *)getToken;
-(BOOL)isLogged;

-(void)signInWithEmail:(NSString *)email andPassword:(NSString *)password forDelegate:(id<NetworkManagerProtocol>)delegate;
-(void)signup:(NSString *)email andPassword:(NSString *)password forDelegate:(id<NetworkManagerProtocol>)delegate;
-(void)refreshToken:(id<NetworkManagerProtocol>)delegate;
-(void)retrieveMyQuestionsAnswered:(id<NetworkManagerProtocol>)delegate;
-(void)retrieveAllQuestionsNotAnswered:(id<NetworkManagerProtocol>)delegate;
-(void)retrieveQuestion:(NSString *)questionId forDelegate:(id<NetworkManagerProtocol>)delegate;
-(void)answerQuestionId:(NSString *)questionId withAnswer:(NSString *)answer forDelegate:(id<NetworkManagerProtocol>)delegate;
-(void)sendQuestion:(NSDictionary *)question forDelegate:(id<NetworkManagerProtocol>)delegate;
-(void)retrieveParties:(id<NetworkManagerProtocol>)delegate;
-(void)retrieveThemes:(id<NetworkManagerProtocol>)delegate;




@end
