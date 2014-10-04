//
//  FaqDetailsViewController.h
//  TrueClaim
//
//  Created by krish on 8/22/14.
//  Copyright (c) 2014 KCSPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myDatabaseManager.h"

@interface FaqDetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *headerBackView;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;

@property (weak, nonatomic) IBOutlet UITextView *txtFaqDetail;

@property (strong, nonatomic) FAQDetail *selFaqDetail;

- (IBAction)goBackToFAQList:(id)sender;

@end
