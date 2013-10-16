//
// OLViewController.h
// OLImperialMenuDemo
//
// Created by Pay Liu on 13/10/16.
// Copyright (c) 2013年 Octalord Information Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OLImperialMenuView.h"

@interface OLViewController : UIViewController<OLImperialMenuViewDelegate>

@property (strong, nonatomic) OLImperialMenuView *imperialMenu;

@end
