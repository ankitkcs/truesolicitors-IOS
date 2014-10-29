//
//  WebApiRequest.h
//  CoreTalk
//
//  Created by Krish on 15/04/13.
//  Copyright (c) 2013 KCS. All rights reserved.
//
//  Soap Client

#import <Foundation/Foundation.h>

#define GET_USER 111
#define GET_MENU 1
#define GET_CATEGORY 2
#define GET_PRODUCT 3
#define GET_MY_ORDERS 4
#define GET_REWARD_POINTS 5
#define GET_OUTLETS 6
#define SET_REGISTRATION 7
#define SET_VERIFICATION 8
#define SET_SHIPPING_ADDRESS 9
#define SET_CONFIRM_MY_ORDER 10
#define GET_SETTINGS 11
#define GET_PROMOIMAGES 12
#define GET_ABOUT_US 13
#define GET_BILL_DETAIL 14
#define SET_ASSOCIATE_WITH_US 15
#define GET_PROFILE 16
#define SET_PROFILE 17
#define GET_NOTIFICATIONS 18
#define GET_GENERALSTATUS 19
#define SET_TOKEN 20
#define SET_ERRORLOG 21
#define GET_COUPON_DETAIL 22

@interface WebApiRequest : NSObject<NSXMLParserDelegate> {
    
    
}

-(void) cancelAsyncDownload;

-(void)performServerTaskWithRequest:(NSMutableDictionary *)requestDict orParameter:(NSMutableDictionary*)paramDict Delegate:(NSObject *)delegate forRequestType:(NSString *)requestType withTag:(int)tag;

-(id)performServerTask:(NSMutableDictionary *)requestDict withFileData:(NSData *)fileData andFileName:(NSString *)fileName andFileFieldName:(NSString*)fileFieldName delegate:(NSObject *)delegate forRequestType:(NSString *)requestType withTag:(int)tag;

// ranjit add new post method Here
-(void)PostDataWithParameter:(NSMutableDictionary*)paramDict forDelegate:(NSObject *)delegate andTag:(int)tag forRequstType:(NSString*)reqType serviceType:(NSString*)svcType;

@end
