//
// OLViewController.m
// OLImperialMenuDemo
//
// Created by Pay Liu on 13/10/16.
// Copyright (c) 2013年 Octalord Information Inc. All rights reserved.
//

#import "OLViewController.h"

#import <OLCategoryHelper/UIDevice+Resolutions.h>
#import <OLCategoryHelper/UIView+ViewFrameGeometry.h>
#import <OLCategoryHelper/NSString+BOOL.h>

@implementation OLViewController

- (void) dealloc
{
    _imperialMenu.delegate = nil;
}

- (void) viewDidLoad
{
    [super viewDidLoad];

    [self layoutImperialMenuLeft];
    [self layoutImperialMenuRight];
    [self layoutImperialMenuTop];
    [self layoutImperialMenuBottom];
}

#pragma mark - layout OLImperialMenuView

- (void) layoutImperialMenuLeft
{
    CGRect frame = CGRectZero;

    CGFloat closeSize = 44.0f;

    if ([UIDevice currentResolution] == UIDevice_iPhoneTallerHiRes) {

        frame = CGRectMake(-275.f + closeSize, 439.0f, 275.0f, 88.0f);

    } else {

        frame = CGRectMake(-275.f + closeSize, 353.0f, 275.0f, 88.0f);
    }

    _imperialMenu = [[OLImperialMenuView alloc] initWithFrame:frame closeSize:closeSize openSize:45.0f direction:ImperialDirecitonLeft];

    _imperialMenu.delegate = self;

    // _imperialMenu.disableBackgroundView = NO;

    // UIView *bg = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // bg.backgroundColor = [UIColor redColor];
    // [_imperialMenu setBackgroundView:bg];

    // manu's backgroud
    UIEdgeInsets insets = { 0.0f, 12.0f, 0.0f, 30.0f };

    UIImage *img = [[UIImage imageNamed:@"MenuBar-Long"] resizableImageWithCapInsets:insets];
    UIImageView *bg = [[UIImageView alloc] initWithImage:img];

    bg.size = frame.size;

    _imperialMenu.manuBackgroudView = bg;

    // [self.view insertSubview:_imperialMenu belowSubview:_flowerView];
    [self.view addSubview:_imperialMenu];

}

- (void) layoutImperialMenuRight
{
    CGRect frame = CGRectZero;

    CGFloat closeSize = 44.0f;

    if ([UIDevice currentResolution] == UIDevice_iPhoneTallerHiRes) {

        frame = CGRectMake(320.0f - closeSize, 439.0f, 275.0f, 88.0f);

    } else {

        frame = CGRectMake(320.0f - closeSize, 353.0f, 275.0f, 88.0f);
    }

    _imperialMenu = [[OLImperialMenuView alloc] initWithFrame:frame closeSize:closeSize openSize:45.0f direction:ImperialDirecitonRight];

    _imperialMenu.delegate = self;

    // _imperialMenu.disableBackgroundView = NO;

    // UIView *bg = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // bg.backgroundColor = [UIColor redColor];
    // [_imperialMenu setBackgroundView:bg];

    // manu's backgroud
    UIEdgeInsets insets = { 0.0f, 12.0f, 0.0f, 30.0f };

    UIImage *img = [[UIImage imageNamed:@"MenuBar-Long"] resizableImageWithCapInsets:insets];
    UIImageView *bg = [[UIImageView alloc] initWithImage:img];

    bg.size = frame.size;

    _imperialMenu.manuBackgroudView = bg;

    // [self.view insertSubview:_imperialMenu belowSubview:_flowerView];
    [self.view addSubview:_imperialMenu];

}

- (void) layoutImperialMenuTop
{
    CGRect frame = CGRectZero;

    CGFloat closeSize = 44.0f;

    if ([UIDevice currentResolution] == UIDevice_iPhoneTallerHiRes) {

        frame = CGRectMake((320.f - 275.0) / 2.f, -88 + closeSize, 275.0f, 88.0f);

    } else {

        frame = CGRectMake((320.f - 275.0) / 2.f,  -88 + closeSize, 275.0f, 88.0f);
    }

    _imperialMenu = [[OLImperialMenuView alloc] initWithFrame:frame closeSize:closeSize openSize:45.0f direction:ImperialDirecitonTop];

    _imperialMenu.delegate = self;

    // _imperialMenu.disableBackgroundView = NO;

    // UIView *bg = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // bg.backgroundColor = [UIColor redColor];
    // [_imperialMenu setBackgroundView:bg];

    // manu's backgroud
    UIEdgeInsets insets = { 0.0f, 12.0f, 0.0f, 30.0f };

    UIImage *img = [[UIImage imageNamed:@"MenuBar-Long"] resizableImageWithCapInsets:insets];
    UIImageView *bg = [[UIImageView alloc] initWithImage:img];

    bg.size = frame.size;

    _imperialMenu.manuBackgroudView = bg;

    // [self.view insertSubview:_imperialMenu belowSubview:_flowerView];
    [self.view addSubview:_imperialMenu];

}

- (void) layoutImperialMenuBottom
{
    CGRect frame = CGRectZero;

    CGFloat closeSize = 44.0f;

    if ([UIDevice currentResolution] == UIDevice_iPhoneTallerHiRes) {

        frame = CGRectMake((320.f - 275.0) / 2.f, self.view.frame.size.height - 44.0f, 275.0f, 88.0f);

    } else {

        frame = CGRectMake((320.f - 275.0) / 2.f, self.view.frame.size.height - 44.0f, 275.0f, 88.0f);
    }

    _imperialMenu = [[OLImperialMenuView alloc] initWithFrame:frame closeSize:closeSize openSize:45.0f direction:ImperialDirecitonBottom];

    _imperialMenu.delegate = self;

    // _imperialMenu.disableBackgroundView = NO;

    // UIView *bg = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // bg.backgroundColor = [UIColor redColor];
    // [_imperialMenu setBackgroundView:bg];

    // manu's backgroud
    UIEdgeInsets insets = { 0.0f, 12.0f, 0.0f, 30.0f };

    UIImage *img = [[UIImage imageNamed:@"MenuBar-Long"] resizableImageWithCapInsets:insets];
    UIImageView *bg = [[UIImageView alloc] initWithImage:img];

    bg.size = frame.size;

    _imperialMenu.manuBackgroudView = bg;

    // [self.view insertSubview:_imperialMenu belowSubview:_flowerView];
    [self.view addSubview:_imperialMenu];

}

#pragma mark - OLImperialMenuViewDelegate

- (UIView *) imperialMenuView:(OLImperialMenuView *)menuView decorateView:(UIView *)view
{
    // user record
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];

    [btn setTitle:@"Button" forState:UIControlStateNormal];

    [btn setFrame:CGRectMake((view.width - 60.0f) / 2.f - 20.0f, (view.height - 50.0f) / 2.f, 60.f, 50.f)];

    [view addSubview:btn];

    return view;
}

- (BOOL) imperialMenuViewWillMove:(OLImperialMenuView *)menuView open:(BOOL)open
{
    NSLog(@"%@", NSStringFromSelector(_cmd));

    return YES;
}

- (void) imperialMenuViewDidMove:(OLImperialMenuView *)menuView open:(BOOL)open
{
    NSLog(@"%@", NSStringFromSelector(_cmd));

    if (open == NO) {
    }
}

- (BOOL) imperialMenuViewWillOpen:(OLImperialMenuView *)menuView
{
    NSLog(@"%@", NSStringFromSelector(_cmd));

    return YES;
}

- (void) imperialMenuViewDidOpen:(OLImperialMenuView *)menuView
{
    NSLog(@"%@", NSStringFromSelector(_cmd));

}

- (BOOL) imperialMenuViewWillClose:(OLImperialMenuView *)menuView
{
    NSLog(@"%@", NSStringFromSelector(_cmd));

    return YES;
}

- (void) imperialMenuViewDidClose:(OLImperialMenuView *)menuView
{
    NSLog(@"%@", NSStringFromSelector(_cmd));

}

@end
