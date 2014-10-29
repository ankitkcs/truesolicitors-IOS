//
//  KCSViewController.h
//  TrueClaim
//
//  Created by krish on 7/19/14.
//  Copyright (c) 2014 KCSPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDPageControl.h"
#import "WebApiRequest.h"

//@class DDPageControl ;

@interface IntroViewController : UIViewController <UIScrollViewDelegate>
{
    UIImageView *pageImageView;
    CGRect pageFrame;
    UIColor *color;
    
    NSArray *introImages;
    NSArray *introText;
}

@property (nonatomic,retain) IBOutlet UIView  *introBackView;
@property (nonatomic,retain) IBOutlet UIView *scrollerBackView;
@property (nonatomic,retain) IBOutlet UIView *pagerBackView;

@property (nonatomic,retain) IBOutlet UIScrollView  *scrollView;
@property (nonatomic,retain) IBOutlet UILabel *introLabel;
@property (nonatomic,retain) IBOutlet UIButton *btnGetStart;

@property (nonatomic,retain) DDPageControl *pageControl;
@property (nonatomic,retain) WebApiRequest *webApiRequest;

- (IBAction)getStartedTapped:(id)sender;

@end
