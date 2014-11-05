//
//  ContactViewController.m
//  TrueClaim
//
//  Created by krish on 8/22/14.
//  Copyright (c) 2014 KCSPL. All rights reserved.
//

#import "ContactViewController.h"

@interface ContactViewController () <UIWebViewDelegate>

@end

@implementation ContactViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"CONTACT US";
    
    self.detailsBackView.backgroundColor = [UIColor clearColor];
    
    
    if(!IS_IPHONE_5)
    {
        self.scrollview.frame = CGRectMake(0, 100, self.scrollview.frame.size.width, self.scrollview.frame.size.height);
    }
    
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"contactInfo" ofType:@"html"]isDirectory:NO]]];
    self.webview.delegate = self;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    CGRect frame = webView.frame;
    frame.size.height = 5.0f;
    webView.frame = frame;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGSize mWebViewTextSize = [webView sizeThatFits:CGSizeZero];  // Pass about any size
    CGRect mWebViewFrame = webView.frame;
    mWebViewFrame.size.height = mWebViewTextSize.height;
    webView.frame = mWebViewFrame;
    
    self.scrollview.contentSize = CGSizeMake(320, mWebViewTextSize.height + 250);
    
    //Disable bouncing in webview
    for (id subview in webView.subviews)
    {
        if ([[subview class] isSubclassOfClass: [UIScrollView class]])
        {
            [subview setBounces:NO];
        }
    }
}

-(IBAction)callTrueClick:(id)sender
{
    NSString *deviceType = [UIDevice currentDevice].model;
    
    if([deviceType isEqualToString:@"iPhone"])
    {
        NSString *callNumber = @"08448547000";
        //NSString *phoneNumber = [@"telprompt://" stringByAppendingString:callNumber];
        NSString *phoneNumber = [@"tel://" stringByAppendingString:callNumber];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }
    else
    {
        UIAlertView *AV=[[UIAlertView alloc]initWithTitle:@"Message" message:@"Calling is not Available" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [AV show];
    }

}
-(IBAction)newMessageClick:(id)sender
{
    MFMessageComposeViewController *messageComposer =[[MFMessageComposeViewController alloc] init];
    
    if([MFMessageComposeViewController canSendText])
	{
        NSString *message;
        
        message = @" Message from TRUE";
        
        NSString *msgNumber = @"08448547000";
        
        messageComposer.recipients = [NSArray arrayWithObjects:msgNumber,nil];
        [messageComposer setBody:message];
        messageComposer.messageComposeDelegate = self;
        [self presentViewController:messageComposer animated:YES completion:nil];
	}

}

- (void)messageComposeViewController:
(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    switch (result)
    {
        case MessageComposeResultCancelled:
            NSLog(@"Cancelled");
            break;
        case MessageComposeResultFailed:
            NSLog(@"Failed");
            break;
        case MessageComposeResultSent:
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
