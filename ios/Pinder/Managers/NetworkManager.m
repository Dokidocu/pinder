//
//  NetworkManager.m
//  Pinder
//
//  Created by Henri La on 04/09/15.
//  Copyright (c) 2015 OpenData. All rights reserved.
//

#import "NetworkManager.h"

NSString *const kUrl = @"http://188.166.45.118/";
NSString *const kToken = @"ch.pinder.token";
NSString *const kLogged = @"ch.pinder.token";

#define kServiceKeychain @"32Dgwiv_daIqly308gf321dFDvx"
@implementation NetworkManager

#pragma mark - Lifecycle
- (instancetype)init{
    if (self = [super init]) {
        pollQuestions = [[NSMutableArray alloc]init];
        themes = [[NSMutableArray alloc]init];
        parties = [[NSMutableArray alloc]init];
        myQuestions = [[NSMutableArray alloc]init];
        //[[NSUserDefaults standardUserDefaults]setBool:NO forKey:kLogged];
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
    return pollQuestions;
}

-(NSArray *)getThemes{
    return themes;
}

-(NSArray *)getParties{
    return parties;
}

-(NSArray *)getMyQuestions{
    return myQuestions;
}

-(NSString *)getToken{
    return [[NSString alloc] initWithData:[self findWithKey:kToken] encoding:NSUTF8StringEncoding];
}

-(BOOL)isLogged{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kLogged];
}

-(void)signInWithEmail:(NSString *)email andPassword:(NSString *)password forDelegate:(id<NetworkManagerProtocol>)delegate{
    NSString *url = [NSString stringWithFormat:@"%@signin", kUrl];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:email forKey:@"email"];
    [params setObject:password forKey:@"password"];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //Store token
        //NSLog(@"token : %@", [self getToken]);
        [self removeWithKey:kToken];
        [self insertToKey:kToken withData:[[responseObject objectForKey:@"token"] dataUsingEncoding:NSUTF8StringEncoding]];
        //NSLog(@"token : %@", [self getToken]);
        //set isLogged !
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kLogged];
        //
        [delegate didRetrieveResponse:responseObject forRequest:SIGNIN];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate didFailRetrievingResponse:[NSString stringWithFormat:@"%ld - %@",(long)[[operation response]statusCode],[operation responseString]] forRequest:SIGNIN];
    }];
}
-(void)signup:(NSString *)email andPassword:(NSString *)password forDelegate:(id<NetworkManagerProtocol>)delegate{
    NSString *url = [NSString stringWithFormat:@"%@signup", kUrl];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:email forKey:@"email"];
    [params setObject:password forKey:@"password"];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //Store token
        //NSLog(@"token : %@", [self getToken]);
        [self removeWithKey:kToken];
        [self insertToKey:kToken withData:[[responseObject objectForKey:@"token"] dataUsingEncoding:NSUTF8StringEncoding]];
        //NSLog(@"token : %@", [self getToken]);
        //set isLogged !
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kLogged];
        //
        [delegate didRetrieveResponse:responseObject forRequest:SIGNUP];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate didFailRetrievingResponse:[NSString stringWithFormat:@"%ld - %@",(long)[[operation response]statusCode],[operation responseString]] forRequest:SIGNUP];
    }];
}
-(void)refreshToken:(id<NetworkManagerProtocol>)delegate{
    NSString *url = [NSString stringWithFormat:@"%@refresh", kUrl];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer:%@", [self getToken]] forHTTPHeaderField:@"Authorization"];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self removeWithKey:kToken];
        [self insertToKey:kToken withData:[[responseObject objectForKey:@"token"] dataUsingEncoding:NSUTF8StringEncoding]];
        [delegate didRetrieveResponse:responseObject forRequest:REFRESH_TOKEN];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate didFailRetrievingResponse:url forRequest:REFRESH_TOKEN];
    }];
}

-(void)retrieveMyQuestionsAnswered:(id<NetworkManagerProtocol>)delegate{
    NSString *url = [NSString stringWithFormat:@"%@v0/question", kUrl];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer:%@", [self getToken]] forHTTPHeaderField:@"Authorization"];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [myQuestions removeAllObjects];
        NSArray *result = [responseObject objectForKey:@"result"];
        for (NSDictionary *value in result) {
            [myQuestions addObject:value];
        }
        [delegate didRetrieveResponse:responseObject forRequest:RETRIEVE_MY_QUESTIONS];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate didFailRetrievingResponse:[NSString stringWithFormat:@"%ld - %@",(long)[[operation response]statusCode],[operation responseString]] forRequest:RETRIEVE_MY_QUESTIONS];
    }];
}

-(void)retrieveAllQuestionsNotAnswered:(id<NetworkManagerProtocol>)delegate{
    NSString *url = [NSString stringWithFormat:@"%@v0/question/new", kUrl];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer:%@", [self getToken]] forHTTPHeaderField:@"Authorization"];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [pollQuestions removeAllObjects];
        NSArray *result = [responseObject objectForKey:@"result"];
        for (NSDictionary *value in result) {
            [pollQuestions addObject:value];
        }
        [delegate didRetrieveResponse:responseObject forRequest:RETRIEVE_ALL_QUESTIONS];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate didFailRetrievingResponse:[NSString stringWithFormat:@"%ld - %@",(long)[[operation response]statusCode],[operation responseString]] forRequest:RETRIEVE_ALL_QUESTIONS];
    }];
}

-(void)retrieveQuestion:(NSString *)questionId forDelegate:(id<NetworkManagerProtocol>)delegate{
    NSString *url = [NSString stringWithFormat:@"%@v0/question/%@", kUrl, questionId];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer:%@", [self getToken]] forHTTPHeaderField:@"Authorization"];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [delegate didRetrieveResponse:responseObject forRequest:RETRIEVE_QUESTION];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate didFailRetrievingResponse:url forRequest:RETRIEVE_QUESTION];
    }];
}
-(void)answerQuestionId:(NSString *)questionId withAnswer:(NSString *)answer forDelegate:(id<NetworkManagerProtocol>)delegate{
    NSString *url = [NSString stringWithFormat:@"%@v0/question/%@", kUrl, questionId];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer:%@", [self getToken]] forHTTPHeaderField:@"Authorization"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:answer forKey:@"answer"];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [delegate didRetrieveResponse:responseObject forRequest:ANSWER_QUESTION];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate didFailRetrievingResponse:url forRequest:ANSWER_QUESTION];
    }];
}
-(void)sendQuestion:(NSDictionary *)question forDelegate:(id<NetworkManagerProtocol>)delegate{
    NSString *url = [NSString stringWithFormat:@"%@v0/question", kUrl];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer:%@", [self getToken]] forHTTPHeaderField:@"Authorization"];
    [manager POST:url parameters:question success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [delegate didRetrieveResponse:responseObject forRequest:SEND_QUESTION];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate didFailRetrievingResponse:[NSString stringWithFormat:@"%ld - %@",(long)[[operation response]statusCode],[operation responseString]] forRequest:SEND_QUESTION];
    }];
}

-(void)retrieveParties:(id<NetworkManagerProtocol>)delegate{
    NSString *url = [NSString stringWithFormat:@"%@v0/party", kUrl];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer:%@", [self getToken]] forHTTPHeaderField:@"Authorization"];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *result = [responseObject objectForKey:@"result"];
        [parties removeAllObjects];
        for (NSDictionary *party in result) {
            [parties addObject:party];
        }
        [delegate didRetrieveResponse:responseObject forRequest:RETRIEVE_PARTIES];
        //NSLog(@"parties = %@", [self getParties]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate didFailRetrievingResponse:url forRequest:RETRIEVE_PARTIES];
    }];
}

-(void)retrieveThemes:(id<NetworkManagerProtocol>)delegate{
    NSString *url = [NSString stringWithFormat:@"%@v0/theme", kUrl];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer:%@", [self getToken]] forHTTPHeaderField:@"Authorization"];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *result = [responseObject objectForKey:@"result"];
        [themes removeAllObjects];
        for (NSDictionary *party in result) {
            [themes addObject:party];
        }
        [delegate didRetrieveResponse:responseObject forRequest:RETRIEVE_THEMES];
        //NSLog(@"themes = %@", [self getThemes]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate didFailRetrievingResponse:url forRequest:RETRIEVE_THEMES];
    }];
}


#pragma mark - Keychain Helper
//CALLED BY INSERT, FIND AND REMOVE
-(NSMutableDictionary*)prepareDict:(NSString *) key{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    
    NSData *encodedKey = [key dataUsingEncoding:NSUTF8StringEncoding];
    [dict setObject:encodedKey forKey:(__bridge id)kSecAttrGeneric];
    [dict setObject:encodedKey forKey:(__bridge id)kSecAttrAccount];
    [dict setObject:kServiceKeychain forKey:(__bridge id)kSecAttrService];
    [dict setObject:(__bridge id)kSecAttrAccessibleAlwaysThisDeviceOnly forKey:(__bridge id)kSecAttrAccessible];
    return  dict;
}

-(BOOL)insertToKey:(NSString *)key withData:(NSData *)data{
    NSMutableDictionary * dict =[self prepareDict:key];
    [dict setObject:data forKey:(__bridge id)kSecValueData];
    
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)dict, NULL);
    if(errSecSuccess != status) {
        NSLog(@"KEYCHAIN UNABLE TO ADD for this key = %@ : %d", key,(int)status);
        //NSLog(@"Unable add item with key =%@ error:%ld",key,status);
    }
    return (errSecSuccess == status);
}

-(NSData*)findWithKey:(NSString*)key{
    NSMutableDictionary *dict = [self prepareDict:key];
    [dict setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    [dict setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    CFTypeRef result = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)dict,&result);
    if( status != errSecSuccess) {
        NSLog(@"KEYCHAIN UNABLE TO FIND this KEY = %@ : %d", key, (int)status);
        return nil;
    }
    return (__bridge NSData *)result;
}

-(BOOL)removeWithKey:(NSString*)key{
    NSMutableDictionary *dict = [self prepareDict:key];
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)dict);
    if( status != errSecSuccess) {
        NSLog(@"Unable to remove this key = %@ ",key);
        return NO;
    }
    return YES;
}


@end
