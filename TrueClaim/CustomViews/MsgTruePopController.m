//
//  PasscodePopController.m
//  TrueClaim
//
//  Created by krish on 10/10/14.
//  Copyright (c) 2014 KCSPL. All rights reserved.
//

#import "MsgTruePopController.h"

#define APP_HEIGHT 568.0f
#define APP_WIDTH 320.0f

@interface MsgTruePopController ()
@property (nonatomic, assign) NSInteger statusBarStyle;
@end

@implementation MsgTruePopController

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.frame = [[UIScreen mainScreen] bounds];
        self.opaque = NO;
        self.backgroundColor = [UIColor whiteColor];
        self.hideCloseButton = YES;
        self.MessageText = @"";
    }
    return self;
}

-(void) Open
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!window)
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    
    // Get current statusBarStyle
    self.statusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
    
    // Close button
    if (!self.hideCloseButton)
    {
        UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
        close.frame = CGRectMake(self.frame.size.width - 60, 26, 60, 30);
        [close setImage:[UIImage imageNamed:@"btn-close"] forState:UIControlStateNormal];
        [close addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:close];
    }
    
    // add your custom alert here
    [self customMessageView];
    
    // Animation
    CATransition *viewIn = [CATransition animation];
    [viewIn setDuration:0.4];
    [viewIn setType:kCATransitionReveal];
    [viewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [[self layer] addAnimation:viewIn forKey:kCATransitionReveal];
    
    [[[window subviews] objectAtIndex:0] addSubview:self];
    
    [self.msgTextView becomeFirstResponder];
}

#pragma mark - Close Transparent View

- (void)close
{
    // Animation
    CATransition *viewOut = [CATransition animation];
    [viewOut setDuration:0.3];
    [viewOut setType:kCATransitionFade];
    [viewOut setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[self.superview layer] addAnimation:viewOut forKey:kCATransitionFade];
    
    [[UIApplication sharedApplication] setStatusBarStyle:self.statusBarStyle];
    [self removeFromSuperview];
}


-(void) customMessageView
{
    UINib *nib = [UINib nibWithNibName:@"MsgTruePopView" bundle:nil];
    NSArray *nibArray = [nib instantiateWithOwner:self options:nil];
    UIView *popView = [nibArray objectAtIndex: 0];
    
    popView.backgroundColor = [UIColor clearColor];
    popView.frame = CGRectMake(0, 0, popView.frame.size.width, popView.frame.size.height);
    
    UIButton *cancelButton = (UIButton*)[popView viewWithTag:11];
    [cancelButton addTarget:self action:@selector(btnCancelClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *doneButton = (UIButton*)[popView viewWithTag:12];
    [doneButton addTarget:self action:@selector(btnDoneClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.msgTextView = (UITextView*)[popView viewWithTag:13];
    
    [self addSubview:popView];
}

-(void) btnCancelClick
{
    [self close];
    [self.delegate PopUpCancelWithMessageText:@""];
}

-(void) btnDoneClick
{
    [self close];
    [self.delegate PopUpDoneWithMessageText:self.msgTextView.text];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
