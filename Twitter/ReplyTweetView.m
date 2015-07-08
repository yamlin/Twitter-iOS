//
//  ReplyTweetView.m
//  Twitter
//
//  Created by Jhih-Yan Lin on 6/30/15.
//  Copyright (c) 2015 Jhih-Yan Lin. All rights reserved.
//

#import "ReplyTweetView.h"
#import "UIImageView+AFNetworking.h"

@interface ReplyTweetView ()
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UITextView *inputText;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;


@end

@implementation ReplyTweetView


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"Submit" style:UIBarButtonItemStylePlain target:self action:@selector(onSubmit)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    self.navigationItem.title = @"Reply";
    
    
    [self.userImage setImageWithURL: [NSURL URLWithString:self.tweet.user.profileImageUrl]];
    self.userLabel.text = self.tweet.user.name;
    
    self.tweetText.text = self.tweet.text;

    self.inputText.layer.borderWidth = 0.5f;
    self.inputText.layer.borderColor = [[UIColor blueColor] CGColor];
}


-(void)onSubmit {
    
    [self.delegate onReply:self.inputText.text withTweet:self.tweet];

}

-(void)onCancel {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTouched:(id)sender {
    [self.inputText resignFirstResponder];
}

@end
