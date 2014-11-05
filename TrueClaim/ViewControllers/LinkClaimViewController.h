//
//  LinkClaimViewController.h
//  TrueClaim
//
//  Created by krish on 7/21/14.
//  Copyright (c) 2014 KCSPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RKMTransView.h"
#import "MyDatabaseManager.h"
#import "WebApiRequest.h"

@class WTReTextField;

@interface LinkClaimViewController : UIViewController <RKMTransViewDelegate,UITextFieldDelegate>
{
    UIDatePicker *datePicker;
    UIActionSheet *actionSheet;
}
@property (weak, nonatomic) IBOutlet UITextField *txtClaimNo;
@property (weak, nonatomic) IBOutlet WTReTextField *txtBirthDate;

@property (weak,nonatomic) IBOutlet UIView *navBarBackView;
@property (weak,nonatomic) IBOutlet UIView *navBarBackButton;
@property (weak,nonatomic) IBOutlet UIView *navBarSubmitButton;

@property (weak,nonatomic) IBOutlet UIView *inputBackView;
@property (weak,nonatomic) IBOutlet UIView *headBackView;

@property (weak,nonatomic) IBOutlet UILabel *lblHeadTitle;
@property (weak,nonatomic) IBOutlet UILabel *lblHead;

@property (nonatomic,retain) WebApiRequest *webApi;
@property (strong, nonatomic) RKMTransView *transparentView;

@property (nonatomic, assign) BOOL isLinkAdded;

@property (nonatomic, strong) NSString *showViewFor;

-(IBAction)btnNavBackClick:(id)sender;
-(IBAction)btnNavSubmitClick:(id)sender;


@end
