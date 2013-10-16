//
// MBMenuView.h
// MorningBee
//
// Created by Pay on 13/3/8.
// Copyright (c) 2013年 Octalord. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OLImperialMenuViewDelegate.h"

typedef NS_ENUM (NSUInteger, ImperialDireciton) {

    ImperialDirecitonLeft,
    ImperialDirecitonRight,
    ImperialDirecitonTop,
    ImperialDirecitonBottom
};

@interface OLImperialMenuView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, assign, readonly, getter = isOpen) BOOL open;
@property (nonatomic, assign, readonly, getter = isMoving) BOOL moving;
@property (nonatomic, assign, readonly) CGFloat closeSize;
@property (nonatomic, assign, readonly) CGFloat openSize;
@property (nonatomic, assign, readonly) ImperialDireciton direction;

@property (nonatomic, strong) UIView *backgroundView;  // 可以設定背景, 預設: RGB(58,58,58)
@property (nonatomic, assign) BOOL disableBackgroundView; // default  NO
@property (nonatomic, strong) UIImageView *manuBackgroudView;
@property (nonatomic, strong) UIView *decoView;
@property (nonatomic, weak) id<OLImperialMenuViewDelegate> delegate;

- (id) initWithFrame:(CGRect)frame closeSize:(CGFloat)closeSize openSize:(CGFloat)openSize direction:(ImperialDireciton)direction;

- (void) setImperialMenuOpen:(BOOL)open animated:(BOOL)animated;

@end
