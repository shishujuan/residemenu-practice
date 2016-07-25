//
//  UIViewController+RESideMenu.m
//  RESideMenuPractice
//
//  Created by ssj on 2016/7/24.
//  Copyright © 2016年 ease. All rights reserved.
//

#import "UIViewController+RESideMenu.h"
#import "RESideMenu.h"

@implementation UIViewController (RESideMenu)

/**
 * 获取Root VC。
 */
- (RESideMenu *)sideMenuViewController
{
    UIViewController *iter = self.parentViewController;
    while (iter) {
        if ([iter isKindOfClass:[RESideMenu class]]) {
            return (RESideMenu *)iter;
        } else if (iter.parentViewController && iter.parentViewController != iter) {
            iter = iter.parentViewController;
        } else {
            iter = nil;
        }
    }
    return nil;
}

#pragma mark IB Action Helper methods

- (IBAction)presentLeftMenuViewController:(id)sender
{
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (IBAction)presentRightMenuViewController:(id)sender
{
    [self.sideMenuViewController presentRightMenuViewController];
}


@end
