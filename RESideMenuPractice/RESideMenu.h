//
//  RESideMenu.h
//  RESideMenuPractice
//
//  Created by ssj on 2016/7/24.
//  Copyright © 2016年 ease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RESideMenu : UIViewController <UIGestureRecognizerDelegate>


@property (strong, nonatomic) UIViewController *contentViewController;
@property (strong, nonatomic) UIViewController *leftMenuViewController;
@property (strong, nonatomic) UIViewController *rightMenuViewController;

@property (nonatomic) CGFloat contentViewScaleValue;
@property (nonatomic) CGFloat backgroundImageViewScaleValue;
@property (nonatomic) CGFloat menuViewScaleValue;

@property (nonatomic) CGAffineTransform backgroundImageViewTransformation;
@property (nonatomic) CGAffineTransform menuViewControllerTransformation;


- (void)presentLeftMenuViewController;
- (void)presentRightMenuViewController;

- (void)hideMenuViewController;

- (void)setContentViewController:(UIViewController *)contentViewController animated:(BOOL)animated;

@end
