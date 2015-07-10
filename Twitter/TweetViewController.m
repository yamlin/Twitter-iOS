//
//  TweetViewController.m
//  Twitter
//
//  Created by Jhih-Yan Lin on 6/28/15.
//  Copyright (c) 2015 Jhih-Yan Lin. All rights reserved.
//

#import "TweetViewController.h"
#import "User.h"
#import "Tweet.h"
#import "TwitterClient.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "PostTweetView.h"
#import "ReplyTweetView.h"
#import "MenuViewController.h"
#import "ProfileViewController.h"
#import "MentionViewController.h"


@interface TweetViewController () <UITableViewDataSource, UITableViewDelegate, PostTweetViewDelegate, TweetCellDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"TweetViewController viewDidLoad");
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadTweet {
    [[TwitterClient sharedInstance] homeTimeLineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        if (tweets != nil) {
            
            self.tweets = tweets;
            [self.tableView reloadData];
            
        } else {
            // error
            NSLog(@"Get tweet error: %@", error.description);
        }
    }];
}

#pragma mark - Table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell"];

    cell.delegate = self;
    [cell setTweet:self.tweets[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}


#pragma mark - Tweet Cell
- (void)favorite:(BOOL)favoirte withId:(NSString *)tweetId onCompleted:(void (^)(NSError *error))onCompleted{
    
    [[TwitterClient sharedInstance] favorite:favoirte withId:tweetId completion:^(NSError *error) {
        onCompleted(error);
    }];
}

- (void)replyTweet:(Tweet *) tweet {
    NSLog(@"reply a tweet");
    [self.delegate showReplyView:tweet];
}

- (void)onProfile:(User *) user {
    NSLog(@"on profile");
    [self.delegate getUserProfile:user];
}


#pragma mark - New Tweet Delegate
- (void)postTweet:(NSDictionary *)params {
    NSLog(@"%@", params);
    
//    [[TwitterClient sharedInstance] tweet:params completion:^(NSError *error) {
//        if (error != nil) {
//            NSLog(@"New Tweet Error: %@", error.description);
//        } else {
//            NSLog(@"New Tweet OK!");
//        }
//        // pop up the post view
//        [self.navigationController popViewControllerAnimated:YES];
//
//        [self reloadTweet];
//    }];
}


@end
