//
//  LoginViewController.m
//  Twitter
//
//  Created by Jhih-Yan Lin on 6/27/15.
//  Copyright (c) 2015 Jhih-Yan Lin. All rights reserved.
//

#import "LoginViewController.h"

#import "TwitterClient.h"
#import "TweetViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (IBAction)onLogin:(UIButton *)sender {
    
    [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
        if (user != nil) {
            // show twitter
            [self.delegate onLogin];
            
        } else {
            // show error
            NSLog(@"OAuth error: %@", error.description);
        }
    }];
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"Login";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
