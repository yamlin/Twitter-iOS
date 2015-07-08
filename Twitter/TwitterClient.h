//
//  TwitterClient.h
//  Twitter
//
//  Created by Jhih-Yan Lin on 6/27/15.
//  Copyright (c) 2015 Jhih-Yan Lin. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"
#import "Tweet.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *) sharedInstance;

- (void) loginWithCompletion:(void (^)(User *user, NSError *error))completion;
- (void) openUrl:(NSURL *)url;
- (void) homeTimeLineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;

- (void) favorite:(BOOL)flag withId:(NSString *)tweetId completion:(void (^)(NSError *error))completion;
- (void) retweetWithId:(NSString *)tweetId completion:(void (^)(NSError *error))completion;
- (void) tweet:(NSDictionary *)params completion:(void (^)(NSError *error))completion;

- (void) profile:(User *)user completion:(void (^)(NSDictionary *resp, NSError *error)) completion;

- (void) mentionsOnCompletion:(void (^)(NSArray *tweets, NSError *error)) completion;

@end
