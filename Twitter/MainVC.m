//
//  MainVC.m
//  Twitter
//
//  Created by Jhih-Yan Lin on 7/8/15.
//  Copyright (c) 2015 Jhih-Yan Lin. All rights reserved.
//

#import "MainVC.h"

#import "TweetViewController.h"
#import "MenuViewController.h"
#import "PostTweetView.h"
#import "ProfileViewController.h"
#import "MentionViewController.h"
#import "LoginViewController.h"
#import "ReplyTweetView.h"
#import "User.h"
#import "TwitterClient.h"

@interface MainVC ()<MenuDelegate, UIGestureRecognizerDelegate, PostTweetViewDelegate, LoginViewControllerDelegate, TweetViewDelegate, ReplyTweetViewDelegate>

@property (strong, nonatomic) MenuViewController *menuController;
@property (nonatomic, assign) BOOL showingMenu;
@property (nonatomic, assign) CGPoint prePoint;

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.menuController = [[MenuViewController alloc] init];
    self.menuController.delegate = self;


    [self registerGesture];
    
    User *user = [User getUser];
    if (user != nil) {
        NSLog(@"User %@ login", user.name);
        // load the twitter
        [self onTwitterView];
    } else {
        self.currentVC = [[LoginViewController alloc] init];
        [self setView];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setView {
    
    // hide the menu
    [self hideMenu];
    
    
    if ([self.currentVC isKindOfClass:[TweetViewController class]]) {
        ((TweetViewController *)self.currentVC).delegate = self;
        self.navigationItem.title = @"Tweet";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(onSignOut)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(onNew)];
    } else if ([self.currentVC isKindOfClass:[ProfileViewController class]]) {
        self.navigationItem.title = @"Profile";
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
    } else { // default login page
        self.navigationItem.title = @"Login";
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
        LoginViewController *vc = [[LoginViewController alloc] init];
        vc.delegate = self;
        self.currentVC = vc;
    }
    
    // add to subview
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:self.currentVC];
    [self.view insertSubview:navigation.view belowSubview:self.view];
    [self addChildViewController:navigation];
    [self.currentVC didMoveToParentViewController:self];
}

- (void)registerGesture {
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    
    [self.view addGestureRecognizer:panRecognizer];
//    
//    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
//    [tapRecognizer setNumberOfTouchesRequired:1];
//    [tapRecognizer setDelegate:self];
    
}


#pragma mark - Menu Delegate
- (void)onProfile {
    ProfileViewController *profile = [[ProfileViewController alloc] init];
    profile.user = [User getUser];
    self.currentVC = profile;
    [self setView];
}

- (void)onTwitterView {
    [[TwitterClient sharedInstance] homeTimeLineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        if (tweets != nil) {
            TweetViewController *controller = [[TweetViewController alloc] init];
            controller.tweets = tweets;
            self.currentVC = controller;
            [self setView];
        } else {
            // error
            NSLog(@"Get tweet error: %@", error.description);
        }
    }];

    
}

-(void)onMentionView {
    [[TwitterClient sharedInstance] mentionsOnCompletion:^(NSArray *tweets, NSError *error) {
        if (error == nil) {
            TweetViewController *controller = [[TweetViewController alloc] init];
            controller.tweets = tweets;
            self.currentVC = controller;
            [self setView];
            
        } else {
            NSLog(@"Mention Error!");
        }
    }];
}


#pragma mark - Menu related jobs

- (void)hideMenu {
    
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        [self.view addSubview:self.menuController.view];
        [self addChildViewController:self.menuController];
        
        if (self.menuController != nil) {
            [self.menuController.view removeFromSuperview];
        }
        self.showingMenu = NO;
    } completion:^(BOOL finished) {
        
    }];
    
}


- (void)showMenu {
    
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        [self.view addSubview:self.menuController.view];
        [self addChildViewController:self.menuController];
        
        self.menuController.view.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width * 0.7f, self.view.frame.size.height);
        
        self.showingMenu = YES;
    } completion:^(BOOL finished) {
        
    }];
   
}

- (void)movePanel:(id)sender {
    
    UIPanGestureRecognizer *panGestureRecognizer = (UIPanGestureRecognizer *)sender;
    CGPoint point = [panGestureRecognizer locationInView:self.view];

    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.prePoint = point;
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"%f", self.menuController.view.frame.size.width);

        if (self.showingMenu) {
            if (self.prePoint.x > (point.x + 50)) {
                NSLog(@"Main VC hide menu");
                [self hideMenu];
            }
        } else {
            if ((self.prePoint.x + 50) < point.x) {
                NSLog(@"Main VC show menu");
                [self showMenu];
            }
        }
    }
    
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
        [self.navigationController popViewControllerAnimated:NO];
        
        // try to reload the tweets
        [self onTwitterView];
    }];
}

#pragma mark - Login View Deleegate

- (void)onLogin {
    NSLog(@"onLogin");
    self.currentVC = [[TweetViewController alloc] init];
    [self setView];

}

- (void)onLogout {
    [User logout];
    self.currentVC = [[LoginViewController alloc] init];
    [self setView];
}



#pragma mark - Navigation bar button
- (void)onSignOut {
    [self onLogout];
}

- (void)onNew {
    [self hideMenu];
    PostTweetView *controller = [[PostTweetView alloc] init];
    controller.delegate = self;
    controller.user = [User getUser];
    
    [self.navigationController pushViewController:controller animated:YES];
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
        
    }];
}


#pragma  mark - Tweet View VC delegate
- (void)getUserProfile:(User *)user {
    ProfileViewController *profile = [[ProfileViewController alloc] init];
    profile.user = user;
    self.currentVC = profile;
    [self setView];
}

- (void)showReplyView:(Tweet *)tweet {
    NSLog(@"reply view");
    ReplyTweetView *ctr = [[ReplyTweetView alloc] init];
    ctr.delegate = self;
    ctr.tweet = tweet;
    [self.navigationController pushViewController:ctr animated:YES];
}

@end
