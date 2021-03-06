//
//  ServiceConstants.h
//  CoreTalk
//
//  Created by Krish on 29/03/13.
//  Copyright (c) 2013 KCS. All rights reserved.
//
#define USER_LOGIN @"UserLogin"
#define SUGGESTIONS @"Suggestions"
#define USER_PROFILE @"UserProfile"
#define SERVER_DATETIME @"ServerDateTime"
#define SERVER_DATETIME_PRODUCT @"ServerDateTimeProduct"
#define SERVER_DATETIME_CATEGORY @"ServerDateTimeCategory"
#define SERVER_DATETIME_NOTIFICATION @"ServerDateTimeNotification"
#define IS_FIRST_TIME @"IsFirstTime"
#define MOBILE_NO @"MobileNo"
#define REPORTID @"ReportId"
#define NOTIFICATION_STATUS @"NotificationStatus"

#define RED_ALERT @"RedAlert"
#define FORGROUND_ALERT @"ForgroundAlert"
#define POPUP_ANIMATION_DURATION 0.5
#define DEVICE_TYPE_ID 2
#define SUCCESS @"Success"
#define NO_RECORD @"No Records Found"
#define USER_PROFILE_PIC @"userprofilepic.png"
#define PENDING @"pending"
#define CANCEL @"cancelled"
#define DELIVERED @"delivered"
#define NEW @"new"
#define NOT_APPLICABLE @"N/A"
#define LOADER_IMAGE @"loadimageicn.png"
#define MYORDER_LOADER_IMAGE @"productnoimg.png"
#define HOME_LOADER_IMAGE @"qlogomid.png"
#define DEVICE_TOKEN @"Device_Token"
#define DEVICE_UUID @"Device_UUID"
#define LAST_VERSION @"Last_Version"

#define LOGGED_USERNAME @"Logged_UserName"
#define LOGGED_USERPAAS @"Logged_UserPass"
#define LOGGED_OUTLETID @"Logged_OutletID"
#define LOGGED_POSUSERID @"Logged_PosUserID"

#define CUSTOMER_NAME @"Customer_Name"
#define CUSTOMER_MOBILE_NO @"Customer_Mobile_No"
#define CUSTOMER_CARTABLE_NO @"Customer_CarTable_NO"
#define CUSTOMER_BOOKINGFOR @"Customer_BookingFor"

//*********************** LOCAL WEBSERVER URL *************************//

#define APP_SERVER_URL @"http://82.196.11.49/api/%@"
#define HOST_NAME @"http://82.196.11.49"

//************************* TEST WEBSERVER URL *********************//
//
//#define APP_SERVER_URL @"http://69.162.69.130:1001/qwichesWStest/index.php?file=%@&format=json"
//#define HOST_NAME @"http://69.162.69.130"

//************************* LIVE WEBSERVER URL *********************//

//#define APP_SERVER_URL @"http://69.162.69.130:1001/qwichesWS/index.php?file=%@&format=json"
//#define HOST_NAME @"http://69.162.69.130"

//************************** SERVICE TYPE ********************//

#define WS_POST @"POST"
#define WS_GET @"GET"
#define WS_PUT @"PUT"

//************************* WEB API KEYS *************************//

#define kCLAIM_NUMBER @"claim_number"
#define kBITH_DATE @"date_of_birth"
#define kDEVICE_ID @"device_id"

//*********************** LOCAL WEBSERVICES ACTIONS [NAME] *************************//
#define ACT_USER_LOGIN @"setlogin"
#define ACT_GET_MENU @"getmenu"
#define ACT_GET_CATEGORY @"getcategory"
#define ACT_GET_PRODUCT @"getproduct"
#define ACT_GET_REWARD_POINTS @"getrewardpoints"
#define ACT_GET_MY_ORDERS @"getmyorders"
#define ACT_GET_OUTLETS @"getoutletsdetail"
#define ACT_SET_REGISTRATION @"setregistration"
#define ACT_SET_VERIFICATION @"setverification"
#define ACT_SET_SHIPPING_ADDRESS  @"setshippingadd"
#define ACT_SET_CONFIRM_MY_ORDER @"setconfirmmyorder"
#define ACT_GET_SETTINGS @"getsettings"
#define ACT_GET_PROMOIMAGES @"getpromoimages"
#define ACT_GET_ABOUT_US @"getcmsdata"
#define ACT_GET_BILL_DETAIL @"getbilldetail"
#define ACT_SET_ASSOCIATE_WITH_US @"setassociate"
#define ACT_GET_PROFILE @"GetProfile"
#define ACT_SET_PROFILE @"setprofilenew"
#define ACT_GET_NOTIFICATIONS @"getnotification"
#define ACT_GET_GENERALSTATUS @"getgeneralstatus"
#define ACT_SET_TOKEN @"settoken"
#define ACT_SET_ERRORLOG @"seterrorlog"
#define ACT_GET_COUPON_DETAIL @"getcoupondetail"

#define reqLINK_CLAIM @"accounts/true_solicitors/claims/link"
#define reqGET_MESSAGE @"messages"
#define reqGET_DOCUMENTS @"documents"
#define reqGET_DOCUMNETS_TYPE @"document_types"
#define reqGET_PDFDOCBY_GUID @"documents/%@"

// ********************** TRUE CALIM AUTHENTICATION **********************

#define AUTH_USER @"true_solicitors"
#define LINK_TOKEN @"3bf73122ecbd29c667e599d679ad2ef4"

//************************* SERVICE TAGS *********************//
#define tLink 210
#define tGetMessage 211
#define tGetNewMessage 212
#define tGetDoc 213
#define tGetDocType 214
#define tGetDocPDF 215
#define tAction 216
#define tActionRead 217



