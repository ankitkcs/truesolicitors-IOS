//
//  OutletDetails.h
//  Qwiches
//
//  Created by krish on 1/29/14.
//  Copyright (c) 2014 krish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface OutletDetails : NSManagedObject

@property (nonatomic, retain) NSNumber * imageId;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSNumber * sequenceNo;
@property (nonatomic, retain) NSNumber * outletId;

@end
