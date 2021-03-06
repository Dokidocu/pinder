//
//  AppDelegate.m
//  Pinder
//
//  Created by Henri La on 04/09/15.
//  Copyright (c) 2015 OpenData. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[NetworkManager sharedNetworkManager]retrieveParties:self];
    [[NetworkManager sharedNetworkManager]retrieveThemes:self];
    [[NetworkManager sharedNetworkManager]retrieveMyQuestionsAnswered:self];
    //Launch the right Storyboard
    UIStoryboard *storyboard;
    self.window = [UIWindow new];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if (![[NetworkManager sharedNetworkManager] isLogged]) {
        storyboard = [UIStoryboard storyboardWithName:@"Sign" bundle:nil];
        [self.window setRootViewController:[storyboard instantiateInitialViewController]];
    }else{//First Time passed
        //[[NetworkManager sharedNetworkManager]refreshToken:self];
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [self.window setRootViewController:[storyboard instantiateInitialViewController]];
    }
    [self.window makeKeyAndVisible];
    //GET all "private parties" + "themes"
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - NetworkManagerProtocol
-(void)didRetrieveResponse:(id)response forRequest:(int)request{
    //NSLog(@"Response : %@", response);
    //NSLog(@"parties : %@", [[NetworkManager sharedNetworkManager]getParties]);
    //NSLog(@"themes : %@", [[NetworkManager sharedNetworkManager]getThemes]);
    //NSLog(@"getToken = %@", [[NetworkManager sharedNetworkManager]getToken]);
    if (request == REFRESH_TOKEN) {
        
    }
}


-(void)didFailRetrievingResponse:(NSString *)response forRequest:(int)request{
    NSLog(@"Failed : %@", response);
}

@end
