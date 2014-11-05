//
//  AboutUsViewController.h
//  TrueClaim
//
//  Created by krish on 7/29/14.
//  Copyright (c) 2014 KCSPL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutUsViewController : UIViewController
@property (nonatomic,strong) NSString *displayHtmlfile;
@property (nonatomic,weak) IBOutlet UIWebView *webview;


@end
