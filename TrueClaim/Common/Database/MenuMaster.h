//
//  MenuMaster.h
//  Qwiches
//
//  Created by krish on 2/1/14.
//  Copyright (c) 2014 krish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MenuMaster : NSManagedObject

@property (nonatomic, retain) NSNumber * isActive;
@property (nonatomic, retain) NSNumber * isDelete;
@property (nonatomic, retain) NSNumber * menuId;
@property (nonatomic, retain) NSString * menuImageUrl;
@property (nonatomic, retain) NSString * menuName;
@property (nonatomic, retain) NSString * menuTitle;
@property (nonatomic, retain) NSNumber * sequenceNo;
@property (nonatomic, retain) NSString * menuWebUrl;

@end
