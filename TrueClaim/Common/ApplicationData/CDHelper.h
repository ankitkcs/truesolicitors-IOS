//
//  ApplicationData.h
//  CoreTalk
//
//  Created by Krish on 20/03/13.
//  Copyright (c) 2013 KCS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "ApplicationData.h"

//@class ApplicationData;

#define APP_VERSION [ApplicationData sharedInstance].appVersion

@interface CDHelper : NSObject
{
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext; //, readonly
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, readwrite) BOOL isGetsettingsNeeded;
@property (nonatomic, strong) NSString *appVersion;

+ (CDHelper *)sharedInstance;

//saurabh 26-11-13
//database methods
//jaimin 22-01-13
-(BOOL)commitChangesToDatabase;
-(BOOL)addCategoryDetailsWithCategorys:(NSArray*)arrCategorys;
-(BOOL)addProductDetailsWithProducts:(NSArray*)arrProducts;
-(BOOL)addProductIngrediantsWithIngrediants:(NSArray*)arrProductsIngrediants forProductId:(int)productId;
-(BOOL)addMenuDetailsWithMenuItems:(NSArray*)arrMenuItems;
-(BOOL)addPromoImageDetailsWithPromoImages:(NSArray*)arrPromoImages;
-(BOOL)addOutletDetailswithOutlets:(NSArray *)arrOutlets;
-(BOOL)addOutletDetailsWithOutletsImages:(NSArray *)arrOutletImages ForOutletId:(NSString *)outletId;
-(BOOL)addNotificationMasterWithNotifications:(NSArray *)arrNotifications;
-(BOOL)addRewardsMasterWithRewards:(NSArray *)arrRewards;
-(BOOL)addOrderHistoryWithWOrders:(NSArray *)arrOrders;
-(BOOL)addOrderHistoryDetailsWithWOrderDetails:(NSArray *)arrOrderDetails;
-(BOOL)addShippingDetailsWithAddresses:(NSArray*)arrAddresses withCommit:(BOOL)commit;
-(BOOL)addProFileDetailsWithDictionary:(NSDictionary *)dictDetails;
-(BOOL)addSettingDetails:(NSDictionary*)dictDetails;
-(BOOL)addAboutUsDetails:(NSArray*)arrAboutUsDetails;
-(BOOL)addOrderDetailsWithProduct:(ProductMaster*)productMaster;

-(BOOL)setProductQuantityToZero;

-(BOOL)updateProductDetailsWithProductDetails:(ProductMaster*)productMaster;
-(BOOL)updateOrderDetailsWithOrderDetails:(OrderDetails*)orderDetails;
-(BOOL)updateOrderHistoryWithOrderHistory:(OrderHistory*)orderHistory;

-(BOOL)deleteRecordsOfTable:(NSString*)table forField:(NSString*)field withEqualityValue:(NSString*)value;
-(BOOL)deleteAllRecordsOfTable:(NSString*)table;

-(NSArray*)getAllRecordsOfTable:(NSString*)table;
-(NSArray*)getAllRecordsOfTable:(NSString*)table WithSortByField1:(NSString*)field1 InAscending1:(BOOL)inAscending1 sortByField2:(NSString*)field2 InAscending2:(BOOL)inAscending2;
-(NSArray*)getRecordsOfTable:(NSString*)table forField:(NSString*)field withEqualityValue:(NSString*)value;
-(NSArray*)getRecordsOfTable:(NSString*)table forField:(NSString*)field withEqualityValue:(NSString*)value WithSortByField:(NSString*)sortField InAscending:(BOOL)inAscending;
-(NSArray*)getProductForcategory_Id:(int)category_Id isForHomeDelivery:(BOOL)isForHomeDelivery;
-(NSArray*)getAllCategoriesIsForHomeDeliverable:(BOOL)isForHomeDeliverable forOutletID:(int)outletId;

@end
