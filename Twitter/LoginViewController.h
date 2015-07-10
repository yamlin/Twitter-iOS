//
//  LoginViewController.h
//  Twitter
//
//  Created by Jhih-Yan Lin on 6/27/15.
//  Copyright (c) 2015 Jhih-Yan Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginViewController;

@protocol LoginViewControllerDelegate  <NSObject>

- (void)onLogin;

@end

@interface LoginViewController : UIViewController

@property(strong, nonatomic) id<LoginViewControllerDelegate> delegate;

@end
