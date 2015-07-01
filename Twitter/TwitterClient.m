//
//  TwitterClient.m
//  Twitter
//
//  Created by Jhih-Yan Lin on 6/27/15.
//  Copyright (c) 2015 Jhih-Yan Lin. All rights reserved.
//

#import "TwitterClient.h"


NSString * const twitterConsumerKey = @"JYgJcHLbSfNTxSdE8npwKKu5T";
NSString * const twitterConsumerSecret = @"7GpQrXxRyrSSMwDlA5QAoHIO62THpdblr6C7yG2a3lHJlYo0Yn";
NSString * const twitterBaseUrl = @"https://api.twitter.com";

@interface TwitterClient()
@property (strong, nonatomic) void (^loginCompletion)(User *user, NSError *error);
@end

@implementation TwitterClient

+ (TwitterClient *) sharedInstance {
    static TwitterClient *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL: [NSURL URLWithString:twitterBaseUrl] consumerKey:twitterConsumerKey consumerSecret:twitterConsumerSecret];
        }
    });
    
    return instance;
}

- (void) loginWithCompletion:(void (^)(User *user, NSError *error))completion {
    self.loginCompletion = completion;
    
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"twitterdemo://oauth"] scope:nil success:^(BDBOAuth1Credential *requestToken) {
        NSLog(@"oauth get token!");
        NSURL *authUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
        [[UIApplication sharedApplication] openURL:authUrl];
        
        
    } failure:^(NSError *error) {
        NSLog(@"oauth fail!");
    }];
}

- (void) openUrl:(NSURL *)url {
    
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:
     [BDBOAuth1Credential credentialWithQueryString:url.query] success:^(BDBOAuth1Credential *accessToken) {
         
         NSLog(@"Get Access Token!");
         [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             User *user = [[User alloc] initWithDictionary:responseObject];
             [User setUser:user];
             
             self.loginCompletion(user, nil);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             self.loginCompletion(nil, error);
         }];
         
//         [self GET:@"1.1/statuses/home_timeline.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//             NSLog(@"Get response: %@", responseObject);
//             
//             NSArray *tweets = [Tweet tweetsWithArray:responseObject];
//             for (Tweet *tweet in tweets) {
//                 NSLog(@"%@ %@", tweet.user.name, tweet.user.tagLine);
//             }
//             
//         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//             NSLog(@"Error: %@", error.description);
//         }];
         
     } failure:^(NSError *error) {
         self.loginCompletion(nil, error);

     }];
    

}

- (void) homeTimeLineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion {
    
    [self GET:@"1.1/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // get tweets
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //error
        completion(nil, error);
    }];
}

- (void) favorite:(BOOL)flag withId:(NSString *)tweetId completion:(void (^)(NSError *error))completion {
    // check is destory or create
    NSString *url = (flag) ? [NSString stringWithFormat:@"1.1/favorites/create.json?id=%@", tweetId] :  [NSString stringWithFormat:@"1.1/favorites/destroy.json?id=%@", tweetId];
    
    [self POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"resp: %@", responseObject);
        
        completion(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(error);
        
    }];

}

- (void) retweetWithId:(NSString *)tweetId completion:(void (^)(NSError *error))completion {
    NSString *url = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", tweetId];
    [self POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"resp: %@", responseObject);
        completion(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(error);
        
    }];

}

- (void) tweet:(NSDictionary *)params completion:(void (^)(NSError *error))completion {
    
    [self POST:@"1.1/statuses/update.json" parameters:params constructingBodyWithBlock:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        completion(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(error);
    }];
    
}



@end
