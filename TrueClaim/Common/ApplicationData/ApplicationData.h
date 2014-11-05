//
//  ApplicationData.h
//  CoreTalk
//
//  Created by Krish on 20/03/13.
//  Copyright (c) 2013 KCS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "LinkToClaim.h"
#import "DocumentDetail.h"


#define DATETIME_FORMATTER_DISPLAY [ApplicationData sharedInstance].displayDateTimeFormatter
#define DATE_FORMATTER_DISPLAY [ApplicationData sharedInstance].displayDateFormatter
#define DATETIME_FORMATTER_WS [ApplicationData sharedInstance].webserviceDateTimeFormatter_new
#define DATE_FORMATTER_WS [ApplicationData sharedInstance].webserviceDateFormatter
#define EXTRACT_DATETIME(T) [[T componentsSeparatedByString:@"."] objectAtIndex:0]

// Encode special characters of string.
#define URL_ENCODE_STRING(S) [ApplicationData encodeSpecialCharactersInString:S]
#define SEPERATOR_STRING @"|"

#define DEVICE_UDID [ApplicationData sharedInstance].deviceUDID
#define DEVICE_OS_VERSION [ApplicationData sharedInstance].deviceOSVersion
#define DEVICE_MODEL [ApplicationData sharedInstance].deviceModel

@interface ApplicationData : NSObject
{
    Reachability *reachability;
    NetworkStatus currentNetworkStatus;
    
    NSDateFormatter *webserviceDateTimeFormatter;
    NSDateFormatter *webserviceDateTimeFormatter_new;
    NSDateFormatter *webserviceDateFormatter;
    NSDateFormatter *webserviceDateFormatter_new;
    NSDateFormatter *displayDateTimeFormatter;
    NSDateFormatter *displayDateFormatter;
}

@property(nonatomic, strong) UIViewController *winViewController;
@property(nonatomic, retain) UIImage *logoImage;
@property(nonatomic, readwrite) BOOL isFourInchScreen;
@property(nonatomic, readwrite) BOOL isiOS7orPlus;
@property(nonatomic, readwrite) BOOL isNotificationEnable;
@property(nonatomic, readwrite) BOOL isDataDownloading;
@property(nonatomic, readwrite) BOOL isGetGeneralStatusSummaryWithNotificationFirstTime;

@property (nonatomic, readwrite) BOOL isNotificationClicked;
@property (nonatomic, readwrite) BOOL isDisply_PassCodeScreen;
@property (nonatomic, readwrite) BOOL isPasscodeSaved;
@property (nonatomic, readwrite) BOOL isReloadMyFolderData;

@property(nonatomic, retain) Reachability* reachability;

@property(readonly, strong) NSDateFormatter *webserviceDateTimeFormatter;
@property(readonly, strong) NSDateFormatter *webserviceDateTimeFormatter_new;
@property(readonly, strong) NSDateFormatter *webserviceDateFormatter;
@property(readonly, strong) NSDateFormatter *webserviceDateFormatter_new;
@property(readonly, strong) NSDateFormatter *displayDateTimeFormatter;
@property(readonly, strong) NSDateFormatter *displayDateFormatter;

//saurabh 29-05-13
@property (nonatomic, readwrite) int cartCount;
@property (nonatomic, readwrite) BOOL isFirstTime;
@property (nonatomic, strong) NSDate *serverDateTime;
@property (nonatomic, strong) NSDate *serverDateTimeProduct;
@property (nonatomic, strong) NSDate *serverDateTimeCategory;
@property (nonatomic, strong) NSDate *serverDateTimeNotification;

@property(nonatomic, strong) NSString *mobileNo;

@property (nonatomic, strong) NSString *deviceOSVersion;
@property (nonatomic, strong) NSString *deviceModel;
@property (nonatomic, strong) NSString *deviceUDID;
@property (nonatomic, strong) NSString *deviceUUID;

@property (nonatomic, strong) UIAlertView *alertView;

@property (nonatomic, strong) NSLocale *appLocal;
@property (nonatomic, retain) NSNumberFormatter *priceNumberFormatter;

@property (nonatomic,retain) NSString *loggerUserName;
@property (nonatomic,retain) NSString *loggerPassword;
@property (nonatomic,retain) NSString *loggerOutletId;
@property (nonatomic,retain) NSString *loggerPosUserId;

@property (nonatomic,retain) NSString *navigateFromView;
@property (nonatomic,retain) NSString *tc_auth_token; // true calim auth token

@property (nonatomic,retain) LinkToClaim *selectedClaim;
@property (nonatomic,retain) DocumentDetail *selectedDocDetail;


+ (ApplicationData *)sharedInstance;

+(void)changeNavigationBackImage;

- (void)showAlert:(NSString *)messageText andTag:(NSInteger)tag;
- (void)showAlert:(NSString *)messageText WithTitle:(NSString *)title Tag:(NSInteger)tag alertDelegate:(id)delegate andIsCancelButtonNeeded:(BOOL)isCancelButtonNeeded;

+ (BOOL)checkValidStringLengh:(NSString *)string;
+ (BOOL)checkMobileNoStringLengh:(NSString *)string;
+ (BOOL)checkEmailAddress:(NSString *)strEmail;
+ (BOOL)checkValueIsNonZero:(NSString *)string;
+ (BOOL) allowedCharacter:(NSString*)validCharacter inRange:(NSRange)range withReplaceString:(NSString *)string ForTextField:(UITextField*)textField andLength:(int)strLen;
+(NSString *) autoToZeroForTextField :(UITextField*)textField andString:(NSString*)string;

+(BOOL)ConnectedToInternet;
- (void)reachabilityChanged:(NSNotification* )notification; // reachability changed notification

// NSUser Defaults
+ (void) setOfflineObject:(id)object forKey:(NSString *)key;
+ (id) offlineObjectForKey:(NSString *)key;
+ (void) removeOfflineObjectForKey:(NSString *)key;

// Encode Special Characters in a string.
+ (NSString *) encodeSpecialCharactersInString:(NSString *)string;

+(NSString *)uuid;
+(NSString *)returnTimeZoneDifference;
+ (NSString*)formattedDateRelativeToNow:(NSDate *)date;

//Ranjit - Custom Navigation Bar
+(void)customizeNavigationBarWithImage:(UIImage*)customImage  OrColors : (NSArray*) customColors;
+(UIView*)customizeNavigationTitle:(NSString*)customTitle andCustomFont:(UIFont*)customFont andCustomColor:(UIColor*)customColor;
+(UIBarButtonItem*)navigationBarHiddenBackButton;

//Ranjit - Custom Button
+(UIButton*)iconButtonWithImage:(UIImage*)normalImage highlighImage:(UIImage*)hoverImage selectImage :(UIImage*)selectedImage;
+(UIButton*)customButtonWithBGImageOrColor:(UIColor*)bgColor andImage:(NSDictionary*)images withTitleText:(NSString*)buttonTitle andCustomFont:(UIFont*)customFont andTitleColors:(NSDictionary*)tcolors titleAlign:(NSString*)align andBtnSize:(CGRect)btnFrame;
+(UIButton*)customButtonWithIconAndTitle:(NSString*)buttonTitle icon:(UIImage*)iconImage iconAlign:(NSString*)align bgColor:(UIColor*)color titleColor:(UIColor*)tcolor titleFont:(UIFont*)font buttonSize:(CGRect)btnFrame;
+(UIButton*)customBackNavButtonWithTite:(NSString*)buttonTitle icon:(UIImage*)iconImage bgColor:(UIColor*)color titleColor:(UIColor*)tcolor titleFont:(UIFont*)font buttonSize:(CGRect)btnFrame;


//Ranjit - String Formatting

+ (NSArray *) getCommaSeparatedValues:(NSString *)string;
+ (NSArray *) getSeparatedValuesFromString:(NSString *)string andSeparator:(NSString *)seperator;


//Ranjit - Date Formatting
+(NSString *) getStringFromDate:(NSDate*)myDate inFormat:(NSString*)formatString WithAM:(BOOL)isAM;
+(NSDate *) getDateFromString:(NSString*)myDateString withFormat:(NSString*)formatString;
+(NSDate *) getPreviuosDatebyBackDay:(int)numOfBackDay;
+(NSDate *) getFurthurDatebyNextDay:(int)numONextDay;

//Ranjit - Image Customization
+ (UIImage*) resizeImage:(UIImage*)image scaledToSize:(CGSize)newSize;
+ (UIImage *)createGrdientImageWithColors : (NSArray*)gradientColors;
+ (UIImage *) imageWithView:(UIView *)view;
@end
