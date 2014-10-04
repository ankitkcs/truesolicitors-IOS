//
//  SettingDetails.h
//  Qwiches
//
//  Created by krish on 4/18/14.
//  Copyright (c) 2014 krish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SettingDetails : NSManagedObject

@property (nonatomic, retain) NSNumber * serviceTax;
@property (nonatomic, retain) NSNumber * deliveryCharge;
@property (nonatomic, retain) NSNumber * minOrderAmount;

@end
