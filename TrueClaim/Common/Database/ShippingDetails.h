//
//  ShippingDetails.h
//  Qwiches
//
//  Created by krish on 1/31/14.
//  Copyright (c) 2014 krish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ShippingDetails : NSManagedObject

@property (nonatomic, retain) NSNumber * shippingId;
@property (nonatomic, retain) NSString * shippingAddress;
@property (nonatomic, retain) NSString * contactNo;

@end
