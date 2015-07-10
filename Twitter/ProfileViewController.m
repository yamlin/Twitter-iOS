//
//  ProfileViewController.m
//  Twitter
//
//  Created by Jhih-Yan Lin on 7/5/15.
//  Copyright (c) 2015 Jhih-Yan Lin. All rights reserved.
//

#import "ProfileViewController.h"
#import "User.h"
#import "TwitterClient.h"
#import <AFNetworking/UIImageView+AFNetworking.h>


@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.userLabel.text = self.user.name;
    [self.userImage setImageWithURL:[NSURL URLWithString:self.user.profileImageUrl]];
    
    
    [[TwitterClient sharedInstance] profile:self.user completion:^(NSDictionary *resp, NSError *error) {
         
        if (error == nil) {
            self.followersLabel.text = [NSString stringWithFormat:@"%@ followers", resp[@"followers_count"]];
            self.followingLabel.text = [NSString stringWithFormat:@"%@ followings", resp[@"friends_count"]];    
            
            self.tweetsLabel.text = [NSString stringWithFormat:@"%@\ntweets",
                                      resp[@"entities"][@"retweet_count"]];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
