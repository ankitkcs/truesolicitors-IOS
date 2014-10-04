//
//  WebApiRequest.m
//  CoreTalk
//
//  Created by Krish on 15/04/13.
//  Copyright (c) 2013 KCS. All rights reserved.
//
//  Soap Client

#import "WebApiRequest.h"
#import "JSON.h"
#import "Connection.h"

@implementation WebApiRequest
{
    id mdelegate;
    int TagValue;
    Connection *conn;
    NSString *username;
    NSString *password;
    BOOL isParserError;
}

-(void)performServerTaskWithRequest:(NSMutableDictionary *)requestDict orParameter:(NSMutableDictionary*)paramDict Delegate:(NSObject *)delegate forRequestType:(NSString *)requestType withTag:(int)tag
{
    //NSLog(@"Parm Dict : %@ ",paramDict);
    
    NSLog(@"Request Dictionary : %@",requestDict);
    
	@try
	{
        NSMutableURLRequest *request;
        
        if (requestDict) // request with data dictionary
        {
            NSLog(@"requestDict123 %@",requestDict);
            request = [WebApiRequest buildMutableUrlRequest:[NSString stringWithFormat:@"json=%@",[requestDict JSONRepresentation]] withUrl:[NSURL URLWithString:[NSString stringWithFormat:APP_SERVER_URL,requestType]]];
        }
        else //request with parameters
        {
            NSString *strParam = [[NSString alloc] init];
            strParam = @"";
            NSArray *arrKays = [paramDict allKeys];
            for (int i=0; i<[arrKays count]; i++)
            {
                strParam = [strParam stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",[arrKays objectAtIndex:i],[paramDict valueForKey:[arrKays objectAtIndex:i]]]];
            }
            
            NSString *requestUrl = [[NSString stringWithFormat:APP_SERVER_URL,requestType] stringByAppendingString:strParam];
            //NSLog(@"requestUrl %@",requestUrl);
            
            NSString *protectedUrl = ( NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,( CFStringRef)requestUrl, NULL, (CFStringRef)@" ",CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
            
            NSLog(@"URL WITH PARAMETER AND VALUE %@",protectedUrl);
            
            request = [WebApiRequest buildMutableUrlRequest:nil withUrl:[NSURL URLWithString:protectedUrl]];
        }
        conn = [[Connection alloc]initWithRequest:request withDelegate:delegate tag:tag];
	}
	@catch (NSException * e)
	{
        
	}
}

-(id)performServerTask:(NSMutableDictionary *)requestDict withFileData:(NSData *)fileData andFileName:(NSString *)fileName andFileFieldName:(NSString*)fileFieldName delegate:(NSObject *)delegate forRequestType:(NSString *)requestType withTag:(int)tag
{
    id retval = nil;
    //NSLog(@"Request Json: \n%@", requestDict);
    //NSLog(@"Request URL: \n%@", [NSString stringWithFormat:APP_SERVER_URL,requestType]);
    @try {
        //request
        
        NSMutableDictionary *postVariables = [[NSMutableDictionary alloc] init];
        
        [postVariables setValue:[NSString stringWithFormat:@"%@", [requestDict JSONRepresentation]] forKey:@"data"];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL: [NSURL URLWithString:[NSString stringWithFormat:APP_SERVER_URL,requestType]]];
        
        [request setHTTPMethod:@"POST"];
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        //POST body
        NSMutableData *postbody = [NSMutableData data];
        
        //append string data
        
        //NSLog(@"POSTDATA:%@",[NSString stringWithFormat:@"data=%@",[requestDict JSONRepresentation]]);
        //[postbody appendData:[[NSString stringWithFormat:@"data=%@",[requestDict JSONRepresentation]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
//        [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
//        [postBody appendData:[@"Content-Disposition: form-data; name=\"media\"; filename=\"fish.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//        [postBody appendData:[@"Content-Type: image/jpeg\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//        [postBody appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        //append file
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",fileFieldName, fileName] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[NSData dataWithData:fileData]];
        [postbody appendData:[WebApiRequest createFormData:postVariables withBoundary:boundary]];
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody:postbody];
        
        //set content length
        NSString *postLength = [NSString stringWithFormat:@"%d", [postbody length]];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        
        conn = [[Connection alloc]initWithRequest:request withDelegate:delegate tag:tag];
        
        //        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        //        if ([responseData length] > 0) {
        //            NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        //            retval = [responseString JSONValue];
        //
        //            //NSLog(@"LogError Response String: %@",responseString);
        //            //NSLog(@"LogError Response: %@",retval);
        //        }
        
    }
    @catch (NSException *exception) {
        retval = nil;
    }
    return retval;
}

+ (NSData*)createFormData:(NSDictionary*)myDictionary withBoundary:(NSString*)myBounds {
    
    NSMutableData *myReturn = [[NSMutableData alloc] init];
    
    NSArray *formKeys = [myDictionary allKeys];
    for (int i = 0; i < [formKeys count]; i++) {
        [myReturn appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",myBounds] dataUsingEncoding:NSASCIIStringEncoding]];
        [myReturn appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n",[formKeys objectAtIndex:i],[myDictionary valueForKey:[formKeys objectAtIndex:i]]] dataUsingEncoding:NSASCIIStringEncoding]];
    }
    return myReturn;
}

+(NSMutableURLRequest *)buildMutableUrlRequest:(NSString *)soapMessage withUrl:(NSURL *)url
{
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0f];
    if (soapMessage)
    {
        
        NSString *protectedUrl = ( NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,( CFStringRef)soapMessage, NULL, (CFStringRef)@"&",CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
        
//        NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
//        [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
//        [theRequest setHTTPMethod:@"POST"];
//        [theRequest setTimeoutInterval:300.0f];
//        [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSASCIIStringEncoding]];
//        msgLength = nil;
        
        NSString *msgLength = [NSString stringWithFormat:@"%d", [protectedUrl length]];
        [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
        [theRequest setHTTPMethod:@"POST"];
        [theRequest setTimeoutInterval:300.0f];
        [theRequest setHTTPBody: [protectedUrl dataUsingEncoding:NSASCIIStringEncoding]];
        msgLength = nil;
        
    }
	return theRequest;
}

-(NSMutableURLRequest *)BuildMutableRequest:(NSString *)soapMessage andAction:(NSString *)soapAction
{
    //NSLog(@"url %@",APP_SERVER_URL);
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:APP_SERVER_URL]];
    [theRequest setTimeoutInterval:3000.0f];
    NSString *msgLength = [NSString stringWithFormat:@"%d",[soapMessage length]];
    [theRequest addValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
//    [theRequest addValue:[NSString stringWithFormat:SOAP_ACTION,soapAction] forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return theRequest;
}

// For cancelling urlconnection request using connection object
-(void) cancelAsyncDownload
{
	@try
	{
        //NSLog(@"Inside cancel download");
        @synchronized(conn)
        {
            if (!conn.finished)
            {
                conn.cancelled = YES;
                if (conn != nil) {
                    [conn cancelAsyncDownload];
                }
            }
        }
	}
	@catch (NSException * e)
	{
        // throws exception
	}
}

@end