//
//  LetterReadViewController.h
//  TrueClaim
//
//  Created by krish on 7/28/14.
//  Copyright (c) 2014 KCSPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DocumentDetail.h"

@interface LetterReadViewController : UIViewController
{
    
}

@property(nonatomic,retain) DocumentDetail *selDocDetail;
@property (nonatomic,strong) WebApiRequest *webApi;
@property (strong,nonatomic) LinkToClaim *selClaim;

@property(nonatomic,weak) IBOutlet UIWebView *webView;

@property(nonatomic,weak) IBOutlet UITextView *msgTextView;
- (IBAction)btnNextTapped:(id)sender;

@end
