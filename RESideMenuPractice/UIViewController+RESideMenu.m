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
    NSLog(@"present left menu view controller");
}

- (IBAction)presentRightMenuViewController:(id)sender
{
    NSLog(@"present right menu view controller");
}


@end
