//
// UIButton+PassTouch.m
// MorningBee
//
// Created by Pay on 13/3/12.
// Copyright (c) 2013年 Octalord. All rights reserved.
//

#import "UIButton+PassTouch.h"
#import "OLImperialMenuView.h"

@implementation UIButton (PassTouch)

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];

    if ([self.nextResponder.nextResponder isKindOfClass:[OLImperialMenuView class]] == YES) {

        [self.nextResponder.nextResponder touchesMoved:touches withEvent:event];
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.nextResponder.nextResponder isKindOfClass:[OLImperialMenuView class]] == NO) {

        [super touchesEnded:touches withEvent:event];

    } else {

        OLImperialMenuView *imperial = (OLImperialMenuView *)self.nextResponder.nextResponder;

        if (imperial.isMoving == NO) {

            [super touchesEnded:touches withEvent:event];

        } else {

            // imperial is draging, so don't need call [super touchesEnded], it mean cancel button press
            [imperial touchesEnded:touches withEvent:event];

            self.highlighted = NO;
        }
    }
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
}

@end
