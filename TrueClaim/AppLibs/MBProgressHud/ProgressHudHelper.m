//
//  ProgressHudHelper.m
//  Cauldron
//
//  Created by Logic express on 20/03/14.
//  Copyright (c) 2014 Logic express. All rights reserved.
//

#import "ProgressHudHelper.h"

@implementation ProgressHudHelper

+(void)showLoadingHudWithText:(NSString*)loadingMsg isAutoHide:(BOOL)autoHide
{
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.labelText = loadingMsg;
    hud.detailsLabelText = @"";
    hud.alpha = 1.0;
    hud.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.2];
    hud.color = [UIColor clearColor];
    
    if(autoHide)
    {
        [self performSelector:@selector(hideLoadingHudForDelay) withObject:nil afterDelay:30];
        //[hud hide:YES afterDelay:30];
    }
}

+(void)showLoadingHudWithText:(NSString*)loadingMsg
{
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.labelText = loadingMsg;
    hud.alpha = 1.0;
    hud.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
    hud.color = [UIColor clearColor];
}

+(void)hideLoadingHud
{
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    [MBProgressHUD hideHUDForView:window animated:YES];
}

+(void)hideLoadingHudForDelay
{
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    [MBProgressHUD hideHUDForView:window animated:YES];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Connection Time Out" message:@"Plese check your Connection " delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [av show];
}

// ================================= Advanced Hud =================================

+(void) showAdvanceHudWithText:(NSString*)loadingMsg
{
    MBHUDView *hudView = [[MBHUDView alloc] init];
    hudView.hudType = MBAlertViewHUDTypeActivityIndicator;
    hudView.backgroundColor = [UIColor clearColor];
    hudView.bodyText = loadingMsg;
    hudView.bodyFont = [UIFont fontWithName:FN_ROBOTO_REGULAR size:24];
    hudView.itemColor = Rgb2UIColor(254, 203, 56);
    //[hudView setHudHideDelay:10.0];
    //[hudView addToDisplayQueue];
    [hudView show];
}

+(void) dissmissAdvanceHud
{
    [MBHUDView dismissCurrentHUD];
}

@end
