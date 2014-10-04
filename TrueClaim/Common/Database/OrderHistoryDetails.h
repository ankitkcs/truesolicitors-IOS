//
//  OrderHistoryDetails.h
//  Qwiches
//
//  Created by krish on 3/12/14.
//  Copyright (c) 2014 krish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface OrderHistoryDetails : NSManagedObject

@property (nonatomic, retain) NSNumber * orderHistoryDetailsId;
@property (nonatomic, retain) NSNumber * orderId;
@property (nonatomic, retain) NSNumber * productId;
@property (nonatomic, retain) NSNumber * productPrice;
@property (nonatomic, retain) NSNumber * productQuantity;
@property (nonatomic, retain) NSString * productName;

@end
