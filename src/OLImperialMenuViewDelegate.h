//
// MBImperialMenuViewDelegate.h
// MorningBee
//
// Created by Pay on 13/3/9.
// Copyright (c) 2013年 Octalord. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OLImperialMenuView;

@protocol OLImperialMenuViewDelegate <NSObject>

@optional

- (UIView *) imperialMenuView:(OLImperialMenuView *)menuView decorateView:(UIView *)view;

/*
 * @return
 * YES: continue to move menu
 * NO: abort move
 */
- (BOOL) imperialMenuViewWillMove:(OLImperialMenuView *)menuView open:(BOOL)open;

/*
 neither DidOpen nor DidClose, but finish Move on boundary
 */
- (void) imperialMenuViewDidMove:(OLImperialMenuView *)menuView open:(BOOL)open;

/*
 * @return
 * YES: continue to open menu
 * NO: abort open
 */
- (BOOL) imperialMenuViewWillOpen:(OLImperialMenuView *)menuView;
- (void) imperialMenuViewDidOpen:(OLImperialMenuView *)menuView;

/*
 * @return
 * YES: continue to close menu
 * NO: abort close
 */
- (BOOL) imperialMenuViewWillClose:(OLImperialMenuView *)menuView;
- (void) imperialMenuViewDidClose:(OLImperialMenuView *)menuView;

@end
