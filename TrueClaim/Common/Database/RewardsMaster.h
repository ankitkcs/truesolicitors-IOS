//
//  RewardsMaster.h
//  Qwiches
//
//  Created by krish on 1/31/14.
//  Copyright (c) 2014 krish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RewardsMaster : NSManagedObject

@property (nonatomic, retain) NSDate * expiryDate;
@property (nonatomic, retain) NSNumber * billNo;
@property (nonatomic, retain) NSNumber * rewardAmount;
@property (nonatomic, retain) NSDate * billDate;
@property (nonatomic, retain) NSNumber * earnedRewardAmount;

@end
