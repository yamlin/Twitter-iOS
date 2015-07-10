//
//  TweetCell.m
//  Twitter
//
//  Created by Jhih-Yan Lin on 6/28/15.
//  Copyright (c) 2015 Jhih-Yan Lin. All rights reserved.
//

#import "TweetCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "TwitterClient.h"
#import "ReplyViewController.h"


@interface TweetCell()

@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnFavorite;
@property (weak, nonatomic) IBOutlet UIButton *btnRetweet;

@property (assign, nonatomic) BOOL favorite;

@property (strong, nonatomic) Tweet *tweetInfo;
@end

@implementation TweetCell

- (void)awakeFromNib {
    // Initialization code
}

- (IBAction)onClick:(id)sender {    
    [self.delegate onProfile:self.tweetInfo.user];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setTweet:(Tweet *)tweet {
    self.tweetInfo = tweet;
    
    [self.userImage setImageWithURL: [NSURL URLWithString:tweet.user.profileImageUrl]];
    self.userLabel.text = tweet.user.name;
    self.screenLabel.text = [NSString stringWithFormat:@"@%@",tweet.user.screenName];
    self.descriptionLabel.text = tweet.text;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yy-MM-dd HH:mm:ss"];
    self.dateLabel.text = [dateFormat stringFromDate:tweet.createdDate];
    
    self.favorite = [tweet.favorite boolValue];
    [self changeFavorite:self.favorite];
    
    [self changeRetweet:[self.tweetInfo.retweet boolValue]];
    
}

- (void)changeFavorite:(BOOL)favorite {
    if (favorite) {
        [self.btnFavorite setImage:[UIImage imageNamed:@"favorite_on.png"] forState:UIControlStateNormal];
    } else {
        [self.btnFavorite setImage:[UIImage imageNamed:@"favorite.png"] forState:UIControlStateNormal];
    }
}

- (void)changeRetweet:(BOOL)retweet {
    if (retweet) {
        [self.btnRetweet setImage:[UIImage imageNamed:@"retweet_on.png"] forState:UIControlStateNormal];
    } else {
        [self.btnRetweet setImage:[UIImage imageNamed:@"retweet.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)onFavorite:(id)sender {
//    [self.delegate favorite:!self.favorite withId:self.tweetInfo.tweedId onCompleted:^(NSError *error) {
//        
//        if (error == nil) {
//            self.favorite = !self.favorite;
//            [self changeFavorite:self.favorite];
//        }
//    }];
    [[TwitterClient sharedInstance] favorite:!self.favorite withId:self.tweetInfo.tweedId completion:^(NSError *error) {
        if (error == nil) {
            self.favorite = !self.favorite;
            [self changeFavorite:self.favorite];
        }
    }]; 

}

- (IBAction)onRetweet:(id)sender {
    [[TwitterClient sharedInstance] retweetWithId:self.tweetInfo.tweedId completion:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Fail retweet: %@", error.description);
        } else {
            NSLog(@"retweeted %@", self.tweetInfo.tweedId);
            //self.tweetInfo.retweet = @"1";
            [self changeRetweet:YES];
        }

    }];
}

- (IBAction)onReply:(id)sender {
    [self.delegate replyTweet:self.tweetInfo];
    
}

@end
