//
// MBMenuView.m
// MorningBee
//
// Created by Pay on 13/3/8.
// Copyright (c) 2013年 Octalord. All rights reserved.
//

#import "OLImperialMenuView.h"
#import <OLCategoryHelper/UIView+ViewFrameGeometry.h>
#import "UIButton+Passtouch.h"

#pragma mark - Define Area

#define kSCREEN_WIDTH [[UIScreen mainScreen] applicationFrame].size.width
#define kSCREEN_HEIGHT [[UIScreen mainScreen] applicationFrame].size.height
#define kEXPAND_THRESHOLD_CENTER_HORIZONTAL ((kSCREEN_WIDTH - _openSize + _closeSize) * 0.5f)
#define kEXPAND_THRESHOLD_CENTER_VERTICAL ((kSCREEN_HEIGHT - _openSize + _closeSize) * 0.5f)
#define kEXPAND_THRESHOLD_FACTOR 0.4f
#define kANIMATION_INTERVAL 0.2f
#define kBACKGROUND_ALPHA 0.85f
#define kMAX_MOVEMENT abs(_openPosition - _closePosition)

#pragma mark - Class Extension

@interface OLImperialMenuView ()

typedef NS_ENUM (NSUInteger, MoveAgreement) {
    MoveAgreementUnknow,
    MoveAgreementCanMove,
    MoveAgreementDeny,
    MoveAgreementNoResponsed
};

@property (nonatomic, assign) CGFloat closePosition; // X or Y
@property (nonatomic, assign) CGFloat openPosition; // X or Y
@property (nonatomic, assign) MoveAgreement moveAgreement;

@end

@implementation OLImperialMenuView

#pragma mark - Memory management

- (void) dealloc
{
    [_backgroundView removeFromSuperview];
}

#pragma mark - setter/getter

- (UIView *) backgroundView
{
    if (_backgroundView == nil) {

        UIColor *backColor = [[UIColor alloc] initWithWhite:(58.0f / 255.0f) alpha:kBACKGROUND_ALPHA];

        _backgroundView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

        _backgroundView.backgroundColor = backColor;

        _backgroundView.alpha = 0.0f;
    }

    if (_backgroundView.superview == nil) {

        if (self.disableBackgroundView == NO) {

            [self.superview insertSubview:_backgroundView belowSubview:self];
        }
    }

    return _backgroundView;
}

- (void) setManuBackgroudView:(UIImageView *)manuBackgroudView
{

    if (_manuBackgroudView == manuBackgroudView) {

        return;
    }

    if (_manuBackgroudView != nil) {

        [_manuBackgroudView removeFromSuperview];
    }

    _manuBackgroudView = manuBackgroudView;

    [self insertSubview:_manuBackgroudView atIndex:0];

}

#pragma mark - View lifecycle

- (id) initWithFrame:(CGRect)frame closeSize:(CGFloat)closeSize openSize:(CGFloat)openSize direction:(ImperialDireciton)direction
{
    _direction = direction;

    CGRect fit = CGRectZero;

    if (direction == ImperialDirecitonLeft) {

        fit = CGRectMake(closeSize - frame.size.width
                         , frame.origin.y
                         , frame.size.width
                         , frame.size.height);

    } else if (direction == ImperialDirecitonRight) {

        fit = CGRectMake(kSCREEN_WIDTH - closeSize
                         , frame.origin.y
                         , frame.size.width
                         , frame.size.height);

    } else if (direction == ImperialDirecitonTop) {

        fit = CGRectMake(frame.origin.x
                         , closeSize - frame.size.height
                         , frame.size.width
                         , frame.size.height);

    } else if (direction == ImperialDirecitonBottom) {

        fit = CGRectMake(frame.origin.x
                         , kSCREEN_HEIGHT - closeSize
                         , frame.size.width
                         , frame.size.height);

    }

    self = [super initWithFrame:fit];

    if (self != nil) {

        _open = NO;
        _closeSize = closeSize;
        _openSize = openSize;

        if (direction == ImperialDirecitonLeft) {

            _closePosition = self.left;      // closeSize - self.frame.size.width
            _openPosition = kSCREEN_WIDTH - _openSize - self.size.width;

        } else if (direction == ImperialDirecitonRight) {

            _closePosition = self.left;
            _openPosition = _openSize;

        } else if (direction == ImperialDirecitonTop) {

            _closePosition = self.top;
            _openPosition = kSCREEN_HEIGHT - _openSize - self.size.height;

        } else if (direction == ImperialDirecitonBottom) {

            _closePosition = self.top;
            _openPosition = _openSize;
        }

        [self setupGesture];

        _disableBackgroundView = NO;

        // self.backgroundColor = [UIColor redColor];  // for debug
    }

    return self;
}

#pragma mark - gesture

- (void) setupGesture
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizer:)];

    tapGestureRecognizer.delegate = self;
    tapGestureRecognizer.numberOfTapsRequired = 1;

    [self addGestureRecognizer:tapGestureRecognizer];
}

/* UIGestureRecognizerDelegate */
- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIControl class]]) {

        return NO;
    }

    return YES;
}

/* action: tapGestureRecognizer */
- (void) singleTapGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"%@", NSStringFromSelector(_cmd));

    [self setImperialMenuOpen:(_open == NO) animated:YES];
}

#pragma mark - touchs

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];

    UITouch *t = [touches anyObject];

    CGPoint touchPosition = [t locationInView:self.superview];

    NSLog(@"%@, %@", NSStringFromSelector(_cmd), NSStringFromCGPoint(touchPosition));

    [self decorateView];
    [self backgroundView];     // fire to alloc backgroundView if don't exist. 否則在第一次，往左邊拉動時候，會閃黑 (在動畫 驅動第一次）
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];

    if ([self invokeImperialMenuViewWillMove] == NO) {

        // user wouldn't like to move it.

    } else {

        UITouch *t = [touches anyObject];

        CGPoint touchLocation = [t locationInView:self.superview];

        CGPoint previousTouchLocation = [t previousLocationInView:self.superview];

        NSLog(@"%@, %@ -> %@", NSStringFromSelector(_cmd), NSStringFromCGPoint(previousTouchLocation), NSStringFromCGPoint(touchLocation));

        if (self.direction == ImperialDirecitonLeft || self.direction == ImperialDirecitonRight) {

            CGFloat delta = touchLocation.x - previousTouchLocation.x;

            CGFloat left = self.left + delta;

            left = [self boundLayoutHorizontal:left];

            if (left != self.left) {

                self.left = left;

                self.backgroundView.alpha = kBACKGROUND_ALPHA * abs(left - _closePosition) / kMAX_MOVEMENT;

                _moving = YES;

            } else {

                _moving = NO;
            }
        } else { // ImperialDirecitonTop or ImperialDirecitonBottom

            CGFloat delta = touchLocation.y - previousTouchLocation.y;

            CGFloat top = self.top + delta;

            top = [self boundLayoutVertical:top];

            if (top != self.top) {

                self.top = top;

                self.backgroundView.alpha = kBACKGROUND_ALPHA * abs(top - _closePosition) / kMAX_MOVEMENT;

                _moving = YES;

            } else {

                _moving = NO;
            }
        }
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];

    UITouch *t = [touches anyObject];

    CGPoint touchPosition = [t locationInView:self.superview];

    NSLog(@"%@, %@", NSStringFromSelector(_cmd), NSStringFromCGPoint(touchPosition));

    [self gotoRightPosition];

    _moving = NO;

    if (_moveAgreement != MoveAgreementNoResponsed) {

        _moveAgreement = MoveAgreementUnknow;
    }
}

- (CGFloat) thresholdLeft
{
    static CGFloat threshold = MAXFLOAT;

    if (threshold == MAXFLOAT) {
        threshold = kEXPAND_THRESHOLD_CENTER_HORIZONTAL * (1.0f - kEXPAND_THRESHOLD_FACTOR);
    }

    return threshold;
}

- (CGFloat) thresholdRight
{

    static CGFloat threshold = MAXFLOAT;

    if (threshold == MAXFLOAT) {
        threshold = kEXPAND_THRESHOLD_CENTER_HORIZONTAL * (1.0f + kEXPAND_THRESHOLD_FACTOR);
    }

    return threshold;
}

- (CGFloat) thresholdTop
{
    static CGFloat threshold = MAXFLOAT;

    if (threshold == MAXFLOAT) {
        threshold = kEXPAND_THRESHOLD_CENTER_VERTICAL * (1.0f - kEXPAND_THRESHOLD_FACTOR);
    }

    return threshold;
}

- (CGFloat) thresholdBottom
{
    static CGFloat threshold = MAXFLOAT;

    if (threshold == MAXFLOAT) {
        threshold = kEXPAND_THRESHOLD_CENTER_VERTICAL * (1.0f + kEXPAND_THRESHOLD_FACTOR);
    }

    return threshold;
}

- (void) gotoRightPosition
{
    if (self.isOpen == YES) {

        NSLog(@"%@, %f, %f", NSStringFromSelector(_cmd), self.right, self.thresholdRight);

        if ((self.direction == ImperialDirecitonLeft && self.right > self.thresholdRight) ||
            (self.direction == ImperialDirecitonRight && self.left < self.thresholdLeft) ||
            (self.direction == ImperialDirecitonTop && self.bottom > self.thresholdBottom) ||
            (self.direction == ImperialDirecitonBottom && self.top < self.thresholdTop)) {

            // restore to open
            [self runOpenAnimationAndDidOpen:NO];

        } else {

            // close process
            [self runCloseProcessWithAnimated:YES];

        }
    } else {

        NSLog(@"%@, %f, %f", NSStringFromSelector(_cmd), self.right, self.thresholdLeft);

        if ((self.direction == ImperialDirecitonLeft && self.right < self.thresholdLeft) ||
            (self.direction == ImperialDirecitonRight && self.left > self.thresholdRight) ||
            (self.direction == ImperialDirecitonTop && self.bottom < self.thresholdTop) ||
            (self.direction == ImperialDirecitonBottom && self.top > self.thresholdBottom)) {

            // restore to close
            [self runCloseAnimationAndDidClose:NO];

        } else {

            // open process
            [self runOpenProcessWithAnimated:YES];
        }
    }
}

- (void) runCloseProcessWithAnimated:(BOOL)animated
{
    BOOL continued = [self invokeImperialMenuViewWillClose];

    if (continued == NO) {

        // user cancel it
        if (animated == YES) {

            // restore to close
            [self runOpenAnimationAndDidOpen:NO];
        }
    } else {

        _open = NO;

        if (animated == YES) {

            [self runCloseAnimationAndDidClose:YES];

        } else {

            [self setClosedViewAttribute];

            [self invokeImperialMenuViewDidClose];
        }
    }
}

- (void) runOpenProcessWithAnimated:(BOOL)animated
{
    BOOL continued = [self invokeImperialMenuViewWillOpen];

    if (continued == NO) {

        // user cancel it

        if (animated == YES) {

            // restore to close
            [self runCloseAnimationAndDidClose:NO];
        }
    } else {

        _open = YES;

        if (animated == YES) {

            [self runOpenAnimationAndDidOpen:YES];

        } else {

            [self setOpenViewAttribute];

            [self invokeImperialMenuViewDidOpen];
        }
    }
}

- (void) runOpenAnimationAndDidOpen:(BOOL)didOpen
{
    [UIView animateWithDuration:kANIMATION_INTERVAL
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{

                         [self setOpenViewAttribute];

                     } completion:^(BOOL finished) {

                         if (didOpen == YES) {

                             [self invokeImperialMenuViewDidOpen];

                         } else {

                             [self invokeImperialMenuViewDidMove];
                         }
                     }];
}

- (void) runCloseAnimationAndDidClose:(BOOL)didClose
{
    [UIView animateWithDuration:kANIMATION_INTERVAL
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{

                         [self setClosedViewAttribute];

                     } completion:^(BOOL finished) {

                         if (didClose == YES) {

                             [self invokeImperialMenuViewDidClose];

                         } else {

                             [self invokeImperialMenuViewDidMove];
                         }
                     }];
}

- (void) setOpenViewAttribute
{
    if (self.direction == ImperialDirecitonLeft || self.direction == ImperialDirecitonRight) {

        self.left = _openPosition;

    } else {

        self.top = _openPosition;
    }

    self.backgroundView.alpha = kBACKGROUND_ALPHA;
}

- (void) setClosedViewAttribute
{
    if (self.direction == ImperialDirecitonLeft || self.direction == ImperialDirecitonRight) {

        self.left = _closePosition;

    } else {

        self.top = _closePosition;
    }

    self.backgroundView.alpha = 0.0f;
}

/*
 讓view.right 不會超過 closeSize and openSize
 */
- (CGFloat) boundLayoutHorizontal:(CGFloat)left
{
    if (self.direction == ImperialDirecitonLeft) {

        if (left >= _openPosition) {

            left = _openPosition;

        } else if (left <= _closePosition) {  // right <= _closeSize

            left = _closePosition;
        }
    } else if (self.direction == ImperialDirecitonRight) {

        if (left <= _openPosition) {

            left = _openPosition;

        } else if (left >= _closePosition) {

            left = _closePosition;
        }
    }

    return left;
}

- (CGFloat) boundLayoutVertical:(CGFloat)top
{
    if (self.direction == ImperialDirecitonTop) {

        if (top >= _openPosition) {

            top = _openPosition;

        } else if (top <= _closePosition) {

            top = _closePosition;
        }
    } else if (self.direction == ImperialDirecitonBottom) {

        if (top <= _openPosition) {

            top = _openPosition;

        } else if (top >= _closePosition) {

            top = _closePosition;
        }
    }

    return top;
}

#pragma mark - public method

- (void) setImperialMenuOpen:(BOOL)open animated:(BOOL)animated
{
    NSLog(@"%@", NSStringFromSelector(_cmd));

    if (self.open == open) {

        // no change, do nothing.

    } else {

        if (open == YES) {

            [self decorateView];             // maybe, still not decorate view at present

            [self runOpenProcessWithAnimated:animated];

        } else {

            [self runCloseProcessWithAnimated:animated];
        }
    }
}

#pragma mark - MBImperialMenuViewDelegate

- (void) decorateView
{
    if (_decoView != nil) {

        return;         // aleray decorate
    }

    SEL decorateViewSel = @selector(imperialMenuView:decorateView:);

    BOOL isResponsed = [_delegate respondsToSelector:decorateViewSel];

    if (isResponsed == NO) {

        // there is no deco view.

    } else {

        // preare decoView for delegate
        _decoView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height)];

        self.decoView = [self.delegate imperialMenuView:self decorateView:_decoView];

        [self addSubview:_decoView];
    }
}

- (BOOL) invokeImperialMenuViewWillMove
{
    BOOL continued = YES;

    if (_moveAgreement == MoveAgreementNoResponsed) {

        continued = YES;

    } else if (_moveAgreement == MoveAgreementDeny) {

        continued = NO;

    } else if (_moveAgreement == MoveAgreementCanMove) {

        continued = YES;

    } else if (_moveAgreement == MoveAgreementUnknow) {

        NSLog(@"%@", NSStringFromSelector(_cmd));

        SEL sel = @selector(imperialMenuViewWillMove:open:);

        if ([_delegate respondsToSelector:sel] == NO) {

            continued = YES;
            _moveAgreement = MoveAgreementNoResponsed;

        } else {

            continued = [self.delegate imperialMenuViewWillMove:self open:_open];

            if (continued == NO) {

                // user cancel it
                NSLog(@"%@ [delegate(%@) %@] return NO", NSStringFromSelector(_cmd)
                      , NSStringFromClass([self.delegate class])
                      , NSStringFromSelector(sel));

                _moveAgreement = MoveAgreementDeny;

            } else {

                _moveAgreement = MoveAgreementCanMove;
            }
        }
    } else {

        NSLog(@"%@, _moveAgreement(%d) is undefined.", NSStringFromSelector(_cmd), _moveAgreement);

        continued = NO;
    }

    return continued;

}

- (void) invokeImperialMenuViewDidMove
{
    static NSObject *checked = nil;

    static BOOL isResponsed = NO;

    if (checked == nil) {

        checked = [[NSObject alloc] init];         // do once

        SEL sel = @selector(imperialMenuViewDidMove:open:);

        isResponsed = [_delegate respondsToSelector:sel];
    }

    if (isResponsed == NO) {

        // do not implement imperialMenuViewDidOpen

    } else {

        [self.delegate imperialMenuViewDidMove:self open:_open];
    }
}

- (BOOL) invokeImperialMenuViewWillOpen
{
    SEL sel = @selector(imperialMenuViewWillOpen:);

    static NSObject *checked = nil;

    static BOOL isResponsed = NO;

    if (checked == nil) {

        checked = [[NSObject alloc] init];         // do once

        isResponsed = [_delegate respondsToSelector:sel];
    }

    BOOL continued = YES;

    if (isResponsed == NO) {

        // do not implement imperialMenuViewWillOpen
        continued = YES;

    } else {

        continued = [self.delegate imperialMenuViewWillOpen:self];

        if (continued == NO) {

            // user cancel it
            NSLog(@"%@ [delegate(%@) %@] return NO", NSStringFromSelector(_cmd)
                  , NSStringFromClass([self.delegate class])
                  , NSStringFromSelector(sel));

        }
    }

    return continued;
}

- (void) invokeImperialMenuViewDidOpen
{
    static NSObject *checked = nil;

    static BOOL isResponsed = NO;

    if (checked == nil) {

        checked = [[NSObject alloc] init];         // do once

        SEL sel = @selector(imperialMenuViewDidOpen:);

        isResponsed = [_delegate respondsToSelector:sel];
    }

    if (isResponsed == NO) {

        // do not implement imperialMenuViewDidOpen

    } else {

        [self.delegate imperialMenuViewDidOpen:self];
    }
}

- (BOOL) invokeImperialMenuViewWillClose
{
    SEL sel = @selector(imperialMenuViewWillClose:);

    static NSObject *checked = nil;

    static BOOL isResponsed = NO;

    if (checked == nil) {

        checked = [[NSObject alloc] init];         // do once

        isResponsed = [_delegate respondsToSelector:sel];

    }

    BOOL continued = YES;

    if (isResponsed == NO) {

        // do not implement imperialMenuViewWillClose, but still continued process
        continued = YES;

    } else {

        continued = [self.delegate imperialMenuViewWillClose:self];

        if (continued == NO) {

            // user cancel it
            NSLog(@"%@ [delegate(%@) %@] return NO", NSStringFromSelector(_cmd)
                  , NSStringFromClass([self.delegate class])
                  , NSStringFromSelector(sel));

        }
    }

    return continued;
}

- (void) invokeImperialMenuViewDidClose
{
    static NSObject *checked = nil;

    static BOOL isResponsed = NO;

    if (checked == nil) {

        checked = [[NSObject alloc] init];         // do once

        SEL sel = @selector(imperialMenuViewDidClose:);

        isResponsed = [_delegate respondsToSelector:sel];
    }

    if (isResponsed == NO) {

        // do not implement imperialMenuViewDidClose

    } else {

        [self.delegate imperialMenuViewDidClose:self];
    }
}

#pragma mark - draw
/*
 -(void)drawRect:(CGRect)rect {

 [super drawRect:rect];

 CGContextRef context = UIGraphicsGetCurrentContext();

 CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);

 CGContextSetLineWidth(context, 3.0f);

 CGContextMoveToPoint(context, kEXPAND_THRESHOLD_CENTER, 0);

 CGContextAddLineToPoint(context, kEXPAND_THRESHOLD_CENTER, [UIScreen mainScreen].bounds.size.height);

 CGContextStrokePath(context);


 CGContextMoveToPoint(context, kEXPAND_THRESHOLD_CENTER * (1.0f + kEXPAND_THRESHOLD_FACTOR), 0);

 CGContextAddLineToPoint(context, kEXPAND_THRESHOLD_CENTER * (1.0f + kEXPAND_THRESHOLD_FACTOR), [UIScreen mainScreen].bounds.size.height);

 CGContextStrokePath(context);

 CGContextMoveToPoint(context, kEXPAND_THRESHOLD_CENTER * (1.0f - kEXPAND_THRESHOLD_FACTOR), 0);

 CGContextAddLineToPoint(context, kEXPAND_THRESHOLD_CENTER * (1.0f + kEXPAND_THRESHOLD_FACTOR), [UIScreen mainScreen].bounds.size.height);

 CGContextStrokePath(context);

 }
 */

@end
