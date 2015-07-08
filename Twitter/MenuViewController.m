//
//  MenuViewController.m
//  Twitter
//
//  Created by Jhih-Yan Lin on 7/4/15.
//  Copyright (c) 2015 Jhih-Yan Lin. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuCell.h"
#import "UIImageView+AFNetworking.h"
#import "User.h"


@interface MenuViewController ()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    User *user = [User getUser];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MenuCell"  bundle:nil] forCellReuseIdentifier:@"MenuCell"];
    self.userImage.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.delegate = self;
    [self.userImage addGestureRecognizer:tapGesture];
  
    
    [self.userImage setImageWithURL: [NSURL URLWithString: user.profileImageUrl]];
    self.userLabel.text = user.name;
    
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

}

- (void)onTap:(UITapGestureRecognizer *)tapGesture {
    if (self.delegate == nil) {
        NSLog(@"delegate is nil");
    }
    [self.delegate onProfile];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    
    switch (indexPath.row) {
        case 0:
            cell.label.text = @"Home";
            break;
        case 1:
            cell.label.text = @"Mentions";
        default:
            break;
    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self.delegate onTwitterView];
    } else if (indexPath.row == 1) {
        [self.delegate onMentionView];
    }
}

@end
