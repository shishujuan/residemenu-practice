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

@property (strong, nonatomic) UIButton *contentButton;
@property (nonatomic) CGFloat animationDuration;
@property (nonatomic) CGFloat contentViewInLandscapeOffsetCenterX;
@property (nonatomic) CGFloat contentViewInPortraitOffsetCenterX;
@property (nonatomic) CGFloat contentViewFadeOutAlpha;
@property (nonatomic) BOOL leftMenuVisible;
@property (nonatomic) BOOL rightMenuVisible;

@end

@implementation RESideMenu


- (void)commonInit {
    self.animationDuration = 0.35f;
    self.contentViewScaleValue = 0.7f;
    self.contentViewInLandscapeOffsetCenterX = 30.0f;
    self.contentViewInPortraitOffsetCenterX = 30.0f;
    self.contentViewFadeOutAlpha = 0.5;
    self.backgroundImageViewTransformation = CGAffineTransformMakeScale(1.7, 1.7);
    self.menuViewControllerTransformation = CGAffineTransformMakeScale(1.5, 1.5);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
    
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
    
    //添加一个按钮点击的时候隐藏侧边栏。注意这个按钮在显示侧边栏的时候会添加到内容视图中。
    self.contentButton = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectNull];
        [button addTarget:self action:@selector(hideMenuViewController) forControlEvents:UIControlEventTouchUpInside];
        button;
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

- (void)addContentButton
{
    if (self.contentButton.superview)
        return;
    
    self.contentButton.autoresizingMask = UIViewAutoresizingNone;
    self.contentButton.frame = self.contentViewContainer.bounds;
    self.contentButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.contentViewContainer addSubview:self.contentButton];
}

- (void)presentLeftMenuViewController {
    [self presentMenuViewContainerWithMenuViewController:self.leftMenuViewController];
    [self showLeftMenuViewController];
}

/**   
 * 放大背景图和侧边栏，这样第一次显示侧边栏的时候才会有缩小的动画效果。
 */
- (void)presentMenuViewContainerWithMenuViewController:(UIViewController *)menuViewController {
    self.backgroundImageView.transform = self.backgroundImageViewTransformation;
    self.menuViewContainer.transform = self.menuViewControllerTransformation;
    self.menuViewContainer.alpha = 0;
}


- (void)showLeftMenuViewController {
    if (!self.leftMenuViewController) {
        return;
    }
    
    //添加一个按钮，这样点击的时候可以显示内容视图，在隐藏侧边栏的时候需要移除这个按钮。
    [self addContentButton];
    [self.leftMenuViewController beginAppearanceTransition:YES animated:YES];
    self.leftMenuViewController.view.hidden = NO;
    self.rightMenuViewController.view.hidden = YES;
    
    [UIView animateWithDuration:self.animationDuration animations:^{
        //设置内容视图的缩放比例为0.7
        self.contentViewContainer.transform = CGAffineTransformMakeScale(self.contentViewScaleValue, self.contentViewScaleValue);
        
        //修改内容视图的center，这样内容视图会右移，左侧留出空间显示侧栏。
        self.contentViewContainer.center = CGPointMake((UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) ? self.contentViewInLandscapeOffsetCenterX + CGRectGetWidth(self.view.frame) : self.contentViewInPortraitOffsetCenterX + CGRectGetWidth(self.view.frame)), self.contentViewContainer.center.y);
        
        //设置menuViewContainer和contentViewContainer的透明度。
        self.menuViewContainer.alpha = 1.0f;
        self.contentViewContainer.alpha = self.contentViewFadeOutAlpha;
        
        //复位背景图和菜单栏的缩放比例。在隐藏左侧栏的方法中，我们会放大背景图和左侧栏。
        self.backgroundImageView.transform = CGAffineTransformIdentity;
        self.menuViewContainer.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self.leftMenuViewController endAppearanceTransition];
        self.leftMenuVisible = YES;
        self.rightMenuVisible = NO;
    }];
}

- (void)hideMenuViewController {
    [self hideMenuViewController:YES];
}

- (void)hideMenuViewController:(BOOL)animated {
    UIViewController *visibleMenuViewController = self.rightMenuVisible ? self.rightMenuViewController : self.leftMenuViewController;
    [visibleMenuViewController beginAppearanceTransition:NO animated:animated];
    
    self.leftMenuVisible = NO;
    self.rightMenuVisible = NO;
    
    //移除按钮，否则会影响原来的内容视图响应事件
    [self.contentButton removeFromSuperview];
    
    __typeof (self) __weak weakSelf = self;
    void (^animationBlock)(void) = ^{
        __typeof (weakSelf) __strong strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        
        //恢复内容视图的缩放比例为1，重置frame。
        strongSelf.contentViewContainer.transform = CGAffineTransformIdentity;
        strongSelf.contentViewContainer.frame = strongSelf.view.bounds;
        
        //设置背景图和侧边栏的缩放比例
        strongSelf.backgroundImageView.transform = self.backgroundImageViewTransformation;
        strongSelf.menuViewContainer.transform = self.menuViewControllerTransformation;

        //设置侧边栏和内容视图的透明度值
        strongSelf.menuViewContainer.alpha = 0;
        strongSelf.contentViewContainer.alpha = 1;
        
    };
    void (^completionBlock)(void) = ^{
        [visibleMenuViewController endAppearanceTransition];
    };
    
    if (animated) {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [UIView animateWithDuration:self.animationDuration animations:^{
            animationBlock();
        } completion:^(BOOL finished) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            completionBlock();
        }];
    } else {
        animationBlock();
        completionBlock();
    }
}

@end
