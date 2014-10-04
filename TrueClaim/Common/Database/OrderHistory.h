//
//  OrderHistory.h
//  Qwiches
//
//  Created by krish on 4/18/14.
//  Copyright (c) 2014 krish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface OrderHistory : NSManagedObject

@property (nonatomic, retain) NSString * couponcode;
@property (nonatomic, retain) NSNumber * couponValidForMinAmount;
@property (nonatomic, retain) NSDate * couponValidFromDate;
@property (nonatomic, retain) NSString * couponValidInBranchID;
@property (nonatomic, retain) NSDate * couponValidToDate;
@property (nonatomic, retain) NSNumber * discountedValue;
@property (nonatomic, retain) NSString * discountType;
@property (nonatomic, retain) NSNumber * earnRewardPts;
@property (nonatomic, retain) NSNumber * orderBillAmount;
@property (nonatomic, retain) NSDate * orderDate;
@property (nonatomic, retain) NSNumber * orderId;
@property (nonatomic, retain) NSString * orderStatus;
@property (nonatomic, retain) NSNumber * payRewardPts;
@property (nonatomic, retain) NSNumber * payRewardPtsStatus;
@property (nonatomic, retain) NSNumber * totalPrice;
@property (nonatomic, retain) NSNumber * totalServiceTax;
@property (nonatomic, retain) NSNumber * deliveryCharge;
@property (nonatomic,retain) NSString *customerName;
@property (nonatomic,retain) NSString *customerMobileNo;
@property (nonatomic,retain) NSString *isBookedStatus;
@property (nonatomic,retain) NSString *carTableNo;

@end
