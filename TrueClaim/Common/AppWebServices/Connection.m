//
//  WebApiRequest.m
//  CoreTalk
//
//  Created by Krish on 15/04/13.
//  Copyright (c) 2013 KCS. All rights reserved.
//
//  Soap Client

#import "Connection.h"
#import "ApplicationData.h"
#import "JSON.h"


#pragma mark -
#pragma mark Connection Class implementation

@implementation Connection

@synthesize receivedData;
@synthesize errorMsg;
@synthesize urlConnection;
@synthesize response;
@synthesize rootTag;
@synthesize classTag;
@synthesize childTag;
@synthesize subChildTag;
@synthesize delegate;
@synthesize contentNode;
@synthesize contentString;
@synthesize cancelled;
@synthesize finished;


#pragma mark -
#pragma mark Connection User Define Methods

// initialize request

-(id)initWithRequest:(NSMutableURLRequest *)request withDelegate:(id)delegate1 tag:(int)Tag
{
	@try
	{
        self.request = request;
		tagValue = Tag;
		delegate = delegate1;
		errorMsg = @"";
        currentTag = Tag;

        self.requestCount = 1;
		urlConnection = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:NO];
		self.receivedData = [NSMutableData data];
		response = nil;
		[urlConnection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
		[urlConnection start];
		return self;
	}
	@catch (NSException * e)
	{
        
	}
	return nil;
}

// WebApiRequest Delegate method to each calling controller
-(void)setData:(NSMutableArray *)responseData :(NSString *)ErrorMsg withDelegate:(id)Delegate andTag:(int)Tag
{
	[delegate setData:responseData :errorMsg withDelegate:delegate andTag:tagValue];
}

- (void)cancelAsyncDownload
{
    //	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
	@try
	{
		if (urlConnection !=nil)
        {
			[urlConnection cancel];
		}
		receivedData = nil;
	}
	@catch (NSException * e)
	{
	}
}

#pragma mark -
#pragma mark NSURLConnection delegate methods

// Receiving the Response from the server side.
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response1
{
	self.response = response1;
}

// Receioving Data from the server side.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	@try
	{
		if (!receivedData)
		{
			receivedData = [[NSMutableData alloc]initWithData:data];
		}
		else
		{
			[receivedData appendData:data];
		}
	}
	@catch (NSException * e)
	{
	}
}



// Finishing of Loading data from the server side.

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    @try
	{
        //NSLog(@"in connectionDidFinishLoading");
        @synchronized(self)
        {
            if (!cancelled)
            {
                finished = YES;
                [urlConnection unscheduleFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
                if (receivedData !=nil)
                {
                    NSString *stringData = [[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding];
                    
                    NSLog(@"Ranjit Response : '%@'",stringData);
                    
                    NSDictionary *responseJSON = [stringData JSONValue];
                    
                    [delegate setData:responseJSON :errorMsg withDelegate:delegate andTag:tagValue];
                    
                }
            }
        }
	}
	@catch (NSException * e)
	{
	}
}

// Failure in connection from server or the internet
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	@try
	{
        NSDictionary *dict = [error userInfo];
        errorMsg = [dict valueForKey:@"NSLocalizedDescription"];
        //NSLog(@"errorMsg %@",errorMsg);
        
        if (self.requestCount <= 2)
        {
            self.requestCount++;
            urlConnection = [[NSURLConnection alloc]initWithRequest:self.request delegate:self startImmediately:NO];
            self.receivedData = [NSMutableData data];
            response = nil;
            [urlConnection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
            [urlConnection start];
        }
        else
        {
            [delegate setData:nil :errorMsg withDelegate:delegate andTag:tagValue];
        }
	}
	@catch (NSException * e)
	{
	}
}

#pragma mark -
#pragma mark NSXMLParser Delegate Methods

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    //dharmesh 24-12-12
    //added if/else
    //NSLog(@"%@",self.arrResponseData);
    if (self.arrResponseData)
    {
        [self.arrResponseData removeAllObjects];
    }
    else
    {
        self.arrResponseData = nil;
        self.arrResponseData = [[NSMutableArray alloc]init];
    }
}

// sent when the parser begins parsing of the document.
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    
    if ([elementName isEqualToString:rootTag])
    {
        contentString = [[NSMutableString alloc]init];
    }
    
    /*
    if (![elementName isEqualToString:rootTag])
    {
        if ([elementName isEqualToString:classTag])
        {
            object = [[NSClassFromString(classTag) alloc]init];
            //isSetDevice = NO;
        }
        else if ([elementName isEqualToString:childTag]) {
            childObject = [[NSClassFromString(childTag) alloc] init];
            isChildNode = YES;
        }
        else if ([elementName isEqualToString:subChildTag]) {
            subChildObject = [[NSClassFromString(subChildTag) alloc] init];
            isSubChildNode = YES;
        }
        else
        {
            contentNode = [elementName copy];
            contentString = [[NSMutableString alloc]init];
        }
    }
     */
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
//    //NSLog(@"st %@",string);
    [contentString appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName0
{
//    NSString *stringData;
    NSDictionary *responseJSON;
    if ([elementName isEqualToString:rootTag])
    {

//        switch (currentTag) {
//            case GET_CATEGORY:
                responseJSON = [contentString JSONValue];
                [self.arrResponseData addObject:responseJSON];
//                break;
//        }
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    self.isParserError = TRUE;
    NSDictionary *dict = [parseError userInfo];
    errorMsg = [dict valueForKey:@"NSLocalizedDescription"];
    [delegate setData:nil :errorMsg withDelegate:delegate andTag:tagValue];
}

// ...and this reports a fatal error to the delegate. The parser will stop parsing.
- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError
{
    self.isParserError = TRUE;
    NSDictionary *dict = [validationError userInfo];
    errorMsg = [dict valueForKey:@"NSLocalizedDescription"];
    [delegate setData:nil :errorMsg withDelegate:delegate andTag:tagValue];
}
@end
