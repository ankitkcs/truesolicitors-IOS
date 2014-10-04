//
//  WebApiRequest.h
//  CoreTalk
//
//  Created by Krish on 15/04/13.
//  Copyright (c) 2013 KCS. All rights reserved.
//
//  Soap Client

#import <Foundation/Foundation.h>

@interface WebApiRequest : NSObject<NSXMLParserDelegate> {
    
    
}

-(void)performServerTaskWithRequest:(NSMutableDictionary *)requestDict orParameter:(NSMutableDictionary*)paramDict Delegate:(NSObject *)delegate forRequestType:(NSString *)requestType withTag:(int)tag;

-(id)performServerTask:(NSMutableDictionary *)requestDict withFileData:(NSData *)fileData andFileName:(NSString *)fileName andFileFieldName:(NSString*)fileFieldName delegate:(NSObject *)delegate forRequestType:(NSString *)requestType withTag:(int)tag;

-(void) cancelAsyncDownload;

@end
