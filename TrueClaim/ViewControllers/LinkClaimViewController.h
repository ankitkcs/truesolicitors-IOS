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

@interface LinkClaimViewController : UIViewController <RKMTransViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtClaimNo;
@property (weak, nonatomic) IBOutlet UITextField *txtBirthDate;
@property (weak,nonatomic) IBOutlet UIView *inputBackView;
@property (weak,nonatomic) IBOutlet UILabel *lblHead;



@property (strong, nonatomic) RKMTransView *transparentView;

@property (nonatomic, assign) BOOL isLinkAdded;
@end
