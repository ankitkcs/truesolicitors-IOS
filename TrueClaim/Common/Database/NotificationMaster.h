//
//  NotificationMaster.h
//  Qwiches
//
//  Created by krish on 2/28/14.
//  Copyright (c) 2014 krish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NotificationMaster : NSManagedObject

@property (nonatomic, retain) NSString * notificationDescription;
@property (nonatomic, retain) NSNumber * notificationId;
@property (nonatomic, retain) NSString * notificationImageUrl;
@property (nonatomic, retain) NSDate * notificationTime;
@property (nonatomic, retain) NSString * notificationTitle;
@property (nonatomic, retain) NSNumber * isRead;

@end
