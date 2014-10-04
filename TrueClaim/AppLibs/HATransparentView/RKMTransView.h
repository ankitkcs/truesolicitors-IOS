//
//  HATransparentView.h
//  HATransparentView
//
//  Created by Heberti Almeida on 13/09/13.
//  Copyright (c) 2013 Heberti Almeida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


typedef NS_ENUM(NSInteger, CloseBtnStyle)
{
    lightCloseButton = 0,
    darkCloseButton,
};

@protocol RKMTransViewDelegate <NSObject>
@optional
- (void)RKMTransViewDidClosed;

@end

@interface RKMTransView : UIView

@property (nonatomic, assign) CloseBtnStyle style;

@property (nonatomic, assign) id<RKMTransViewDelegate> delegate;

@property (nonatomic, assign) BOOL hideCloseButton;
@property (nonatomic, assign) BOOL hideAlertView;
@property (nonatomic,assign) BOOL allowBlurView;


// ranjit

@property (nonatomic, strong) UIImage *blurBackImage;
@property (nonatomic, strong) NSString *alertTitle;
@property (nonatomic, strong) UIImage *alertImage;
@property (nonatomic, strong) NSString *alertMessage;


- (void)open;
- (void)close;

@end