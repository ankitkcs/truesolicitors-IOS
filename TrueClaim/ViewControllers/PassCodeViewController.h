//
//  TempPassCodeVC.h
//  TrueClaim
//
//  Created by Krish on 22/07/14.
//  Copyright (c) 2014 KCSPL. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "RKPOPViewController.h"
#import "RKMTransView.h"
//#import "RKPopUpAlertView.h"

@interface PassCodeViewController : UIViewController<UITextFieldDelegate,RKMTransViewDelegate>
{
    int charCounter;
    NSString *passcode;
    NSString *enterPasscode;
    NSString *confirmPasscode;
    
    BOOL isNewPass;
    BOOL isConfirmPass;
}

@property(nonatomic,readwrite)BOOL chk;

@property (strong, nonatomic) IBOutlet UILabel *l1;
@property (strong, nonatomic) IBOutlet UILabel *l2;
@property (strong, nonatomic) IBOutlet UILabel *l3;
@property (strong, nonatomic) IBOutlet UILabel *l4;

@property(weak,nonatomic)IBOutlet UILabel *passMessage;
@property (weak,nonatomic) IBOutlet UITextField *hiddenText;

@property (weak,nonatomic) IBOutlet UIView *fakeNavBarView;
@property (weak,nonatomic) IBOutlet UIView *passInputBackView;
@property (weak,nonatomic) IBOutlet UIView *rememberBackView;

@property (strong,nonatomic) RKMTransView *transparentView;

- (IBAction)btnCancel:(id)sender;
- (IBAction)btnSave:(id)sender;

@end
