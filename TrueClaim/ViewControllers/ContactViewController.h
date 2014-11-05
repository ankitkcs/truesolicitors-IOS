//
//  ContactViewController.h
//  TrueClaim
//
//  Created by krish on 8/22/14.
//  Copyright (c) 2014 KCSPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>


@interface ContactViewController : UIViewController
<MFMailComposeViewControllerDelegate,
MFMessageComposeViewControllerDelegate,
UINavigationControllerDelegate
>

@property (weak, nonatomic) IBOutlet UIButton *btnCallTrue;
@property (weak, nonatomic) IBOutlet UIButton *btnNewMessage;

@property (weak, nonatomic) IBOutlet UIView *detailsBackView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIWebView *webview;

-(IBAction)callTrueClick:(id)sender;
-(IBAction)newMessageClick:(id)sender;


@end
