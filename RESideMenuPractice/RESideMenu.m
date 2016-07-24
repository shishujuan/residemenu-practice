//
//  RESideMenu.m
//  RESideMenuPractice
//
//  Created by ssj on 2016/7/24.
//  Copyright © 2016年 ease. All rights reserved.
//

#import "RESideMenu.h"

@interface RESideMenu()

@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIImage *backgroundImage;
@property (strong, nonatomic) UIView *menuViewContainer;
@property (strong, nonatomic) UIView *contentViewContainer;

@end

@implementation RESideMenu


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化View Controller，中间的内容和左右侧边栏的视图控制器。
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"];
    self.leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenuViewController"];
    self.rightMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightMenuViewController"];
    
    //初始化背景图，侧边栏视图容器和内容视图容器。侧边栏视图容器用来放左右侧边栏视图，内容视图容器放中间内容视图。
    self.backgroundImageView = ({
        self.backgroundImage = [UIImage imageNamed:@"Stars"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        imageView.image = self.backgroundImage;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView;
    });
    self.menuViewContainer = ({
        UIView *menuViewContainer = [[UIView alloc] init];
        menuViewContainer.frame = self.view.bounds;
        menuViewContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        menuViewContainer;
    });
    self.contentViewContainer = ({
        UIView *contentViewContainer = [[UIView alloc] init];
        contentViewContainer.frame = self.view.bounds;
        contentViewContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        contentViewContainer;
    });

    //添加各个子视图
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.menuViewContainer];
    [self.view addSubview:self.contentViewContainer];
    

    //添加子视图控制器。
    if (self.leftMenuViewController) {
        [self addChildViewController:self.menuViewContainer childViewController:self.leftMenuViewController];
    }
    if (self.rightMenuViewController) {
        [self addChildViewController:self.menuViewContainer childViewController:self.rightMenuViewController];
    }
    [self addChildViewController:self.contentViewContainer childViewController:self.contentViewController];
}

- (void)addChildViewController:(UIView *)container childViewController:(UIViewController *)childViewController {
    [self addChildViewController:childViewController];
    childViewController.view.frame = self.view.bounds;
    [container addSubview:childViewController.view];
    [childViewController didMoveToParentViewController:self];
}


@end
