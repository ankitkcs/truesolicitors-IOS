//
//  AppConstants.h
//  CoreTalk
//
//  Created by Krish on 29/03/13.
//  Copyright (c) 2013 KCS. All rights reserved.

//*********************** SCREEN SIZE FOR IPHONE *************************//
#define IS_FOUR_INCH_SCREEN [[ApplicationData sharedInstance] isFourInchScreen]
#define IS_IOS7_OR_PLUS [[ApplicationData sharedInstance] isiOS7orPlus]

#define DB_NAME @"Qwiches.sqlite"

//************************* DATE FORMAT *********************//
#define DATETIME_FORMAT_WS @"yyyy-MM-dd HH:mm:ss"
#define DATETIME_FORMAT_DB @"yyyy-MM-dd HH:mm:ss"
#define DATE_FORMAT_WS @"yyyy-MM-dd"
#define DATETIME_FORMAT_DISPLAY @"dd, MMM yyyy    hh:mm a"
#define DATE_FORMAT_DISPLAY @"dd, MMM yyyy"

//**********************  VALIDATION  *******************//

#define MAX_LENGTH_ASSOCIATE_NAME 20
#define MAX_LENGTH_ASSOCIATE_MOBILE_NUMBER 15
#define MAX_LENGTH_ASSOCIATE_EMAIL_ID 50
#define MAX_LENGTH_ASSOCIATE_DESCRIPTION 100
#define MAX_LENGTH_CLIENT_NAME 20
#define MAX_LENGTH_CLIENT_SURNAME 20
#define MAX_LENGTH_CLIENT_ADDRESS 100
#define MAX_LENGTH_CLIENT_CITY 20
#define MAX_LENGTH_SHOESSIZE 2
#define MAX_LENGTH_WEIGHT 3
#define MAX_LENGTH_PREFFERD_CALL_TIME 20
#define MAX_LENGTH_CLIENT_EMAIL_ID 50
#define MAX_LENGTH_CLIENT_MOBILE 10
#define LEGALCHARACTERS_FOR_PHONE_NO "1234567890"
#define MAX_PRODUCT_QUANTITY 99

#define SAVED_PASSCODE @"savedPasscode"
#define FIRST_RUN @"appFirstRun"

//********************** APP THEME COLORS *******************//

#define Rgb2UIColor(r, g, b) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

#define THEME_RED_COLOR [UIColor colorWithRed:(139.0 / 255.0) green:(23.0 / 255.0) blue:(41.0 / 255.0) alpha:1.0]

#define APP_BACKGROUND_IMAGE [UIColor colorWithPatternImage:[UIImage imageNamed:@"ios_background.png"]]

//*********************** APP FONTS SIZE AND NAME *******************//

#define FN_ROBOTO_REGULAR @"Roboto-Regular"
#define FN_ROBOTO_MEDIUM @"Roboto-Medium"
#define FN_ROBOTO_CONDENSED @"Roboto-Condensed"
#define FN_ROBOTO_BOLD @"Roboto-Bold"
#define FN_ROBOTO_BOLDCONDENSED @"Roboto-BoldCondensed"

#define FS_20 20
#define FS_21 21
#define FS_22 22
#define FS_23 23
#define FS_24 24
#define FS_25 25
#define FS_26 26

//*********************** APP IMAGES NAME *******************//

#define LINK_IMAGE @"ios_link_popup_icon.png"

