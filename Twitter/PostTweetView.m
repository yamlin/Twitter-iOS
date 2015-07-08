//
//  PostTweetView.m
//  Twitter
//
//  Created by Jhih-Yan Lin on 6/30/15.
//  Copyright (c) 2015 Jhih-Yan Lin. All rights reserved.
//

#import "PostTweetView.h"
#import "UIImageView+AFNetworking.h"



@interface PostTweetView ()
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UITextView *inputText;

@end

@implementation PostTweetView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"Submit" style:UIBarButtonItemStylePlain target:self action:@selector(onSubmit)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    self.navigationItem.title = @"New Tweet";
    
    self.userLabel.text = self.user.name;
    
    [self.userImage setImageWithURL: [NSURL URLWithString:self.user.profileImageUrl]];
    
    self.inputText.layer.borderWidth = 0.5f;
    self.inputText.layer.borderColor = [[UIColor blueColor] CGColor];
}


-(void)onSubmit {
    NSDictionary *params = @{@"status": self.inputText.text };
    
    [self.delegate postTweet:params];
    

}

-(void)onCancel {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTap:(id)sender {
    [self.inputText resignFirstResponder];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
