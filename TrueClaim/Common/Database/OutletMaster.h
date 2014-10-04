//
//  OutletMaster.h
//  Qwiches
//
//  Created by krish on 2/18/14.
//  Copyright (c) 2014 krish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface OutletMaster : NSManagedObject

@property (nonatomic, retain) NSString * outletAddress;
@property (nonatomic, retain) NSString * outletContactNo;
@property (nonatomic, retain) NSString * outletEmailId;
@property (nonatomic, retain) NSNumber * outletId;
@property (nonatomic, retain) NSString * outletName;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;

@end
