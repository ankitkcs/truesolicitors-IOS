//
//  HATransparentView.m
//  HATransparentView
//
//  Created by Heberti Almeida on 13/09/13.
//  Copyright (c) 2013 Heberti Almeida. All rights reserved.
//

#import "RKMTransView.h"
#import "UIImage+StackBlur.h"

#define kDefaultBackground [UIColor colorWithWhite:0.0 alpha:0.7];
#define ROUND_RADIUS 5

@interface RKMTransView ()

@property (nonatomic, assign) NSInteger statusBarStyle;

@end


@implementation RKMTransView

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.frame = [[UIScreen mainScreen] bounds];
        self.opaque = NO;
        self.backgroundColor = kDefaultBackground;
        self.hideCloseButton = NO;
        self.hideAlertView = NO;
        self.allowBlurView = NO;
    }
    return self;
}

#pragma mark - Open Transparent View

- (void)open
{
    // Get main window reference
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
        [close addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:close];
        
        switch (self.style)
        {
            case lightCloseButton:
            {
                [close setImage:[UIImage imageNamed:@"btn-close"] forState:UIControlStateNormal];
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
                break;
            }
            case darkCloseButton:
            {
                [close setImage:[UIImage imageNamed:@"btn-close-black"] forState:UIControlStateNormal];
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
                break;
            }
        }
    }
    
    if(!self.hideAlertView)
    {
        [self addRKAlertView];
    }
    
    // Animation
    CATransition *viewIn = [CATransition animation];
    [viewIn setDuration:0.4];
    [viewIn setType:kCATransitionReveal];
    [viewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [[self layer] addAnimation:viewIn forKey:kCATransitionReveal];
    
    [[[window subviews] objectAtIndex:0] addSubview:self];
}

//ranjit
-(void) addRKAlertView
{
    if(self.allowBlurView)
    {
        UIImage *blurImage = [[self screenshot] stackBlur:50];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.image = blurImage;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:imageView];
    }
    
    CGRect msgBackViewFrame = CGRectMake(0, 0, 297, 370);
    UIView *msgBackView = [[UIView alloc] initWithFrame:msgBackViewFrame];
    msgBackView.backgroundColor = [UIColor whiteColor];
    [self addSubview:msgBackView];
    
    CGRect msgTitleLabelFrame = CGRectMake(0, 0, 297,40);
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:msgTitleLabelFrame];
    [lblTitle setClipsToBounds:YES];
    lblTitle.textColor = [UIColor blackColor];
    lblTitle.font = [UIFont boldSystemFontOfSize:18];
    lblTitle.text = self.alertTitle;
    lblTitle.textAlignment = NSTextAlignmentCenter;
    [msgBackView addSubview:lblTitle];
    
    UIImage *image = self.alertImage;
    CGRect msgImageFrame = CGRectMake(msgTitleLabelFrame.size.width/2 - image.size.width/2,msgTitleLabelFrame.size.height + 15 , image.size.width, image.size.height);
    UIImageView *msgImageView = [[UIImageView alloc] initWithFrame:msgImageFrame];
    msgImageView.image = self.alertImage;
    [msgBackView addSubview:msgImageView];
    
    CGSize size = [self sizeForDynamicText:self.alertMessage];
    CGRect msgLabelFrame = CGRectMake(msgTitleLabelFrame.size.width/2 - size.width/2 ,msgImageFrame.origin.y + msgImageFrame.size.height + 15, size.width,size.height);
    UILabel *lblMessage = [[UILabel alloc] initWithFrame:msgLabelFrame];
    lblMessage.textColor = [UIColor blackColor];
    lblMessage.font = [UIFont systemFontOfSize:18];
    lblMessage.numberOfLines = 0;
    lblMessage.text = self.alertMessage;
    lblMessage.textAlignment = NSTextAlignmentCenter;
    [msgBackView addSubview:lblMessage];
    
    CGRect btnFrame = CGRectMake(0,320,297,50);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:btnFrame];
    [button setClipsToBounds:YES];
    [button setTitle:@"OK" forState:UIControlStateNormal];
    [button setBackgroundColor:Rgb2UIColor(7,146,23)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [button addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [msgBackView addSubview:button];

    [self addSubview:msgBackView];
    
    msgBackView.center = self.center;
    msgBackView.layer.cornerRadius = ROUND_RADIUS;
    [self setMaskTo:lblTitle byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight withRadius:ROUND_RADIUS];
    [self setMaskTo:button byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight withRadius:ROUND_RADIUS];
    
    msgBackView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:0.7].CGColor;
    msgBackView.layer.borderWidth = 1;
}

//Ranjit
-(CGSize) sizeForDynamicText:(NSString*) textString
{
    CGSize size;
    
    size = [textString sizeWithFont:[UIFont systemFontOfSize:18.0] constrainedToSize:CGSizeMake(250, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
//    if (OSVersionIsAtLeastiOS7)
//    {
//        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:18.0], NSFontAttributeName, nil];
//        CGRect frame = [textString boundingRectWithSize:CGSizeMake(297, 1000) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attributesDictionary context:nil];
//        size = frame.size;
//    }
//    else
//    {
//        size = [textString sizeWithFont:[UIFont systemFontOfSize:18.0] constrainedToSize:CGSizeMake(220, 5000) lineBreakMode:NSLineBreakByWordWrapping];
//    }
    return size;
}

-(void) setMaskTo:(UIView*)view byRoundingCorners:(UIRectCorner)corners withRadius:(CGFloat)roundRadius
{
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(roundRadius, roundRadius)];
    
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    view.layer.mask = shape;
}

- (UIImage *)screenshot
{
    CGSize imageSize = CGSizeZero;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        imageSize = [UIScreen mainScreen].bounds.size;
    } else {
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    }
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        } else if (orientation == UIInterfaceOrientationLandscapeRight) {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        } else {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
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
    
    [self.delegate RKMTransViewDidClosed];
}

@end