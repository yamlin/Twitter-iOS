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

@interface MainVC () <MenuDelegate>
@property (strong, nonatomic) TweetViewController *tweetVC;

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.tweetVC = [[TweetViewController alloc] init];
    [self.view addSubview:self.tweetVC.view];
    [self addChildViewController:self.tweetVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
