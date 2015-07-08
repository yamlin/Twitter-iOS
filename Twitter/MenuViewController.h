//
//  MenuViewController.h
//  Twitter
//
//  Created by Jhih-Yan Lin on 7/4/15.
//  Copyright (c) 2015 Jhih-Yan Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuViewController;

@protocol MenuDelegate <NSObject>
- (void)onProfile;

- (void)onTwitterView;

- (void)onMentionView;
@end

@interface MenuViewController : UIViewController

@property(strong, nonatomic) id<MenuDelegate> delegate;
@end
