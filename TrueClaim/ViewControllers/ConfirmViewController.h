//
//  ConfirmViewController.h
//  TrueClaim
//
//  Created by krish on 7/28/14.
//  Copyright (c) 2014 KCSPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RKMTransView.h"

@interface ConfirmViewController : UIViewController

@property(nonatomic,retain) DocumentDetail *selDocDetail;
@property (nonatomic,strong) WebApiRequest *webApi;
@property (strong,nonatomic) LinkToClaim *selClaim;
@property(nonatomic,strong) NSString *authType;
@property(nonatomic,strong) NSString *optionMsgText;
@property(nonatomic,assign) BOOL isAutorised;
@property(nonatomic,assign) BOOL isMessage;

@property(nonatomic, weak) IBOutlet UILabel *lblPrompt;
@property(nonatomic,retain) RKMTransView *transparentView;

- (IBAction)btnConfirmTapped:(id)sender;

@end
