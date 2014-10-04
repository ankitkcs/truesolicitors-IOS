//
//  CustomAccessoryView.h
//  MyCustomKeyBoardiPhone
//
//  Created by KCS on 9/25/12.
//  Copyright (c) 2012 KCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomAccessoryViewDelegate.h"
@interface CustomAccessoryView : UIViewController
{
    IBOutlet UIBarButtonItem *btnNext;  // for next button
    IBOutlet UIBarButtonItem *btnPrevious;  // for previous button
    IBOutlet UIBarButtonItem *btnDone;  // for done button
    UIControl <UITextInput> *_txtTarget;    
    UIViewController<CustomAccessoryViewDelegate> *delegate;
}

@property (nonatomic, strong) UIBarButtonItem *btnNext;
@property (nonatomic, strong) UIBarButtonItem *btnPrevious;
@property (nonatomic, strong) UIBarButtonItem *btnDone;
@property (nonatomic, strong) UIControl <UITextInput> *txtTarget;
@property (nonatomic, strong) UIViewController<CustomAccessoryViewDelegate> *delegate;
-(IBAction)btnNextCliked:(id)sender;
-(IBAction)btnPreviousCliked:(id)sender;
-(IBAction)btnDoneCliked:(id)sender;
@end
