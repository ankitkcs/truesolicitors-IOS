//
//  WriteMessageViewController.h
//  TrueClaim
//
//  Created by krish on 7/25/14.
//  Copyright (c) 2014 KCSPL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WriteMessageViewController : UIViewController

@property (nonatomic,strong) WebApiRequest *webApi;
@property (strong,nonatomic) LinkToClaim *selClaim;

@property (nonatomic,weak) IBOutlet UITextView *msgTextView;
@property (nonatomic,weak) IBOutlet UILabel *lblClaimHead;

-(IBAction)btnCancelClick:(id)sender;
-(IBAction)btnSendClick:(id)sender;

@end
