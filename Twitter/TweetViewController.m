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


@interface TweetViewController () <UITableViewDataSource, UITableViewDelegate, PostTweetViewDelegate, TweetCellDelegate, ReplyTweetViewDelegate, UIGestureRecognizerDelegate, MenuDelegate, MentionVCDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *tweets;

@property (nonatomic, assign) CGPoint prePoint;

@property (nonatomic, assign) BOOL showingMenu;

@property (nonatomic, strong) MenuViewController *menuController;

@end

@implementation TweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"TweetViewController viewDidLoad");
    
    UIBarButtonItem *btnSignOut = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onSignOut)];
    UIBarButtonItem *btnNew = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(onNew)];

    self.navigationItem.title = @"Twitter";
    self.navigationItem.leftBarButtonItem = btnSignOut;
    self.navigationItem.rightBarButtonItem = btnNew;

    
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.menuController = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:nil];
    self.menuController.delegate = self;


    [self reloadTweet];
    
    [self registerGesture];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerGesture {
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    
    [self.view addGestureRecognizer:panRecognizer];
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

- (void)hideMenu {
    
    if (self.menuController != nil) {
        [self.menuController.view removeFromSuperview];
    }
    self.showingMenu = NO;
}

- (void)showMenu {
    
    if (self.menuController == nil) {
        self.menuController = [[MenuViewController alloc] init];
    }
    
    [self.view addSubview:self.menuController.view];
    [self addChildViewController:self.menuController];
    [self.menuController didMoveToParentViewController:self];
    
    self.menuController.view.frame = CGRectMake(0, 0, self.view.frame.size.width-100, self.view.frame.size.height);
    
    self.showingMenu = YES;
}

- (UIView *)getMenuView {
    
    if (self.menuController == nil) {
        [self.view addSubview:self.menuController.view];
        [self addChildViewController:self.menuController];
        [self.menuController didMoveToParentViewController:self];
        
        self.menuController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
    }
    self.showingMenu = YES;
    return self.menuController.view;
}

- (void)movePanel:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint point = [panGestureRecognizer locationInView:self.view];
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.prePoint = point;
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
//        NSLog(@"Gesture changed: %@", NSStringFromCGPoint(point));
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        //[self showMenu];
        NSLog(@"%@, %@", NSStringFromCGPoint(self.prePoint), NSStringFromCGPoint(point));
        if (self.showingMenu) {
            if (self.prePoint.x > (point.x + 50)) {
                NSLog(@"hide menu");
                [self hideMenu];
            }
        } else {
            if ((self.prePoint.x + 50) < point.x) {
                NSLog(@"show menu");
                [self showMenu];
            }
        }
    }

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

//// on cell touched
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    NSLog(@"tweet: %d", indexPath.row);
//    
//}

#pragma mark - Navigation bar button
- (void) onSignOut {
    [User logout];  
}

- (void) onNew {
    NSLog(@"create new tweet");
    PostTweetView *controller = [[PostTweetView alloc] init];
    controller.delegate = self;
    controller.user = [User getUser];
    
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Tweet Cell
- (void) favorite:(BOOL)favoirte withId:(NSString *)tweetId onCompleted:(void (^)(NSError *error))onCompleted{
    
    [[TwitterClient sharedInstance] favorite:favoirte withId:tweetId completion:^(NSError *error) {
        onCompleted(error);
    }];
}

- (void) replyTweet:(Tweet *) tweet {
    NSLog(@"reply a tweet");
    
    ReplyTweetView *ctr = [[ReplyTweetView alloc] init];
    ctr.delegate = self;
    ctr.tweet = tweet;
    [self.navigationController pushViewController:ctr animated:YES];
}


#pragma mark - New Tweet Delegate
- (void) postTweet:(NSDictionary *)params {
    NSLog(@"%@", params);
    
    [[TwitterClient sharedInstance] tweet:params completion:^(NSError *error) {
        if (error != nil) {
            NSLog(@"New Tweet Error: %@", error.description);
        } else {
            NSLog(@"New Tweet OK!");
        }

        // pop up the post view
        [self.navigationController popViewControllerAnimated:YES];

        [self reloadTweet];
    }];
}

#pragma mark - Reply Delegate 
- (void)onReply:(NSString *)replyText withTweet:(Tweet *)tweet {
    NSLog(@"id: %@, %@", tweet.tweedId, replyText);
    NSDictionary *params = @{@"status": replyText, @"in_reply_to_status_id": tweet.tweedId };
    [[TwitterClient sharedInstance] tweet:params completion:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Reply Tweet Error: %@", error.description);
        } else {
            NSLog(@"Reply Tweet OK!");
        }
        
        
        [self.navigationController popViewControllerAnimated:YES];

        [self reloadTweet];

    }];
}

#pragma mark - Menu Delegate
- (void)onProfile {
    NSLog(@"onProfile");
    
    [self hideMenu];
    //[self.navigationController popViewControllerAnimated:NO];
    [self.navigationController pushViewController:[[ProfileViewController alloc] init] animated:YES];
}

- (void)onTwitterView {
    [self.navigationController popViewControllerAnimated:NO];
    [self.navigationController pushViewController:[[TweetViewController alloc] init] animated:YES];
}


#pragma mark - Mention View Delegate
-(void)onMentionView {
    [self.navigationController popViewControllerAnimated:NO];
    [self.navigationController pushViewController:[[MentionViewController alloc] init] animated:YES];
}

@end
