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

@interface LinkClaimViewController : UIViewController <RKMTransViewDelegate,UITextFieldDelegate>
{
    UIDatePicker *datePicker;
    UIActionSheet *actionSheet;
}
@property (weak, nonatomic) IBOutlet UITextField *txtClaimNo;
@property (weak, nonatomic) IBOutlet UITextField *txtBirthDate;
@property (weak,nonatomic) IBOutlet UIView *inputBackView;
@property (weak,nonatomic) IBOutlet UILabel *lblHead;
@property (nonatomic,retain) WebApiRequest *webApi;
@property (strong, nonatomic) RKMTransView *transparentView;

@property (nonatomic, assign) BOOL isLinkAdded;
@end
