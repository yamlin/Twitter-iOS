//
//  MentionViewController.h
//  Twitter
//
//  Created by Jhih-Yan Lin on 7/7/15.
//  Copyright (c) 2015 Jhih-Yan Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MentionViewController;

@protocol MentionVCDelegate <NSObject>

- (void)onMentionView;

@end
@interface MentionViewController : UIViewController

@property(strong, nonatomic) id<MentionVCDelegate> delegate;

@end
