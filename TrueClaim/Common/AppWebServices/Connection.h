//
//  WebApiRequest.h
//  CoreTalk
//
//  Created by Krish on 15/04/13.
//  Copyright (c) 2013 KCS. All rights reserved.
//
//  Soap Client

#import <Foundation/Foundation.h>

@interface Connection : NSObject <NSXMLParserDelegate>
{
	NSMutableData *receivedData; // Response data for URLRequest
    
	id delegate; // dynamic type
	int tagValue;
	
    id object; // class object with dynamic type
    id childObject;
    id subChildObject;
    
    NSString *rootTag; // Represents the RootTag in XML Response
    NSString *classTag; // Represents the ClassTag in XML Response
    NSString *childTag; // Represents the ChildTag in XML Response
    NSString *subChildTag; // Represents the SubChildTag in XML Response
    
	NSURLConnection *urlConnection; // connection object
	NSURLResponse *response;// response object
    
	NSString *errorMsg; // Error Message
    
    NSMutableString *contentNode;
    NSMutableString *contentString;
    
    int currentTag;
    BOOL isChildNode;
    BOOL isSubChildNode;
    
    //saurabh 27-05-13
    BOOL cancelled;
    BOOL finished;
}

@property(nonatomic,strong) NSMutableData *receivedData;

@property(nonatomic,strong) NSURLResponse *response;
@property(nonatomic,strong) NSString *errorMsg;
@property(nonatomic,strong) NSString *rootTag;
@property(nonatomic,strong) NSString *classTag;
@property(nonatomic,strong) NSString *childTag;
@property(nonatomic,strong) NSString *subChildTag;
@property(nonatomic,copy) id delegate;
@property(nonatomic,strong) NSURLConnection *urlConnection;

@property(nonatomic,strong) NSMutableString *contentNode;
@property(nonatomic,strong) NSMutableString *contentString;

//saurabh 27-05-13
@property(nonatomic,readwrite) BOOL cancelled;
@property(nonatomic,readwrite) BOOL finished;

//saurabh 11-07-13
@property (nonatomic,readwrite) BOOL isParserError;
@property (nonatomic,strong) NSMutableURLRequest *request;
@property (nonatomic,readwrite) int requestCount;

@property (nonatomic,retain) NSMutableArray *arrResponseData;


-(id)initWithRequest:(NSMutableURLRequest *)request withDelegate:(id)delegate1 tag:(int)Tag;

-(void)setData:(id)responseData :(NSString *)ErrorMsg withDelegate:(id)Delegate andTag:(int)Tag;

- (void)cancelAsyncDownload;

@end
