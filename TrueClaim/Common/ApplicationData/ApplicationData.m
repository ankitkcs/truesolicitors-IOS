//
//  ApplicationData.m
//  CoreTalk
//
//  Created by Krish on 20/03/13.
//  Copyright (c) 2013 KCS. All rights reserved.
//

#import "ApplicationData.h"

#import <QuartzCore/QuartzCore.h>
#include <CoreFoundation/CFString.h>
#include <CoreFoundation/CFBase.h>


@implementation ApplicationData

@synthesize logoImage;
@synthesize webserviceDateTimeFormatter;
@synthesize webserviceDateTimeFormatter_new;
@synthesize webserviceDateFormatter;
@synthesize webserviceDateFormatter_new;
@synthesize displayDateTimeFormatter;
@synthesize displayDateFormatter;
@synthesize reachability;
@synthesize serverDateTime;
@synthesize serverDateTimeProduct;
@synthesize serverDateTimeCategory;
@synthesize serverDateTimeNotification;
@synthesize isFirstTime;
@synthesize mobileNo;
@synthesize isGetGeneralStatusSummaryWithNotificationFirstTime;
@synthesize deviceOSVersion;
@synthesize deviceModel;
@synthesize deviceUDID;
@synthesize deviceUUID;
@synthesize alertView;
@synthesize appLocal;
@synthesize priceNumberFormatter;
@synthesize cartCount;
@synthesize isNotificationClicked;
@synthesize isDisply_PassCodeScreen;
@synthesize isPasscodeSaved;
@synthesize navigateFromView;
@synthesize tc_auth_token;
@synthesize selectedClaim;
@synthesize selectedDocDetail;
@synthesize isReloadMyFolderData;


+ (ApplicationData *)sharedInstance {
    
    static ApplicationData *sharedInstance;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
	if(self = [super init])
	{
        [self initialize];
        
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
		reachability = [Reachability reachabilityWithHostName:HOST_NAME];
		[reachability startNotifier];
		currentNetworkStatus = ReachableViaWiFi;
	}
	return self;
}

- (void)initialize
{
    logoImage = nil;
    self.isNotificationEnable = YES;
    webserviceDateTimeFormatter_new = [[NSDateFormatter alloc] init];
    webserviceDateFormatter = [[NSDateFormatter alloc] init];
    displayDateTimeFormatter = [[NSDateFormatter alloc] init];
    displayDateFormatter = [[NSDateFormatter alloc] init];
    [webserviceDateTimeFormatter_new setDateFormat:DATETIME_FORMAT_WS];
    [webserviceDateFormatter setDateFormat:DATE_FORMAT_WS];
    
    [displayDateTimeFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [displayDateTimeFormatter setDateFormat:DATETIME_FORMAT_DISPLAY];
    [displayDateFormatter setDateFormat:DATE_FORMAT_DISPLAY];
    
    [displayDateTimeFormatter setAMSymbol:@"am"];
    [displayDateTimeFormatter setPMSymbol:@"pm"];
    
    self.serverDateTime = [[NSDate alloc] init];
    self.serverDateTimeProduct = [[NSDate alloc] init];
    self.serverDateTimeCategory = [[NSDate alloc] init];
    self.serverDateTimeNotification = [[NSDate alloc] init];
    
    //NSLog(@"Application version: %@",self.appVersion);
    self.deviceOSVersion = [[UIDevice currentDevice] systemVersion];
    self.deviceModel = [UIDevice currentDevice].model;
    self.deviceUUID = [ApplicationData offlineObjectForKey:DEVICE_UUID];
    self.deviceUDID = @"";
    self.appLocal = [[NSLocale alloc] initWithLocaleIdentifier:@"en_IN"];
    
    
    self.priceNumberFormatter = [[NSNumberFormatter alloc] init];
    self.priceNumberFormatter.locale = self.appLocal;
    NSNumberFormatterStyle formatStyle = NSNumberFormatterCurrencyStyle;
    NSNumberFormatterPadPosition formatPadding = NSNumberFormatterPadAfterPrefix;
    [self.priceNumberFormatter setPaddingPosition:formatPadding];
    [self.priceNumberFormatter setNumberStyle:formatStyle];
    //[self.priceNumberFormatter setCurrencyCode:@"INR"];
    self.priceNumberFormatter.minimumFractionDigits = 2;
    self.priceNumberFormatter.maximumFractionDigits = 2;
}

#pragma mark -------------------------------
#pragma mark CustomizeView Navigation
#pragma mark -------------------------------

+(void)customizeNavigationBarWithImage:(UIImage*)customImage  OrColors:(NSArray*)customColors
{
    if(customImage)
    {
        [[UINavigationBar appearance] setBackgroundImage:customImage forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        UIImage *image = [self createGrdientImageWithColors:customColors];
        [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
}

+(UIView*)customizeNavigationTitle:(NSString*)customTitle andCustomFont:(UIFont*)customFont andCustomColor:(UIColor*)customColor
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    myLabel.backgroundColor = [UIColor clearColor];
    myLabel.text = customTitle;
    myLabel.textAlignment = UITextAlignmentCenter;
    myLabel.font = customFont;
    myLabel.textColor = customColor;
    [view addSubview:myLabel];
    return view;
}

+(UIBarButtonItem*)navigationBarHiddenBackButton
{
    UIButton *btnHiddenBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnHiddenBack setFrame:CGRectMake(0.f,0.f,0.f,0.f)];
    [btnHiddenBack setCenter:CGPointMake(0.f,0.f)];
    [btnHiddenBack setClipsToBounds:YES];
    [btnHiddenBack setImage:[UIImage imageNamed:nil] forState:UIControlStateNormal];
    [btnHiddenBack setImage:[UIImage imageNamed:nil] forState:UIControlStateHighlighted];
    [btnHiddenBack setTitle:@"" forState:UIControlStateNormal];
    [btnHiddenBack.titleLabel setFont:[UIFont fontWithName:nil size:0.f]];
    [btnHiddenBack setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [btnHiddenBack setTitleColor:[UIColor clearColor] forState:UIControlStateHighlighted];

    UIBarButtonItem *hiddenBackBtn = [[UIBarButtonItem alloc] initWithCustomView:btnHiddenBack];
    return hiddenBackBtn;
}

+(void)changeNavigationBackImage
{
    float systemVersion=[[[UIDevice currentDevice]systemVersion]floatValue];
    
    if(systemVersion >=7.0f)
    {
        //NSLog(@"ver_%f",systemVersion);
        //[[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
        //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
        //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        UIImage *gradientImage44 = [[UIImage imageNamed:@"headertop"]
                                    resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        // Set the background image for *all* UINavigationBars
        [[UINavigationBar appearance] setBackgroundImage:gradientImage44 forBarMetrics:UIBarMetricsDefault];
    }
    else if (systemVersion >= 5.0f && systemVersion <= 6.0f)
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
        UIImage *gradientImage44 = [[UIImage imageNamed:@"headertop"]
                                    resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        // Set the background image for *all* UINavigationBars
        [[UINavigationBar appearance] setBackgroundImage:gradientImage44 forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithRed:99.0/255.0 green:20.0/255.0 blue:60.0/255.0 alpha:1.0]];
    }
    else
    {
        //NSLog(@"ver_%f",systemVersion);
        UIImage *gradientImage44 = [[UIImage imageNamed:@"headertop"]
                                    resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        // Set the background image for *all* UINavigationBars
        [[UINavigationBar appearance] setBackgroundImage:gradientImage44 forBarMetrics:UIBarMetricsDefault];
    }
}

#pragma mark -------------------------------
#pragma mark Custom And Gradient Image
#pragma mark -------------------------------

+ (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

+(UIImage *)createGrdientImageWithColors : (NSArray*)gradientColors
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    view.backgroundColor = [UIColor blueColor];
    
    //aaply gradient Colors
    CAGradientLayer *vgradient = [CAGradientLayer layer];
    vgradient.frame = view.bounds;
    vgradient.colors = gradientColors;
    [view.layer insertSublayer:vgradient atIndex:0];
    
    //change view to image
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage*) resizeImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark -------------------------------
#pragma mark Customize Button
#pragma mark -------------------------------

+(UIButton*)iconButtonWithImage:(UIImage*)normalImage highlighImage:(UIImage*)hoverImage
                                selectImage :(UIImage*)selectedImage
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0.f,0.f,44.f,44.f)];
    [button setCenter:CGPointMake(05.f,0.5f)];
    [button setClipsToBounds:YES];
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:hoverImage forState:UIControlStateHighlighted];
    [button setTitle:@"" forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0.f,0.f,0.f,0.f)];
    return button;
}

+(UIButton*)customButtonWithBGImageOrColor:(UIColor*)bgColor andImage:(NSDictionary*)images withTitleText:(NSString*)buttonTitle andCustomFont:(UIFont*)customFont andTitleColors:(NSDictionary*)tcolors titleAlign:(NSString*)align andBtnSize:(CGRect)btnFrame
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:btnFrame];
    //[button setCenter:CGPointMake(0.f,0.f)];
    [button setClipsToBounds:YES];
    
    if(images)
    {
        UIImage *normalBGImage = [images valueForKey:@"normalBGImage"];
        UIImage *highlightBGImage = [images valueForKey:@"highlightBGImage"];
        UIImage *selectedBGImage = [images valueForKey:@"selectedBGImage"];
        [button setImage:normalBGImage forState:UIControlStateNormal];
        [button setImage:highlightBGImage forState:UIControlStateHighlighted];
        [button setImage:selectedBGImage forState:UIControlStateSelected];
    }
    else
    {
        [button setBackgroundColor:bgColor];
    }
    
    UIColor *normalTitleColor = [tcolors valueForKey:@"normalTitleColor"];
    UIColor *highlightTitleColor = [tcolors valueForKey:@"highlightTitleColor"];
    UIColor *selectedTitleColor = [tcolors valueForKey:@"selectedTitleColor"];
    [button setTitleColor:normalTitleColor forState:UIControlStateNormal];
    [button setTitleColor:highlightTitleColor forState:UIControlStateHighlighted];
    [button setTitleColor:selectedTitleColor forState:UIControlStateSelected];
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    [button.titleLabel setFont:customFont];
    
    if([align isEqualToString:@"Left"])
    {
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0.f,10.f,0.f,0.f)];
    }
    else if([align isEqualToString:@"Right"])
    {
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0.f,10.f,0.f,10.f)];
    }
    else
    {
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0.f,0.f,0.f,0.f)];
    }
    return button;
}

+(UIButton*)customButtonWithIconAndTitle:(NSString*)buttonTitle icon:(UIImage*)iconImage iconAlign:(NSString*)align bgColor:(UIColor*)color titleColor:(UIColor*)tcolor titleFont:(UIFont*)font buttonSize:(CGRect)btnFrame
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:btnFrame];
    [button setCenter:CGPointMake(05.f,0.5f)];
    [button setClipsToBounds:YES];
    [button setImage:iconImage forState:UIControlStateNormal];
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    [button setBackgroundColor:color];
    [button setTitleColor:tcolor forState:UIControlStateNormal];
    [button.titleLabel setFont:font];
    
    CGFloat leftTitlePad = 10.0f;
    CGFloat rightTitlePad = iconImage.size.width + 10.0f;
    CGFloat imageTitleGap;
    
    if([self sharedInstance].isiOS7orPlus)
    {
        imageTitleGap = -15.0f;
    }
    else
    {
        imageTitleGap = 5.0f;
    }
    
    CGFloat rightImagePad = button.frame.size.width - rightTitlePad;
    
    if([align isEqualToString:@"Left"])
    {
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0.f,leftTitlePad,0.f,0.f)];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0.f,imageTitleGap,0.f,0.f)];
    }
    else if([align isEqualToString:@"Right"])
    {
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0.f,0.f,0.f,rightTitlePad)];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0.f,rightImagePad,0.f,imageTitleGap)];
        
        //[button setTitleEdgeInsets:UIEdgeInsetsMake(0.f,0.f,0.f,50)];
        //[button setImageEdgeInsets:UIEdgeInsetsMake(0.f,150,0.f,-10.f)];
    }
    return button;
}

+(UIButton*)customBackNavButtonWithTite:(NSString*)buttonTitle icon:(UIImage*)iconImage bgColor:(UIColor*)color titleColor:(UIColor*)tcolor titleFont:(UIFont*)font buttonSize:(CGRect)btnFrame
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:btnFrame];
   // [button setCenter:CGPointMake(05.f,0.5f)];
    [button setClipsToBounds:YES];
    [button setImage:iconImage forState:UIControlStateNormal];
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    [button setBackgroundColor:color];
    [button setTitleColor:tcolor forState:UIControlStateNormal];
    [button.titleLabel setFont:font];
    
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0.f,5.0f,0.f,0.f)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0.f,0.0f,0.f,0.f)];
    return button;
}


#pragma mark -------------------------------
#pragma mark Date Formatting
#pragma mark -------------------------------

+(NSString *) getStringFromDate:(NSDate*)myDate inFormat:(NSString*)formatString WithAM:(BOOL)isAM
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:formatString];
    
    if(isAM)
    {
        [formatter setAMSymbol:@"AM"];
        [formatter setPMSymbol:@"PM"];
    }
    else
    {
        [formatter setAMSymbol:@"am"];
        [formatter setPMSymbol:@"am"];
    }
    
    NSString *strDate = [formatter stringFromDate:myDate];
    //NSLog(@"Selected Date  : %@",strDate);
    return strDate;
}

+(NSDate *) getDateFromString:(NSString*)myDateString withFormat:(NSString*)formatString
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:formatString];
    NSDate *date = [dateFormat dateFromString:myDateString];
    return date;
}

+(NSDate *) getPreviuosDatebyBackDay:(int)numOfBackDay
{
    //A day is 86400 seconds long
    
    NSDate *backDate = [NSDate dateWithTimeIntervalSinceNow:-84000*numOfBackDay];
    return backDate;
}

+(NSDate *) getFurthurDatebyNextDay:(int)numONextDay
{
    NSDate *furthurDate = [NSDate dateWithTimeIntervalSinceNow:+84000*numONextDay];
    return furthurDate;
}


//+ (void) syncUserDefaults
//{
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}


#pragma mark ------------------------------------
#pragma mark String Formatting
#pragma mark -------------------------------

+ (NSArray *) getCommaSeparatedValues:(NSString *)string {
    
    NSArray *valuesArray = [string componentsSeparatedByString:@","];
    return valuesArray;
}

+ (NSArray *) getSeparatedValuesFromString:(NSString *)string andSeparator:(NSString *)seperator
{
    
    NSArray *valuesArray = [string componentsSeparatedByString:seperator];
    return valuesArray;
}

+ (BOOL) allowedCharacter:(NSString*)validCharacter inRange:(NSRange)range withReplaceString:(NSString *)string ForTextField:(UITextField*)textField andLength:(int)strLen
{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString: validCharacter] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    NSUInteger newLength = (textField.text.length - range.length) + string.length;
    
    if(newLength <= strLen)
    {
        return [string isEqualToString:filtered];
    }
    
    return NO;
}

+(NSString *) autoToZeroForTextField :(UITextField*)textField andString:(NSString*)string
{
    if (![string isEqualToString:@""] && [textField.text intValue] == 0)
    {
        return @"1";
    }
    else if ([string isEqualToString:@""] && textField.text.length==1)
    {
        return @"00";
    }
    
    return nil;
}

#pragma mark ------------------------------------
#pragma mark UIAlertView Method
#pragma mark -------------------------------

- (void)showAlert:(NSString *)messageText andTag:(NSInteger)tag
{
	alertView = [[UIAlertView alloc] initWithTitle:APP_TITLE
                                           message:messageText
												   delegate:self
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
    
	[alertView setContentMode:UIViewContentModeScaleAspectFit];
	[alertView setTag:tag];
	[alertView show];
    
}

- (void)showAlert:(NSString *)messageText WithTitle:(NSString *)title Tag:(NSInteger)tag alertDelegate:(id)delegate andIsCancelButtonNeeded:(BOOL)isCancelButtonNeeded
{
    if(!isCancelButtonNeeded)
    {
        alertView = [[UIAlertView alloc] initWithTitle:title
                                                 message:messageText
                                                delegate:delegate    cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    else
    {
        alertView = [[UIAlertView alloc] initWithTitle:title
                                                 message:messageText
                                                delegate:delegate    cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel",nil];
    }
    [alertView setTag:tag];
    [alertView show];
}

#pragma mark ------------------------------------
#pragma mark Email Address validity
#pragma mark -------------------------------

+ (BOOL)checkValidStringLengh:(NSString *)string
{
    @try
    {
        if (!([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0))
        {
            return NO;
        }
        return YES;
    }
    @catch (NSException *exception)
    {
        // throws exception
    }

}

+ (BOOL)checkMobileNoStringLengh:(NSString *)string
{
    @try
    {
        if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 10)
        {
            return YES;
        }
        return NO;
    }
    @catch (NSException *exception)
    {
        // throws exception
    }
}

+ (BOOL)checkEmailAddress:(NSString *)strEmail
{
    @try
    {
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        return [emailTest evaluateWithObject:strEmail];
    }
    @catch (NSException *exception) {
        //  throws exception
    }
}

+ (BOOL)checkValueIsNonZero:(NSString *)string
{
    @try
    {
        if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue] != 00.00)
        {
            return YES;
        }
        return NO;
    }
    @catch (NSException *exception) {
        // throws exception
    }
}

#pragma mark -
#pragma mark ConnectedToInternet

+(BOOL)ConnectedToInternet
{
	@try
	{
		struct sockaddr_in zeroAddress;
		bzero(&zeroAddress, sizeof(zeroAddress));
		zeroAddress.sin_len = sizeof(zeroAddress);
		zeroAddress.sin_family = AF_INET;
		
		SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
		if(reachability != NULL)
		{
			//NetworkStatus retVal = NotReachable;
			SCNetworkReachabilityFlags flags;
			if (SCNetworkReachabilityGetFlags(reachability, &flags))
			{
				if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
				{
					// if target host is not reachable
					return NO;
				}
				
				if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
				{
					// if target host is reachable and no connection is required
					//  then we'll assume (for now) that your on Wi-Fi
					return YES;
				}
				
				
				if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
					 (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
				{
					// ... and the connection is on-demand (or on-traffic) if the
					//     calling application is using the CFSocketStream or higher APIs
					
					if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
					{
						// ... and no [user] intervention is needed
						return YES;
					}
				}
				
				if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
				{
					// ... but WWAN connections are OK if the calling application
					//     is using the CFNetwork (CFSocketStream?) APIs.
					return YES;
				}
			}
		}
		return NO;
	}
	@catch (NSException * e)
    {
		// throw exception
	}
	return NO;
}

#pragma mark -
#pragma mark Reachability Notifier

- (void)reachabilityChanged:(NSNotification* )notification
{
	NetworkStatus netStatus = [reachability currentReachabilityStatus];
	if(currentNetworkStatus == netStatus)
	{
		return;
	}
    else if (netStatus == NotReachable) {
        
 //       [[ApplicationData sharedInstance] showAlert:INTERNET_CONNECTION_ERROR andTag:1];
    }
	else
	{
		currentNetworkStatus = netStatus;
		//[[ApplicationData sharedInstance] showAlert:INTERNET_CONNECTION_ERROR andTag:1];
	}
}

#pragma mark -------------------------------
#pragma mark NSUserDefault Methods
#pragma mark -------------------------------

+ (void) setOfflineObject:(id)object forKey:(NSString *)key
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id) offlineObjectForKey:(NSString *)key
{
    //NSLog(@"key %@",key);
    id retval = nil;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:key])
    {
        retval = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] valueForKey:key]];
    }
    return retval;
}

+ (void) removeOfflineObjectForKey:(NSString *)key {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:key]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

/*
+ (NSString *) encryptString:(NSString *)string {
    
	StringEncryption *crypto = [[StringEncryption alloc] init];
	NSData *_secretData = [string dataUsingEncoding:NSUTF8StringEncoding];
	CCOptions padding = kCCOptionPKCS7Padding;
	NSData *encryptedData = [crypto encrypt:_secretData key:[ENCRYPTION_KEY dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];
	
    //NSLog(@"Encrypted data in hex: %@", encryptedData);
    
    //NSString *encryptedString = [[NSString alloc] initWithData:encryptedData encoding:NSUTF8StringEncoding];
    NSString *encryptedString = [encryptedData base64EncodingWithLineLength:0];
    //NSLog(@"Encrypted data string for export: %@",encryptedString);
    
    return encryptedString;
}

+ (NSString *) decryptString:(NSString *)encryptedString {
    
	StringEncryption *crypto = [[StringEncryption alloc] init];
	NSData *encryptedData = [NSData dataWithBase64EncodedString:encryptedString];
    CCOptions padding = kCCOptionPKCS7Padding;
    
    //NSLog(@"Encrypted data in hex: %@", encryptedData);
    
    NSData *decryptedData = [crypto decrypt:encryptedData key:[ENCRYPTION_KEY dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];
    
    //NSLog(@"Decrypted data in dex: %@", decryptedData);
    
    NSString *decryptedString = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
    
    //NSLog(@"Decrypted string is %@",decryptedString);
    
    return decryptedString;
}
*/

// Encode Special Characters in a string.
+ (NSString *) encodeSpecialCharactersInString:(NSString *)string
{
    
    NSString *encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,( CFStringRef)string, NULL, (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return encodedString;
}

+ (NSString *)uuid
{
    NSString *uuidString = nil;
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    if (uuid) {
        uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(NULL, uuid));
        CFRelease(uuid);
    }
    return [uuidString stringByReplacingOccurrencesOfString:@"-" withString:@""] ;
}

+(NSString *)returnTimeZoneDifference
{
    NSTimeInterval timeZoneOffset = ([[NSTimeZone systemTimeZone] secondsFromGMTForDate:[NSDate date]]/60);
    //return [NSString stringWithFormat:@"%.2f",timeZoneOffset];
    return [NSString stringWithFormat:@"%.0f",timeZoneOffset];
}

+ (NSString*)formattedDateRelativeToNow:(NSDate *)date
{
    NSDateFormatter *mdf = [[NSDateFormatter alloc] init];
    [mdf setDateFormat:@"yyyy-MM-dd"];
    NSDate *midnight = [mdf dateFromString:[mdf stringFromDate:date]];
//    [mdf release];
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [calender components:unitFlags fromDate:date];
//    [calender release];
    
    int weekday = [components weekday];
    
    NSInteger dayDiff = (int)[midnight timeIntervalSinceNow] / (60*60*24);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    if(dayDiff == 0)
        [dateFormatter setDateFormat:@"'Today, 'h':'mm aaa"];
    else if(dayDiff == -1)
        [dateFormatter setDateFormat:@"'Yesterday, 'h':'mm aaa"];
    else if(dayDiff > -7 && dayDiff <= -2)
    {
        switch (weekday)
        {
            case 1:
                [dateFormatter setDateFormat:@"'Sunday, 'h':'mm aaa"];
                break;
            case 2:
                [dateFormatter setDateFormat:@"'Monday, 'h':'mm aaa"];
                break;
            case 3:
                [dateFormatter setDateFormat:@"'Tuesday, 'h':'mm aaa"];
                break;
            case 4:
                [dateFormatter setDateFormat:@"'Wednesday, 'h':'mm aaa"];
                break;
            case 5:
                [dateFormatter setDateFormat:@"'Thursday, 'h':'mm aaa"];
                break;
            case 6:
                [dateFormatter setDateFormat:@"'Friday, 'h':'mm aaa"];
                break;
            case 7:
                [dateFormatter setDateFormat:@"'Saturday, 'h':'mm aaa"];
                break;
            default:
                [dateFormatter setDateFormat:@"MMMM d', Two days ago'"];
                break;
        }
    }
    else if(dayDiff > -14 && dayDiff <= -7)
        [dateFormatter setDateFormat:@"MMMM d YYYY"];
    else if(dayDiff >= -60 && dayDiff <= -30)
        [dateFormatter setDateFormat:@"MMMM d YYYY"];
    else if(dayDiff >= -90 && dayDiff <= -60)
        [dateFormatter setDateFormat:@"MMMM d YYYY"];
    else if(dayDiff >= -180 && dayDiff <= -90)
        [dateFormatter setDateFormat:@"MMMM d YYYY"];
    else if(dayDiff >= -365 && dayDiff <= -180)
        [dateFormatter setDateFormat:@"MMMM d YYYY"];
    else if(dayDiff < -365)
        [dateFormatter setDateFormat:@"MMMM d YYYY"];
    else
        [dateFormatter setDateFormat:@"MMMM d YYYY"];
    
    return [dateFormatter stringFromDate:date];
}

@end
