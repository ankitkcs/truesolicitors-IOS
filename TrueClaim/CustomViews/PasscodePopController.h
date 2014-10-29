//
//  PasscodePopController.h
//  TrueClaim
//
//  Created by krish on 10/10/14.
//  Copyright (c) 2014 KCSPL. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PassCodePopDelegate <NSObject>
-(void) PopUpCloseWithPassText: (NSString*)passcode;
@end

@interface PasscodePopController : UIView <UITextFieldDelegate>

{
    int charCounter;
    NSString *passcode;
    NSString *enteredPasscode;
    NSString *confirmPasscode;
    
    BOOL isNewPass;
    BOOL isConfirmPass;
}

@property(nonatomic,readwrite)BOOL chk;

@property (strong, nonatomic) UILabel *l1;
@property (strong, nonatomic) UILabel *l2;
@property (strong, nonatomic) UILabel *l3;
@property (strong, nonatomic) UILabel *l4;

@property (weak,nonatomic) UITextField *hiddenText;

@property (nonatomic, assign) BOOL hideCloseButton;
@property (nonatomic, strong) NSString *passcodeText;


@property(nonatomic,weak) id <PassCodePopDelegate> delegate;

-(void)Open;
-(void)close;


@end
