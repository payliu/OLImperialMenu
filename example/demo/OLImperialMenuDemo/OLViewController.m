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

    [self layoutImperialMenu];
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - layout MBImperialMenuView

- (void) layoutImperialMenu
{
    CGRect frame = CGRectZero;

    if ([UIDevice currentResolution] == UIDevice_iPhoneTallerHiRes) {

        frame = CGRectMake(0.0f, 439.0f, 275.0f, 88.0f);

    } else {

        frame = CGRectMake(0.0f, 353.0f, 275.0f, 88.0f);
    }

    _imperialMenu = [[OLImperialMenuView alloc] initWithFrame:frame closeSize:44.0f openSize:45.0f direction:ImperialDirecitonTop];

    _imperialMenu.delegate = self;

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

    // animate
    [self animateImperialMenu:YES];

}

- (void) animateImperialMenu:(BOOL)animated
{
    if (animated == NO) {

        [self.imperialMenu.layer removeAllAnimations];

    } else {

        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];

        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        anim.duration = 2.5f;
        anim.repeatCount = HUGE_VALF;
        anim.autoreverses = YES;
        anim.removedOnCompletion = NO; // to avoid animation gone after other operation
        // anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.01f, 0.99f, 1.f)];
        anim.toValue = [NSNumber numberWithFloat:8.f];

        [self.imperialMenu.layer addAnimation:anim forKey:nil];
    }
}

#pragma mark - OLImperialMenuViewDelegate

- (UIView *) imperialMenuView:(OLImperialMenuView *)menuView decorateView:(UIView *)view
{

    // user record
    UIButton *btnRecord = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *recordImg = [UIImage imageNamed:@"icon-ItemUser(L).png"];

    [btnRecord setBackgroundImage:recordImg forState:UIControlStateNormal];
    [btnRecord addTarget:self action:@selector(onRecord) forControlEvents:UIControlEventTouchUpInside];
    [btnRecord setFrame:CGRectMake(22.0f, view.frame.size.height / 2.f - recordImg.size.height / 2.f, 57.f, 50.f)];
    [view addSubview:btnRecord];

    // user setting
    UIButton *btnSetting = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *settingImg = [UIImage imageNamed:@"icon-ItemSetting(L).png"];

    [btnSetting setBackgroundImage:settingImg forState:UIControlStateNormal];
    [btnSetting addTarget:self action:@selector(onSetting) forControlEvents:UIControlEventTouchUpInside];
    [btnSetting setFrame:CGRectMake(btnRecord.right + 15.0f, view.frame.size.height / 2.f - settingImg.size.height / 2.f, 57.f, 50.f)];
    [view addSubview:btnSetting];

    // manual page
    UIButton *btnManual = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *manualImg = [UIImage imageNamed:@"icon-ItemManual(L).png"];

    [btnManual setBackgroundImage:manualImg forState:UIControlStateNormal];
    [btnManual addTarget:self action:@selector(onInstruction) forControlEvents:UIControlEventTouchUpInside];
    [btnManual setFrame:CGRectMake(btnSetting.right + 15.0f, view.frame.size.height / 2.f - manualImg.size.height / 2.f, 57.f, 50.f)];
    [view addSubview:btnManual];

    return view;
}

- (BOOL) imperialMenuViewWillMove:(OLImperialMenuView *)menuView open:(BOOL)open
{
    NSLog(@"%@", NSStringFromSelector(_cmd));

    [self animateImperialMenu:NO];

    return YES;
}

- (void) imperialMenuViewDidMove:(OLImperialMenuView *)menuView open:(BOOL)open
{
    NSLog(@"%@", NSStringFromSelector(_cmd));

    if (open == NO) {
        [self animateImperialMenu:YES];
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

    [self animateImperialMenu:NO];

    // [self hidesViewsType1:YES];
}

- (BOOL) imperialMenuViewWillClose:(OLImperialMenuView *)menuView
{
    NSLog(@"%@", NSStringFromSelector(_cmd));


    return YES;
}

- (void) imperialMenuViewDidClose:(OLImperialMenuView *)menuView
{
    NSLog(@"%@", NSStringFromSelector(_cmd));

    [self animateImperialMenu:YES];

    // [self hidesViewsType1:NO];
}

#pragma mark - miscellance

- (void) onSetting
{
    NSLog(@"onSetting");
}

- (void) onInstruction
{
    NSLog(@"onInstruction");
}

- (void) onRecord
{
      NSLog(@"onRecord");}

@end
