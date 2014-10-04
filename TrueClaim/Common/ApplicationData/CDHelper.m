//
//  ApplicationData.m
//  CoreTalk
//
//  Created by Krish on 20/03/13.
//  Copyright (c) 2013 KCS. All rights reserved.
//

#import "CDHelper.h"
#import <QuartzCore/QuartzCore.h>
#include <CoreFoundation/CFString.h>
#include <CoreFoundation/CFBase.h>

#import "CategoryMaster.h"
#import "OutletMaster.h"
#import "OutletDetails.h"
#import "OrderDetails.h"
#import "NotificationMaster.h"
#import "ShippingDetails.h"
#import "ClientMaster.h"
#import "RewardsMaster.h"
#import "OrderHistory.h"
#import "OrderHistoryDetails.h"
#import "MenuMaster.h"
#import "SettingDetails.h"
#import "PromoImageDetails.h"
#import "AboutUsDetails.h"
#import "IngrediantDetails.h"

@implementation CDHelper

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

@synthesize appVersion;

- (id)init
{
	if(self = [super init])
	{
        [self initialize];
	}
	return self;
}

- (void)initialize
{
     self.appVersion = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleShortVersionString"];
}


+ (CDHelper *)sharedInstance
{
    static CDHelper *sharedInstance;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark --
#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    //NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FailedBankCD" withExtension:@"momd"];
    __managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: DB_NAME]];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSDictionary *options;
    
    if ((![[NSUserDefaults standardUserDefaults] valueForKey:LAST_VERSION]) || (![[[NSUserDefaults standardUserDefaults] valueForKey:LAST_VERSION] isEqualToString:self.appVersion]))
    {
        options = [NSDictionary dictionaryWithObjectsAndKeys:
                   [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                   [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                   nil];
        [[NSUserDefaults standardUserDefaults] setValue:self.appVersion forKey:LAST_VERSION];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.isGetsettingsNeeded = TRUE;
    }
    else
    {
        options = nil;
        self.isGetsettingsNeeded = FALSE;
    }
    
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
    {
        
        //NSLog(@"error %@",error);
        
//        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
//        NSLog(@"Deleted old database %@, %@", error, [error userInfo]);
//        [__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:@{NSMigratePersistentStoresAutomaticallyOption:@YES} error:&error];
        
        
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
    }
    
    return __persistentStoreCoordinator;
}

#pragma mark -
#pragma mark - Application's Documents directory

- (NSString *)applicationDocumentsDirectory
{
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

#pragma mark -
#pragma mark - Database Methods

//jaimin 22-01-14
-(BOOL)commitChangesToDatabase
{
    NSError *error;
    BOOL success = FALSE;
    if (![self.managedObjectContext save:&error]) {
		// Handle the error.
        NSLog(@"Error : %@",[error localizedDescription]);
        success = FALSE;
	}
    else {
        //NSLog(@"success");
        success = TRUE;
    }
    return success;
}

#pragma mark -
#pragma mark insert queries

-(BOOL)addCategoryDetailsWithCategorys:(NSArray*)arrCategorys
{
    NSLog(@"Adding Data : %@",arrCategorys);
    
    NSError *error;
    for (int i=0; i<[arrCategorys count]; i++)
    {
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSPredicate *predicate;
        predicate = [NSPredicate predicateWithFormat:@"(categoryId == %d)",[[(NSDictionary*)[arrCategorys objectAtIndex:i] valueForKey:@"Id"] intValue]];
        [fetchRequest setPredicate:predicate];
        NSEntityDescription *entity;
        entity = [NSEntityDescription
                  entityForName:@"CategoryMaster" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        //NSLog(@"%@",fetchRequest);
        
        NSArray *arrTemp  = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        if ([arrTemp count]>0)
        {
            CategoryMaster *categoryMaster = [arrTemp objectAtIndex:0];
            [categoryMaster setCategoryName:[[arrCategorys objectAtIndex:i] valueForKey:@"Name"]];
            [categoryMaster setOutletId:[NSNumber numberWithInt:[[(NSDictionary*)[arrCategorys objectAtIndex:i] valueForKey:@"OutletId"] intValue]]];
            [categoryMaster setSequenceNo:[NSNumber numberWithInt:[[(NSDictionary*)[arrCategorys objectAtIndex:i] valueForKey:@"SequenceNo"] intValue]]];
            [categoryMaster setIsDelete:[NSNumber numberWithBool:[[(NSDictionary*)[arrCategorys objectAtIndex:i] valueForKey:@"IsDeleted"] boolValue]]];
            [categoryMaster setIsActive:[NSNumber numberWithBool:[[(NSDictionary*)[arrCategorys objectAtIndex:i] valueForKey:@"Status"] boolValue]]];
        }
        else {
            CategoryMaster *categoryMaster = (CategoryMaster *)[NSEntityDescription insertNewObjectForEntityForName:@"CategoryMaster" inManagedObjectContext:self.managedObjectContext];
            [categoryMaster setCategoryId:[NSNumber numberWithInt:[[(NSDictionary*)[arrCategorys objectAtIndex:i] valueForKey:@"Id"] intValue]]];
            [categoryMaster setCategoryName:[[arrCategorys objectAtIndex:i] valueForKey:@"Name"]];
            [categoryMaster setOutletId:[NSNumber numberWithInt:[[(NSDictionary*)[arrCategorys objectAtIndex:i] valueForKey:@"OutletId"] intValue]]];
            [categoryMaster setSequenceNo:[NSNumber numberWithInt:[[(NSDictionary*)[arrCategorys objectAtIndex:i] valueForKey:@"SequenceNo"] intValue]]];
            [categoryMaster setIsDelete:[NSNumber numberWithBool:[[(NSDictionary*)[arrCategorys objectAtIndex:i] valueForKey:@"IsDeleted"] boolValue]]];
            [categoryMaster setIsActive:[NSNumber numberWithBool:[[(NSDictionary*)[arrCategorys objectAtIndex:i] valueForKey:@"Status"] boolValue]]];
        }
    }
	return [self commitChangesToDatabase];
}

-(BOOL)addProductDetailsWithProducts:(NSArray*)arrProducts
{
    NSError *error;
    for (int i=0; i<[arrProducts count]; i++) {
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSPredicate *predicate;
        predicate = [NSPredicate predicateWithFormat:@"(productId == %d)",[[(NSDictionary*)[arrProducts objectAtIndex:i] valueForKey:@"Id"] intValue]];
        [fetchRequest setPredicate:predicate];
        NSEntityDescription *entity;
        entity = [NSEntityDescription
                  entityForName:@"ProductMaster" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        //NSLog(@"%@",fetchRequest);
        
        NSArray *arrTemp  = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        if ([arrTemp count]>0) {
            
            ProductMaster *productMaster = [arrTemp objectAtIndex:0];
            [productMaster setProductName:[[arrProducts objectAtIndex:i] valueForKey:@"Name"]];
            [productMaster setProductImage:([[[arrProducts objectAtIndex:i] valueForKey:@"ProductImage"] isKindOfClass:[NSNull class]]?nil:[[arrProducts objectAtIndex:i] valueForKey:@"ProductImage"])];
            [productMaster setProductPrice:[NSNumber numberWithFloat:[[(NSDictionary*)[arrProducts objectAtIndex:i] valueForKey:@"Rate1"] floatValue]]];
            [productMaster setCategoryId:[NSNumber numberWithInt:[[(NSDictionary*)[arrProducts objectAtIndex:i] valueForKey:@"MenuSubGroupId"] intValue]]];
            [productMaster setSequenceNo:([[(NSDictionary*)[arrProducts objectAtIndex:i] valueForKey:@"SequenceNo"]isKindOfClass:[NSNull class]]?nil:[NSNumber numberWithInt:[[(NSDictionary*)[arrProducts objectAtIndex:i] valueForKey:@"SequenceNo"] intValue]])];
            [productMaster setOutletId:[NSNumber numberWithInt:[[(NSDictionary*)[arrProducts objectAtIndex:i] valueForKey:@"OutletId"] intValue]]];
            [productMaster setIsActive:[NSNumber numberWithBool:[[(NSDictionary*)[arrProducts objectAtIndex:i] valueForKey:@"IsActive"] boolValue]]];
            [productMaster setIsDelete:[NSNumber numberWithBool:[[(NSDictionary*)[arrProducts objectAtIndex:i] valueForKey:@"IsDeleted"] boolValue]]];
            [productMaster setIsHomeDeliverable:[NSNumber numberWithBool:[[(NSDictionary*)[arrProducts objectAtIndex:i] valueForKey:@"IsHomeDeliverable"] boolValue]]];
            [productMaster setIngrediants:[(NSDictionary*)[arrProducts objectAtIndex:i] valueForKey:@"Ingrediants"]];
        }
        else {
            
            ProductMaster *productMaster = (ProductMaster *)[NSEntityDescription insertNewObjectForEntityForName:@"ProductMaster" inManagedObjectContext:self.managedObjectContext];
            [productMaster setProductId:[NSNumber numberWithInt:[[(NSDictionary*)[arrProducts objectAtIndex:i] valueForKey:@"Id"] intValue]]];
            [productMaster setProductName:[[arrProducts objectAtIndex:i] valueForKey:@"Name"]];
            [productMaster setProductImage:([[[arrProducts objectAtIndex:i] valueForKey:@"ProductImage"] isKindOfClass:[NSNull class]]?nil:[[arrProducts objectAtIndex:i] valueForKey:@"ProductImage"])];
            [productMaster setProductPrice:[NSNumber numberWithInt:[[(NSDictionary*)[arrProducts objectAtIndex:i] valueForKey:@"Rate1"] floatValue]]];
            [productMaster setCategoryId:[NSNumber numberWithInt:[[(NSDictionary*)[arrProducts objectAtIndex:i] valueForKey:@"MenuSubGroupId"] intValue]]];
            [productMaster setSequenceNo:([[(NSDictionary*)[arrProducts objectAtIndex:i] valueForKey:@"SequenceNo"]isKindOfClass:[NSNull class]]?nil:[NSNumber numberWithInt:[[(NSDictionary*)[arrProducts objectAtIndex:i] valueForKey:@"SequenceNo"] intValue]])];
            [productMaster setOutletId:[NSNumber numberWithInt:[[(NSDictionary*)[arrProducts objectAtIndex:i] valueForKey:@"OutletId"] intValue]]];
            [productMaster setIsActive:[NSNumber numberWithBool:[[(NSDictionary*)[arrProducts objectAtIndex:i] valueForKey:@"IsActive"] boolValue]]];
            [productMaster setIsDelete:[NSNumber numberWithBool:[[(NSDictionary*)[arrProducts objectAtIndex:i] valueForKey:@"IsDeleted"] boolValue]]];
            [productMaster setIsHomeDeliverable:[NSNumber numberWithBool:[[(NSDictionary*)[arrProducts objectAtIndex:i] valueForKey:@"IsHomeDeliverable"] boolValue]]];
            [productMaster setIngrediants:[(NSDictionary*)[arrProducts objectAtIndex:i] valueForKey:@"Ingrediants"]];
        }
        
//        [self deleteRecordsOfTable:@"IngrediantDetails" forField:@"productId" withEqualityValue:[NSString stringWithFormat:@"%@",[(NSDictionary*)[arrProducts objectAtIndex:i] valueForKey:@"Id"]]];
//        [self addProductIngrediantsWithIngrediants:[[arrProducts objectAtIndex:i] valueForKey:@"IngrediantsArray"] forProductId:[[(NSDictionary*)[arrProducts objectAtIndex:i] valueForKey:@"Id"] intValue]] ;
    }
    return [self commitChangesToDatabase];
}

-(BOOL)addProductIngrediantsWithIngrediants:(NSArray*)arrProductsIngrediants forProductId:(int)productId
{
    for (int i=0; i<[arrProductsIngrediants count]; i++) {
        IngrediantDetails *ingrediantDetails = (IngrediantDetails *)[NSEntityDescription insertNewObjectForEntityForName:@"IngrediantDetails" inManagedObjectContext:self.managedObjectContext];
        [ingrediantDetails setIngrediantId:[NSNumber numberWithInt:(i+1)]];
        [ingrediantDetails setIngrediantName:[[arrProductsIngrediants objectAtIndex:i] valueForKey:@"Ingredient"]];
        [ingrediantDetails setProductId:[NSNumber numberWithInt:productId]];
    }
    return [self commitChangesToDatabase];
}

-(BOOL)addMenuDetailsWithMenuItems:(NSArray*)arrMenuItems
{
    NSError *error;
    for (int i=0; i<[arrMenuItems count]; i++) {
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSPredicate *predicate;
        predicate = [NSPredicate predicateWithFormat:@"(menuId == %d)",[[(NSDictionary*)[arrMenuItems objectAtIndex:i] valueForKey:@"inId"] intValue]];
        [fetchRequest setPredicate:predicate];
        NSEntityDescription *entity;
        entity = [NSEntityDescription
                  entityForName:@"MenuMaster" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSArray *arrTemp  = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        if ([arrTemp count]>0) {
            MenuMaster *menuMaster = [arrTemp objectAtIndex:0];
            [menuMaster setMenuName:[(NSDictionary*)[arrMenuItems objectAtIndex:i] valueForKey:@"vaMenuMobileName"]];
            [menuMaster setMenuTitle:[(NSDictionary*)[arrMenuItems objectAtIndex:i] valueForKey:@"vaMenuTitle"]];
            [menuMaster setMenuImageUrl:[(NSDictionary*)[arrMenuItems objectAtIndex:i] valueForKey:@"vaUrl"]];
            [menuMaster setMenuWebUrl:[[(NSDictionary*)[arrMenuItems objectAtIndex:i] valueForKey:@"vaMenuWebUrl"] isKindOfClass:[NSNull class]]?nil:[(NSDictionary*)[arrMenuItems objectAtIndex:i] valueForKey:@"vaMenuWebUrl"]];
            [menuMaster setSequenceNo:[NSNumber numberWithInt:[[(NSDictionary*)[arrMenuItems objectAtIndex:i] valueForKey:@"inSeqNo"] intValue]]];
            [menuMaster setIsActive:[NSNumber numberWithBool:[[(NSDictionary*)[arrMenuItems objectAtIndex:i] valueForKey:@"isActive"] boolValue]]];
            [menuMaster setIsDelete:[NSNumber numberWithBool:[[(NSDictionary*)[arrMenuItems objectAtIndex:i] valueForKey:@"IsDeleted"] boolValue]]];
        }
        else {
            MenuMaster *menuMaster = (MenuMaster *)[NSEntityDescription insertNewObjectForEntityForName:@"MenuMaster" inManagedObjectContext:self.managedObjectContext];
            [menuMaster setMenuId:[NSNumber numberWithInt:[[(NSDictionary*)[arrMenuItems objectAtIndex:i] valueForKey:@"inId"] intValue]]];
            [menuMaster setMenuName:[(NSDictionary*)[arrMenuItems objectAtIndex:i] valueForKey:@"vaMenuMobileName"]];
            [menuMaster setMenuTitle:[(NSDictionary*)[arrMenuItems objectAtIndex:i] valueForKey:@"vaMenuTitle"]];
            [menuMaster setMenuImageUrl:[(NSDictionary*)[arrMenuItems objectAtIndex:i] valueForKey:@"vaUrl"]];
            [menuMaster setMenuWebUrl:[[(NSDictionary*)[arrMenuItems objectAtIndex:i] valueForKey:@"vaMenuWebUrl"] isKindOfClass:[NSNull class]]?nil:[(NSDictionary*)[arrMenuItems objectAtIndex:i] valueForKey:@"vaMenuWebUrl"]];
            [menuMaster setSequenceNo:[NSNumber numberWithInt:[[(NSDictionary*)[arrMenuItems objectAtIndex:i] valueForKey:@"inSeqNo"] intValue]]];
            [menuMaster setIsActive:[NSNumber numberWithBool:[[(NSDictionary*)[arrMenuItems objectAtIndex:i] valueForKey:@"isActive"] boolValue]]];
            [menuMaster setIsDelete:[NSNumber numberWithBool:[[(NSDictionary*)[arrMenuItems objectAtIndex:i] valueForKey:@"IsDeleted"] boolValue]]];
        }
    }
	return [self commitChangesToDatabase];
}

-(BOOL)addPromoImageDetailsWithPromoImages:(NSArray*)arrPromoImages
{
    NSError *error;
    for (int i=0; i<[arrPromoImages count]; i++) {
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSPredicate *predicate;
        predicate = [NSPredicate predicateWithFormat:@"(promoImageId == %d)",[[(NSDictionary*)[arrPromoImages objectAtIndex:i] valueForKey:@"inId"] intValue]];
        [fetchRequest setPredicate:predicate];
        NSEntityDescription *entity;
        entity = [NSEntityDescription
                  entityForName:@"PromoImageDetails" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSArray *arrTemp  = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        if ([arrTemp count]>0) {
            PromoImageDetails *promoImageDetails = [arrTemp objectAtIndex:0];
            [promoImageDetails setPromoImageUrl:[[arrPromoImages objectAtIndex:i] valueForKey:@"vaImgUrl"]];
            [promoImageDetails setSequenceNo:[NSNumber numberWithInt:[[(NSDictionary*)[arrPromoImages objectAtIndex:i] valueForKey:@"inSeqNo"] intValue]]];
            [promoImageDetails setIsDelete:[NSNumber numberWithBool:[[(NSDictionary*)[arrPromoImages objectAtIndex:i] valueForKey:@"IsDeleted"] boolValue]]];
            [promoImageDetails setIsActive:[NSNumber numberWithBool:[[(NSDictionary*)[arrPromoImages objectAtIndex:i] valueForKey:@"isActive"] boolValue]]];
        }
        else {
            PromoImageDetails *promoImageDetails = (PromoImageDetails *)[NSEntityDescription insertNewObjectForEntityForName:@"PromoImageDetails" inManagedObjectContext:self.managedObjectContext];
            [promoImageDetails setPromoImageId:[NSNumber numberWithInt:[[(NSDictionary*)[arrPromoImages objectAtIndex:i] valueForKey:@"inId"] intValue]]];
            [promoImageDetails setPromoImageUrl:[[arrPromoImages objectAtIndex:i] valueForKey:@"vaImgUrl"]];
            [promoImageDetails setSequenceNo:[NSNumber numberWithInt:[[(NSDictionary*)[arrPromoImages objectAtIndex:i] valueForKey:@"inSeqNo"] intValue]]];
            [promoImageDetails setIsDelete:[NSNumber numberWithBool:[[(NSDictionary*)[arrPromoImages objectAtIndex:i] valueForKey:@"IsDeleted"] boolValue]]];
            [promoImageDetails setIsActive:[NSNumber numberWithBool:[[(NSDictionary*)[arrPromoImages objectAtIndex:i] valueForKey:@"isActive"] boolValue]]];
        }
    }
	return [self commitChangesToDatabase];
}

- (BOOL)addOutletDetailswithOutlets:(NSArray *)arrOutlets
{
    NSError *error;
    for (int i=0; i<[arrOutlets count]; i++) {
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSPredicate *predicate;
        predicate = [NSPredicate predicateWithFormat:@"(outletId == %d)",[[(NSDictionary*)[arrOutlets objectAtIndex:i] valueForKey:@"Id"] intValue]];
        [fetchRequest setPredicate:predicate];
        NSEntityDescription *entity;
        entity = [NSEntityDescription
                  entityForName:@"OutletMaster" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        //NSLog(@"%@",fetchRequest);
        NSArray *arrTemp  = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        if ([arrTemp count]>0)
        {
            OutletMaster *outletMaster = [arrTemp objectAtIndex:0];
            [outletMaster setOutletName:([[[arrOutlets objectAtIndex:i] valueForKey:@"Name"] isKindOfClass:[NSNull class]]?nil:[(NSDictionary*)[arrOutlets objectAtIndex:i] valueForKey:@"Name"])];
            [outletMaster setOutletAddress:([[[arrOutlets objectAtIndex:i] valueForKey:@"Address"] isKindOfClass:[NSNull class]]?nil:[(NSDictionary*)[arrOutlets objectAtIndex:i] valueForKey:@"Address"])];
            [outletMaster setOutletContactNo:([[[arrOutlets objectAtIndex:i] valueForKey:@"PhoneNo"] isKindOfClass:[NSNull class]]?nil:[(NSDictionary*)[arrOutlets objectAtIndex:i] valueForKey:@"PhoneNo"])];
            [outletMaster setOutletEmailId:([[[arrOutlets objectAtIndex:i] valueForKey:@"EmailId"] isKindOfClass:[NSNull class]]?nil:[(NSDictionary*)[arrOutlets objectAtIndex:i] valueForKey:@"EmailId"])];
            [outletMaster setLatitude:[NSNumber numberWithFloat:[[(NSDictionary*)[arrOutlets objectAtIndex:i] valueForKey:@"Latitude"] floatValue]]];
            [outletMaster setLongitude:[NSNumber numberWithFloat:[[(NSDictionary*)[arrOutlets objectAtIndex:i] valueForKey:@"Longitude"] floatValue]]];
        }
        else
        {
            OutletMaster *outletMaster = (OutletMaster *)[NSEntityDescription insertNewObjectForEntityForName:@"OutletMaster" inManagedObjectContext:self.managedObjectContext];
            [outletMaster setOutletId:[NSNumber numberWithInt:[[(NSDictionary*)[arrOutlets objectAtIndex:i] valueForKey:@"Id"] intValue]]];
            [outletMaster setOutletName:([[[arrOutlets objectAtIndex:i] valueForKey:@"Name"] isKindOfClass:[NSNull class]]?nil:[(NSDictionary*)[arrOutlets objectAtIndex:i] valueForKey:@"Name"])];
            [outletMaster setOutletAddress:([[[arrOutlets objectAtIndex:i] valueForKey:@"Address"] isKindOfClass:[NSNull class]]?nil:[(NSDictionary*)[arrOutlets objectAtIndex:i] valueForKey:@"Address"])];
            [outletMaster setOutletContactNo:([[[arrOutlets objectAtIndex:i] valueForKey:@"PhoneNo"] isKindOfClass:[NSNull class]]?nil:[(NSDictionary*)[arrOutlets objectAtIndex:i] valueForKey:@"PhoneNo"])];
            [outletMaster setOutletEmailId:([[[arrOutlets objectAtIndex:i] valueForKey:@"EmailId"] isKindOfClass:[NSNull class]]?nil:[(NSDictionary*)[arrOutlets objectAtIndex:i] valueForKey:@"EmailId"])];
            [outletMaster setLatitude:[NSNumber numberWithFloat:[[(NSDictionary*)[arrOutlets objectAtIndex:i] valueForKey:@"Latitude"] floatValue]]];
            [outletMaster setLongitude:[NSNumber numberWithFloat:[[(NSDictionary*)[arrOutlets objectAtIndex:i] valueForKey:@"Longitude"] floatValue]]];
            
        }
        
        if ([(NSArray*)[[arrOutlets objectAtIndex:i] valueForKey:@"PhotoUrlArray"] count] > 0) {
            [self addOutletDetailsWithOutletsImages:(NSArray*)[[arrOutlets objectAtIndex:i] valueForKey:@"PhotoUrlArray"] ForOutletId:[[arrOutlets objectAtIndex:i] valueForKey:@"Id"]];
        }
    }
    return [self commitChangesToDatabase];
}

- (BOOL)addOutletDetailsWithOutletsImages:(NSArray *)arrOutletImages ForOutletId:(NSString *)outletId
{
    NSError *error;
    for (int i=0; i<[arrOutletImages count]; i++) {
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSPredicate *predicate;
        predicate = [NSPredicate predicateWithFormat:@"(imageId == %d)",[[(NSDictionary*)[arrOutletImages objectAtIndex:i] valueForKey:@"Id"] intValue]];
        [fetchRequest setPredicate:predicate];
        NSEntityDescription *entity;
        entity = [NSEntityDescription
                  entityForName:@"OutletDetails" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        //NSLog(@"%@",fetchRequest);
        NSArray *arrTemp  = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        if ([arrTemp count]>0)
        {
            OutletDetails *outletDetails = [arrTemp objectAtIndex:0];
            [outletDetails setOutletId:[NSNumber numberWithInt:[outletId intValue]]];
            [outletDetails setImageId:[NSNumber numberWithInt:[[(NSDictionary*)[arrOutletImages objectAtIndex:i] valueForKey:@"Id"] intValue]]];
            [outletDetails setImageUrl:[[arrOutletImages objectAtIndex:i] valueForKey:@"ImageURL"]];
            [outletDetails setSequenceNo:[NSNumber numberWithInt:[[(NSDictionary*)[arrOutletImages objectAtIndex:i] valueForKey:@"Id"] intValue]]];
        }
        else
        {
            OutletDetails *outletDetails = (OutletDetails *)[NSEntityDescription insertNewObjectForEntityForName:@"OutletDetails" inManagedObjectContext:self.managedObjectContext];
            [outletDetails setOutletId:[NSNumber numberWithInt:[outletId intValue]]];
            [outletDetails setImageId:[NSNumber numberWithInt:[[(NSDictionary*)[arrOutletImages objectAtIndex:i] valueForKey:@"Id"] intValue]]];
            [outletDetails setSequenceNo:[NSNumber numberWithInt:[[(NSDictionary*)[arrOutletImages objectAtIndex:i] valueForKey:@"Id"] intValue]]];
            [outletDetails setImageUrl:([[[arrOutletImages objectAtIndex:i] valueForKey:@"ImageURL"] isKindOfClass:[NSNull class]]?nil:[(NSDictionary*)[arrOutletImages objectAtIndex:i] valueForKey:@"ImageURL"])];
            
        }
    }
    return TRUE;
}

-(BOOL)addNotificationMasterWithNotifications:(NSArray *)arrNotifications
{
    NSError *error;
    for (int i=0; i<[arrNotifications count]; i++) {
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSPredicate *predicate;
        predicate = [NSPredicate predicateWithFormat:@"(notificationId == %d)",[[(NSDictionary*)[arrNotifications objectAtIndex:i] valueForKey:@"inId"] intValue]];
        [fetchRequest setPredicate:predicate];
        NSEntityDescription *entity;
        entity = [NSEntityDescription
                  entityForName:@"NotificationMaster" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        //NSLog(@"%@",fetchRequest);
        NSArray *arrTemp  = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        if ([arrTemp count]>0) {
            NotificationMaster *notificationMaster = [arrTemp objectAtIndex:0];
            [notificationMaster setNotificationId:[NSNumber numberWithInt:[[(NSDictionary*)[arrNotifications objectAtIndex:i] valueForKey:@"inId"] intValue]]];
            [notificationMaster setNotificationTitle:[[arrNotifications objectAtIndex:i] valueForKey:@"vaNotificationTitle"]];
            [notificationMaster setNotificationTime:[DATETIME_FORMATTER_WS dateFromString:[[arrNotifications objectAtIndex:i] valueForKey:@"dtSendDtTime"]]];
            [notificationMaster setNotificationDescription:[[arrNotifications objectAtIndex:i] valueForKey:@"txNotificationDesc"]];
            [notificationMaster setNotificationImageUrl:[[arrNotifications objectAtIndex:i] valueForKey:@"vaImageUrl"]];
        }
        else {
            NotificationMaster *notificationMaster = (NotificationMaster *)[NSEntityDescription insertNewObjectForEntityForName:@"NotificationMaster" inManagedObjectContext:self.managedObjectContext];
            [notificationMaster setNotificationId:[NSNumber numberWithInt:[[(NSDictionary*)[arrNotifications objectAtIndex:i] valueForKey:@"inId"] intValue]]];
            [notificationMaster setNotificationTitle:[[arrNotifications objectAtIndex:i] valueForKey:@"vaNotificationTitle"]];
            [notificationMaster setNotificationTime:[DATETIME_FORMATTER_WS dateFromString:[[arrNotifications objectAtIndex:i] valueForKey:@"dtSendDtTime"]]];
            [notificationMaster setNotificationDescription:[[arrNotifications objectAtIndex:i] valueForKey:@"txNotificationDesc"]];
            [notificationMaster setNotificationImageUrl:[[arrNotifications objectAtIndex:i] valueForKey:@"vaImageUrl"]];
            [notificationMaster setIsRead:[NSNumber numberWithBool:TRUE]];
        }
        
//        NotificationMaster *notificationMaster = (NotificationMaster *)[NSEntityDescription insertNewObjectForEntityForName:@"NotificationMaster" inManagedObjectContext:self.managedObjectContext];
//        [notificationMaster setNotificationId:[NSNumber numberWithInt:[[(NSDictionary*)[arrNotifications objectAtIndex:i] valueForKey:@"inId"] intValue]]];
//        [notificationMaster setNotificationTitle:[[arrNotifications objectAtIndex:i] valueForKey:@"vaNotificationTitle"]];
//        [notificationMaster setNotificationTime:[DATETIME_FORMATTER_WS dateFromString:[[arrNotifications objectAtIndex:i] valueForKey:@"dtNotificationDtTime"]]];
//        [notificationMaster setNotificationDescription:[[arrNotifications objectAtIndex:i] valueForKey:@"txNotificationDesc"]];
//        [notificationMaster setNotificationImageUrl:[[arrNotifications objectAtIndex:i] valueForKey:@"vaImageUrl"]];
    }
    return [self commitChangesToDatabase];
}

-(BOOL)addRewardsMasterWithRewards:(NSArray *)arrRewards
{
    NSError *error;
    for (int i=0; i<[arrRewards count]; i++) {
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSPredicate *predicate;
        predicate = [NSPredicate predicateWithFormat:@"(billNo == %d)",[[(NSDictionary*)[arrRewards objectAtIndex:i] valueForKey:@"BillNo"] intValue]];
        [fetchRequest setPredicate:predicate];
        NSEntityDescription *entity;
        entity = [NSEntityDescription
                  entityForName:@"RewardsMaster" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        //NSLog(@"%@",fetchRequest);
        NSArray *arrTemp  = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        if ([arrTemp count]>0)
        {
            RewardsMaster *rewardsMaster = [arrTemp objectAtIndex:0];
            [rewardsMaster setBillDate:[DATETIME_FORMATTER_WS dateFromString:[(NSDictionary*)[arrRewards objectAtIndex:i] valueForKey:@"BillDate"]]];
            [rewardsMaster setExpiryDate:[DATETIME_FORMATTER_WS dateFromString:[(NSDictionary*)[arrRewards objectAtIndex:i] valueForKey:@"ExpiryDate"]]];
            [rewardsMaster setRewardAmount:[NSNumber numberWithFloat:[[(NSDictionary*)[arrRewards objectAtIndex:i] valueForKey:@"RedeemAmount"] floatValue]]];
            [rewardsMaster setEarnedRewardAmount:[NSNumber numberWithFloat:[[(NSDictionary*)[arrRewards objectAtIndex:i] valueForKey:@"EarnedRedeemAmount"] floatValue]]];
        }
        else
        {
            RewardsMaster *rewardsMaster = (RewardsMaster *)[NSEntityDescription insertNewObjectForEntityForName:@"RewardsMaster" inManagedObjectContext:self.managedObjectContext];
            [rewardsMaster setBillNo:[NSNumber numberWithInt:[[(NSDictionary*)[arrRewards objectAtIndex:i] valueForKey:@"BillNo"] intValue]]];
            [rewardsMaster setBillDate:[DATETIME_FORMATTER_WS dateFromString:[(NSDictionary*)[arrRewards objectAtIndex:i] valueForKey:@"BillDate"]]];
            [rewardsMaster setExpiryDate:[DATETIME_FORMATTER_WS dateFromString:[(NSDictionary*)[arrRewards objectAtIndex:i] valueForKey:@"ExpiryDate"]]];
            [rewardsMaster setRewardAmount:[NSNumber numberWithFloat:[[(NSDictionary*)[arrRewards objectAtIndex:i] valueForKey:@"RedeemAmount"] floatValue]]];
            [rewardsMaster setEarnedRewardAmount:[NSNumber numberWithFloat:[[(NSDictionary*)[arrRewards objectAtIndex:i] valueForKey:@"EarnedRedeemAmount"] floatValue]]];
        }
    }
    return [self commitChangesToDatabase];
}

-(BOOL)addOrderHistoryWithWOrders:(NSArray *)arrOrders
{
    
    NSLog(@"Array Orders : %@",arrOrders);
    
    NSError *error;
    for (int i=0; i<[arrOrders count]; i++)
    {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSPredicate *predicate;
        predicate = [NSPredicate predicateWithFormat:@"(orderId == %d)",[[(NSDictionary*)[arrOrders objectAtIndex:i] valueForKey:@"inId"] intValue]];
        [fetchRequest setPredicate:predicate];
        NSEntityDescription *entity;
        entity = [NSEntityDescription
                  entityForName:@"OrderHistory" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        //NSLog(@"%@",fetchRequest);
        NSArray *arrTemp  = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        if ([arrTemp count]>0)
        {
            OrderHistory *orderHistory = [arrTemp objectAtIndex:0];
            [orderHistory setTotalPrice:[NSNumber numberWithFloat:[[(NSDictionary*)[arrOrders objectAtIndex:i] valueForKey:@"dcTotPrice"] floatValue]]];
            [orderHistory setTotalServiceTax:[NSNumber numberWithFloat:[[(NSDictionary*)[arrOrders objectAtIndex:i] valueForKey:@"dcTotServiceTax"] floatValue]]];
            [orderHistory setPayRewardPts:([[[arrOrders objectAtIndex:i] valueForKey:@"dcPayRewardPts"] isKindOfClass:[NSNull class]]?nil:[NSNumber numberWithFloat:[[(NSDictionary*)[arrOrders objectAtIndex:i] valueForKey:@"dcPayRewardPts"] floatValue]])];
            
            [orderHistory setEarnRewardPts:([[[arrOrders objectAtIndex:i] valueForKey:@"EarnRewardPoints"] isKindOfClass:[NSNull class]]?nil:[NSNumber numberWithFloat:[[(NSDictionary*)[arrOrders objectAtIndex:i] valueForKey:@"EarnRewardPoints"] floatValue]])];
            
            [orderHistory setPayRewardPtsStatus:([[[arrOrders objectAtIndex:i] valueForKey:@"inPayRewardPtsStatus"] isKindOfClass:[NSNull class]]?nil:[NSNumber numberWithBool:[[(NSDictionary*)[arrOrders objectAtIndex:i] valueForKey:@"inPayRewardPtsStatus"] boolValue]])];
            [orderHistory setOrderStatus:([[[arrOrders objectAtIndex:i] valueForKey:@"vaOrderStatus"] isKindOfClass:[NSNull class]]?nil:[(NSDictionary*)[arrOrders objectAtIndex:i] valueForKey:@"vaOrderStatus"])];
            [orderHistory setCouponcode:([[[arrOrders objectAtIndex:i] valueForKey:@"couponcode"] isKindOfClass:[NSNull class]]?nil:[(NSDictionary*)[arrOrders objectAtIndex:i] valueForKey:@"couponcode"])];
            [orderHistory setDiscountedValue:([[[arrOrders objectAtIndex:i] valueForKey:@"disval"] isKindOfClass:[NSNull class]]?nil:[NSNumber numberWithFloat:[[(NSDictionary*)[arrOrders objectAtIndex:i] valueForKey:@"disval"] floatValue]])];
            [orderHistory setDiscountType:([[[arrOrders objectAtIndex:i] valueForKey:@"disparam"] isKindOfClass:[NSNull class]]?nil:[(NSDictionary*)[arrOrders objectAtIndex:i] valueForKey:@"disparam"])];
            
            [orderHistory setCouponValidFromDate:([[[arrOrders objectAtIndex:i] valueForKey:@"validityfrdt"] isEqualToString:@""]?nil:[DATE_FORMATTER_WS dateFromString:[(NSDictionary*)[arrOrders objectAtIndex:i] valueForKey:@"validityfrdt"]])];
            [orderHistory setCouponValidToDate:([[[arrOrders objectAtIndex:i] valueForKey:@"validitytodt"] isEqualToString:@""]?nil:[DATE_FORMATTER_WS dateFromString:[(NSDictionary*)[arrOrders objectAtIndex:i] valueForKey:@"validitytodt"]])];
            
            [orderHistory setCouponValidForMinAmount:([[[arrOrders objectAtIndex:i] valueForKey:@"minamt"] isKindOfClass:[NSNull class]]?nil:[NSNumber numberWithFloat:[[(NSDictionary*)[arrOrders objectAtIndex:i] valueForKey:@"minamt"] floatValue]])];
            [orderHistory setCouponValidInBranchID:([[[arrOrders objectAtIndex:i] valueForKey:@"validbranch_id"] isKindOfClass:[NSNull class]]?nil:[(NSDictionary*)[arrOrders objectAtIndex:i] valueForKey:@"validbranch_id"])];
            
            [orderHistory setDeliveryCharge:([[[arrOrders objectAtIndex:i] valueForKey:@"disval"] isKindOfClass:[NSNull class]]?nil:[NSNumber numberWithFloat:[[(NSDictionary*)[arrOrders objectAtIndex:i] valueForKey:@"dcDeliveryCharge"] floatValue]])];
            
            //add car table, customername, customer mobile,
            [orderHistory setCarTableNo:([[[arrOrders objectAtIndex:i] valueForKey:@"CarTable"] isKindOfClass:[NSNull class]]?nil:[(NSDictionary*)[arrOrders objectAtIndex:i] valueForKey:@"CarTable"])];
            
            [orderHistory setIsBookedStatus:([[[arrOrders objectAtIndex:i] valueForKey:@"isBookedStatus"] isKindOfClass:[NSNull class]]?nil:[(NSDictionary*)[arrOrders objectAtIndex:i] valueForKey:@"isBookedStatus"])];
            
            [orderHistory setCustomerName:([[[arrOrders objectAtIndex:i] valueForKey:@"customerName"] isKindOfClass:[NSNull class]]?nil:[(NSDictionary*)[arrOrders objectAtIndex:i] valueForKey:@"customerName"])];
            
             [orderHistory setCustomerMobileNo:([[[arrOrders objectAtIndex:i] valueForKey:@"inMobile"] isKindOfClass:[NSNull class]]?nil:[(NSDictionary*)[arrOrders objectAtIndex:i] valueForKey:@"inMobile"])];
            
        }
        else
        {
            OrderHistory *orderHistory = (OrderHistory *)[NSEntityDescription insertNewObjectForEntityForName:@"OrderHistory" inManagedObjectContext:self.managedObjectContext];
            
            [orderHistory setOrderId:[NSNumber numberWithInt:[[(NSDictionary*)[arrOrders objectAtIndex:i] valueForKey:@"inId"] intValue]]];
            [orderHistory setOrderDate: [DATETIME_FORMATTER_WS dateFromString:[(NSDictionary*)[arrOrders objectAtIndex:i] valueForKey:@"dtOrderDate"]]];
            [orderHistory setTotalPrice:[NSNumber numberWithFloat:[[(NSDictionary*)[arrOrders objectAtIndex:i] valueForKey:@"dcTotPrice"] floatValue]]];
            [orderHistory setTotalServiceTax:[NSNumber numberWithFloat:[[(NSDictionary*)[arrOrders objectAtIndex:i] valueForKey:@"dcTotServiceTax"] floatValue]]];

            
            [orderHistory setPayRewardPts:([[[arrOrders objectAtIndex:i] valueForKey:@"dcPayRewardPts"] isKindOfClass:[NSNull class]]?nil:[NSNumber numberWithFloat:[[(NSDictionary*)[arrOrders objectAtIndex:i] valueForKey:@"dcPayRewardPts"] floatValue]])];
            [orderHistory setEarnRewardPts:([[[arrOrders objectAtIndex:i] valueForKey:@"EarnRewardPoints"] isKindOfClass:[NSNull class]]?nil:[NSNumber numberWithFloat:[[(NSDictionary*)[arrOrders objectAtIndex:i] valueForKey:@"EarnRewardPoints"] floatValue]])];
            [orderHistory setPayRewardPtsStatus:([[[arrOrders objectAtIndex:i] valueForKey:@"inPayRewardPtsStatus"] isKindOfClass:[NSNull class]]?nil:[NSNumber numberWithBool:[[(NSDictionary*)[arrOrders objectAtIndex:i] valueForKey:@"inPayRewardPtsStatus"] boolValue]])];
            [orderHistory setOrderStatus:([[[arrOrders objectAtIndex:i] valueForKey:@"vaOrderStatus"] isKindOfClass:[NSNull class]]?nil:[(NSDictionary*)[arrOrders objectAtIndex:i] valueForKey:@"vaOrderStatus"])];
            [orderHistory setCouponcode:([[[arrOrders objectAtIndex:i] valueForKey:@"couponcode"] isKindOfClass:[NSNull class]]?nil:[(NSDictionary*)[arrOrders objectAtIndex:i] valueForKey:@"couponcode"])];
            [orderHistory setDiscountedValue:([[[arrOrders objectAtIndex:i] valueForKey:@"disval"] isKindOfClass:[NSNull class]]?nil:[NSNumber numberWithFloat:[[(NSDictionary*)[arrOrders objectAtIndex:i] valueForKey:@"disval"] floatValue]])];
            [orderHistory setDiscountType:([[[arrOrders objectAtIndex:i] valueForKey:@"disparam"] isKindOfClass:[NSNull class]]?nil:[(NSDictionary*)[arrOrders objectAtIndex:i] valueForKey:@"disparam"])];
            
            [orderHistory setCouponValidFromDate:([[[arrOrders objectAtIndex:i] valueForKey:@"validityfrdt"] isEqualToString:@""]?nil:[DATE_FORMATTER_WS dateFromString:[(NSDictionary*)[arrOrders objectAtIndex:i] valueForKey:@"validityfrdt"]])];
            [orderHistory setCouponValidToDate:([[[arrOrders objectAtIndex:i] valueForKey:@"validitytodt"] isEqualToString:@""]?nil:[DATE_FORMATTER_WS dateFromString:[(NSDictionary*)[arrOrders objectAtIndex:i] valueForKey:@"validitytodt"]])];
            
            [orderHistory setCouponValidForMinAmount:([[[arrOrders objectAtIndex:i] valueForKey:@"minamt"] isKindOfClass:[NSNull class]]?nil:[NSNumber numberWithFloat:[[(NSDictionary*)[arrOrders objectAtIndex:i] valueForKey:@"minamt"] floatValue]])];
            [orderHistory setCouponValidInBranchID:([[[arrOrders objectAtIndex:i] valueForKey:@"validbranch_id"] isKindOfClass:[NSNull class]]?nil:[(NSDictionary*)[arrOrders objectAtIndex:i] valueForKey:@"validbranch_id"])];
            
            [orderHistory setDeliveryCharge:([[[arrOrders objectAtIndex:i] valueForKey:@"disval"] isKindOfClass:[NSNull class]]?nil:[NSNumber numberWithFloat:[[(NSDictionary*)[arrOrders objectAtIndex:i] valueForKey:@"dcDeliveryCharge"] floatValue]])];
            
            //add car table, customername, customer mobile,
            [orderHistory setCarTableNo:([[[arrOrders objectAtIndex:i] valueForKey:@"CarTable"] isKindOfClass:[NSNull class]]?nil:[(NSDictionary*)[arrOrders objectAtIndex:i] valueForKey:@"CarTable"])];
            
            [orderHistory setIsBookedStatus:([[[arrOrders objectAtIndex:i] valueForKey:@"isBookedStatus"] isKindOfClass:[NSNull class]]?nil:[(NSDictionary*)[arrOrders objectAtIndex:i] valueForKey:@"isBookedStatus"])];
            
            [orderHistory setCustomerName:([[[arrOrders objectAtIndex:i] valueForKey:@"customerName"] isKindOfClass:[NSNull class]]?nil:[(NSDictionary*)[arrOrders objectAtIndex:i] valueForKey:@"customerName"])];
            
            [orderHistory setCustomerMobileNo:([[[arrOrders objectAtIndex:i] valueForKey:@"inMobile"] isKindOfClass:[NSNull class]]?nil:[(NSDictionary*)[arrOrders objectAtIndex:i] valueForKey:@"inMobile"])];
        }
        
        [self addOrderHistoryDetailsWithWOrderDetails:[[arrOrders objectAtIndex:i] valueForKey:@"ProductArray"]];
        
    }
    
    return [self commitChangesToDatabase];
}

-(BOOL)addOrderHistoryDetailsWithWOrderDetails:(NSArray *)arrOrderDetails
{
    NSError *error;
    for (int i=0; i<[arrOrderDetails count]; i++) {
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSPredicate *predicate;
        predicate = [NSPredicate predicateWithFormat:@"(orderHistoryDetailsId == %d)",[[(NSDictionary*)[arrOrderDetails objectAtIndex:i] valueForKey:@"inId"] intValue]];
        [fetchRequest setPredicate:predicate];
        NSEntityDescription *entity;
        entity = [NSEntityDescription
                  entityForName:@"OrderHistoryDetails" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
//        //NSLog(@"%@",fetchRequest);
        NSArray *arrTemp  = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        if ([arrTemp count]>0)
        {
            OrderHistoryDetails *orderHistoryDetails = [arrTemp objectAtIndex:0];
            [orderHistoryDetails setOrderId:[NSNumber numberWithInt:[[(NSDictionary*)[arrOrderDetails objectAtIndex:i] valueForKey:@"inOrderId"] intValue]]];
            [orderHistoryDetails setProductId:[NSNumber numberWithInt:[[(NSDictionary*)[arrOrderDetails objectAtIndex:i] valueForKey:@"inProductId"] intValue]]];
            [orderHistoryDetails setProductQuantity:[NSNumber numberWithInt:[[(NSDictionary*)[arrOrderDetails objectAtIndex:i] valueForKey:@"inProductQty"] intValue]]];
            [orderHistoryDetails setProductPrice:[NSNumber numberWithFloat:[[(NSDictionary*)[arrOrderDetails objectAtIndex:i] valueForKey:@"dcProductPrice"] floatValue]]];
            if ([(NSDictionary*)[arrOrderDetails objectAtIndex:i] valueForKey:@"ProductName"]) {
                [orderHistoryDetails setProductName:[(NSDictionary*)[arrOrderDetails objectAtIndex:i] valueForKey:@"ProductName"]];
            }
            else {
                [orderHistoryDetails setProductName:@""];
            }
        }
        else
        {
            OrderHistoryDetails *orderHistoryDetails = (OrderHistoryDetails *)[NSEntityDescription insertNewObjectForEntityForName:@"OrderHistoryDetails" inManagedObjectContext:self.managedObjectContext];
            [orderHistoryDetails setOrderHistoryDetailsId:[NSNumber numberWithInt:[[(NSDictionary*)[arrOrderDetails objectAtIndex:i] valueForKey:@"inId"] intValue]]];
            [orderHistoryDetails setOrderId:[NSNumber numberWithInt:[[(NSDictionary*)[arrOrderDetails objectAtIndex:i] valueForKey:@"inOrderId"] intValue]]];
            [orderHistoryDetails setProductId:[NSNumber numberWithInt:[[(NSDictionary*)[arrOrderDetails objectAtIndex:i] valueForKey:@"inProductId"] intValue]]];
            [orderHistoryDetails setProductQuantity:[NSNumber numberWithInt:[[(NSDictionary*)[arrOrderDetails objectAtIndex:i] valueForKey:@"inProductQty"] intValue]]];
            [orderHistoryDetails setProductPrice:[NSNumber numberWithFloat:[[(NSDictionary*)[arrOrderDetails objectAtIndex:i] valueForKey:@"dcProductPrice"] floatValue]]];
            if ([(NSDictionary*)[arrOrderDetails objectAtIndex:i] valueForKey:@"ProductName"]) {
                [orderHistoryDetails setProductName:[(NSDictionary*)[arrOrderDetails objectAtIndex:i] valueForKey:@"ProductName"]];
             }
             else {
                 [orderHistoryDetails setProductName:@""];
             }
        }
    }
    return YES;
}

-(BOOL)addShippingDetailsWithAddresses:(NSArray*)arrAddresses withCommit:(BOOL)commit
{
    NSError *error;
    for (int i=0; i<[arrAddresses count]; i++) {
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSPredicate *predicate;
        predicate = [NSPredicate predicateWithFormat:@"(shippingId == %d)",[[(NSDictionary*)[arrAddresses objectAtIndex:i] valueForKey:@"inId"] intValue]];
        [fetchRequest setPredicate:predicate];
        NSEntityDescription *entity;
        entity = [NSEntityDescription
                  entityForName:@"ShippingDetails" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSArray *arrTemp  = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        if ([arrTemp count]>0) {
            ShippingDetails *shippingDetails = [arrTemp objectAtIndex:0];
            [shippingDetails setShippingAddress:[[arrAddresses objectAtIndex:i] valueForKey:@"txShippingAddress"]];
            [shippingDetails setContactNo:([[[arrAddresses objectAtIndex:i] valueForKey:@"phoneNumber"] isKindOfClass:[NSNull class]]?nil:[(NSDictionary*)[arrAddresses objectAtIndex:i] valueForKey:@"phoneNumber"])];
        }
        else {
            ShippingDetails *shippingDetails = (ShippingDetails *)[NSEntityDescription insertNewObjectForEntityForName:@"ShippingDetails" inManagedObjectContext:self.managedObjectContext];
            [shippingDetails setShippingId:[NSNumber numberWithInt:[[(NSDictionary*)[arrAddresses objectAtIndex:i] valueForKey:@"inId"] intValue]]];
            [shippingDetails setShippingAddress:[[arrAddresses objectAtIndex:i] valueForKey:@"txShippingAddress"]];
            [shippingDetails setContactNo:([[[arrAddresses objectAtIndex:i] valueForKey:@"phoneNumber"] isKindOfClass:[NSNull class]]?nil:[(NSDictionary*)[arrAddresses objectAtIndex:i] valueForKey:@"phoneNumber"])];
        }
    }
    if (commit) {
        return [self commitChangesToDatabase];
    }
    else {
        return TRUE;
    }
}

- (BOOL)addProFileDetailsWithDictionary:(NSDictionary *)dictDetails
{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSPredicate *predicate;
    //NSLog(@"inid %@",[dictDetails valueForKey:@"inId"]);
    predicate = [NSPredicate predicateWithFormat:@"(clientId == %d)",[[dictDetails valueForKey:@"inId"] intValue]];
    [fetchRequest setPredicate:predicate];
    NSEntityDescription *entity;
    entity = [NSEntityDescription
              entityForName:@"ClientMaster" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *arrTemp = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    if ([arrTemp count]>0) //if already found profile
    {
        ClientMaster *clientMaster = [arrTemp objectAtIndex:0];
        [clientMaster setAddress:[dictDetails valueForKey:@"vaAddress"]];
        [clientMaster setAnniversaryDate:[DATETIME_FORMATTER_WS  dateFromString:[dictDetails valueForKey:@"anniversary"]]];
        [clientMaster setBirthDate:[DATETIME_FORMATTER_WS  dateFromString:[dictDetails valueForKey:@"dob"]]];
        [clientMaster setEmailId:[dictDetails valueForKey:@"vaEmail"]];
        
        if (clientMaster.imageUrl != [dictDetails valueForKey:@"profilepic"]) {
            [clientMaster setImageUrl:[dictDetails valueForKey:@"profilepic"]];
            [clientMaster setImagePath:@""];
        }
        else {
            [clientMaster setImageUrl:[dictDetails valueForKey:@"profilepic"]];
            [clientMaster setImagePath:[dictDetails valueForKey:@"imagePath"]];
        }
        [clientMaster setMobileNo:[dictDetails valueForKey:@"inMobile"]];
        [clientMaster setName:[dictDetails valueForKey:@"vaFirstname"]];
        [clientMaster setSurName:[dictDetails valueForKey:@"vaLastname"]];
        [clientMaster setAlterMobileNo:[dictDetails valueForKey:@"vaPhone1"]];
        [clientMaster setGender:[dictDetails valueForKey:@"vaSex"]];
        
        //inId
        //vaFirstname
        //vaLastname
        //dob
        //anniversary
        //vaAddress
        //vaCity
        //vaEmail
        //vaPhone1
        //profilepic //imageurl
        //ShippingAddArray
    }
    else {
        ClientMaster *clientMaster = (ClientMaster *) [NSEntityDescription insertNewObjectForEntityForName:@"ClientMaster" inManagedObjectContext:self.managedObjectContext];
        [clientMaster setClientId:[NSNumber numberWithInt:[[dictDetails valueForKey:@"inId"] intValue]]];
        [clientMaster setAddress:[dictDetails valueForKey:@"vaAddress"]];
        [clientMaster setAnniversaryDate:[DATETIME_FORMATTER_WS  dateFromString:[dictDetails valueForKey:@"anniversary"]]];
        [clientMaster setBirthDate:[DATETIME_FORMATTER_WS  dateFromString:[dictDetails valueForKey:@"dob"]]];
        [clientMaster setEmailId:[dictDetails valueForKey:@"vaEmail"]];
        
        if (clientMaster.imageUrl != [dictDetails valueForKey:@"profilepic"]) {
            [clientMaster setImageUrl:[dictDetails valueForKey:@"profilepic"]];
            [clientMaster setImagePath:@""];
        }
        else {
            [clientMaster setImageUrl:[dictDetails valueForKey:@"profilepic"]];
            [clientMaster setImagePath:[dictDetails valueForKey:@"imagePath"]];
        }
        [clientMaster setMobileNo:[dictDetails valueForKey:@"inMobile"]];
        [clientMaster setName:[dictDetails valueForKey:@"vaFirstname"]];
        [clientMaster setSurName:[dictDetails valueForKey:@"vaLastname"]];
        [clientMaster setAlterMobileNo:[dictDetails valueForKey:@"vaPhone1"]];
        [clientMaster setGender:[dictDetails valueForKey:@"vaSex"]];
    }
    
    [self addShippingDetailsWithAddresses:[dictDetails valueForKey:@"ShippingAddArray"] withCommit:NO];
    
    return [self commitChangesToDatabase];
}

-(BOOL)addSettingDetails:(NSDictionary*)dictDetails;
{
    SettingDetails *settingDetails = (SettingDetails *)[NSEntityDescription insertNewObjectForEntityForName:@"SettingDetails" inManagedObjectContext:self.managedObjectContext];
    [settingDetails setServiceTax:[NSNumber numberWithFloat:[[dictDetails valueForKey:@"getServiceTax"] floatValue]]];
    [settingDetails setDeliveryCharge:[NSNumber numberWithFloat:[[dictDetails valueForKey:@"deliverycharge"] floatValue]]];
    [settingDetails setMinOrderAmount:[NSNumber numberWithFloat:[[dictDetails valueForKey:@"minOrderAmt"] floatValue]]];
    return [self commitChangesToDatabase];
}

-(BOOL)addAboutUsDetails:(NSArray*)arrAboutUsDetails
{
    NSError *error;
    for (int i=0; i<[arrAboutUsDetails count]; i++)
    {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSPredicate *predicate;
        predicate = [NSPredicate predicateWithFormat:@"(infoId == %d)",[[(NSDictionary*)[arrAboutUsDetails objectAtIndex:i] valueForKey:@"inId"] intValue]];
        [fetchRequest setPredicate:predicate];
        NSEntityDescription *entity;
        entity = [NSEntityDescription
                  entityForName:@"AboutUsDetails" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSArray *arrTemp  = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        if ([arrTemp count]>0)
        {
            AboutUsDetails *aboutUsDetails = [arrTemp objectAtIndex:0];
            [aboutUsDetails setInfoPageTitle:[[arrAboutUsDetails objectAtIndex:i] valueForKey:@"vaPageTitle"]];
            [aboutUsDetails setInfoPageDescription:[[arrAboutUsDetails objectAtIndex:i] valueForKey:@"txPageDesc"]];
            [aboutUsDetails setIsDelete:[NSNumber numberWithBool:[[(NSDictionary*)[arrAboutUsDetails objectAtIndex:i] valueForKey:@"IsDeleted"] boolValue]]];
        }
        else
        {
            AboutUsDetails *aboutUsDetails = (AboutUsDetails *)[NSEntityDescription insertNewObjectForEntityForName:@"AboutUsDetails" inManagedObjectContext:self.managedObjectContext];
            [aboutUsDetails setInfoId:[NSNumber numberWithInt:[[(NSDictionary*)[arrAboutUsDetails objectAtIndex:i] valueForKey:@"inId"] intValue]]];
            [aboutUsDetails setInfoPageTitle:[[arrAboutUsDetails objectAtIndex:i] valueForKey:@"vaPageTitle"]];
            [aboutUsDetails setInfoPageDescription:[[arrAboutUsDetails objectAtIndex:i] valueForKey:@"txPageDesc"]];
            [aboutUsDetails setIsDelete:[NSNumber numberWithBool:[[(NSDictionary*)[arrAboutUsDetails objectAtIndex:i] valueForKey:@"IsDeleted"] boolValue]]];
        }
    }
    return [self commitChangesToDatabase];
}

-(BOOL)addOrderDetailsWithProduct:(ProductMaster*)productMaster
{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"(productId = %d)",[productMaster.productId intValue]];
    [fetchRequest setPredicate:predicate];
    NSEntityDescription *entity;
    entity = [NSEntityDescription
              entityForName:@"OrderDetails" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSArray *arrTemp  = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if ([arrTemp count]>0) {
        OrderDetails *orderDetails = [arrTemp objectAtIndex:0];
        [orderDetails setProductQuantity:[NSNumber numberWithInt:([orderDetails.productQuantity intValue] +[productMaster.quantity intValue])]];
    }
    else {
        OrderDetails *orderDetails = (OrderDetails *)[NSEntityDescription insertNewObjectForEntityForName:@"OrderDetails" inManagedObjectContext:self.managedObjectContext];
        [orderDetails setProductId:productMaster.productId];
        [orderDetails setProductQuantity:productMaster.quantity];
    }
	return [self commitChangesToDatabase];
}

#pragma mark -
#pragma mark update queries

-(BOOL)setProductQuantityToZero {
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity;
    entity = [NSEntityDescription
              entityForName:@"ProductMaster" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"(quantity > 0)"];
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray *arrTemp = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    if ([arrTemp count] != 0)
    {
        for (int i=0; i<[arrTemp count]; i++) {
            ProductMaster *productMaster = [arrTemp objectAtIndex:i];
            [productMaster setQuantity:[NSNumber numberWithInt:0]];
        }
        return [self commitChangesToDatabase];
    }
    else
    {
        return NO;
    }
}

-(BOOL)updateProductDetailsWithProductDetails:(ProductMaster*)productMaster //update quantity
{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"(productId = %d)",[productMaster.productId intValue]];
    [fetchRequest setPredicate:predicate];
    NSEntityDescription *entity;
    entity = [NSEntityDescription
              entityForName:@"ProductMaster" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSArray *arrTemp  = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if ([arrTemp count]>0)
    {
        ProductMaster *productMaster = [arrTemp objectAtIndex:0];
        [productMaster setQuantity:productMaster.quantity];
    }
	return [self commitChangesToDatabase];
}

-(BOOL)updateOrderDetailsWithOrderDetails:(OrderDetails*)orderDetails
{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"(productId = %d)",[orderDetails.productId intValue]];
    [fetchRequest setPredicate:predicate];
    NSEntityDescription *entity;
    entity = [NSEntityDescription
              entityForName:@"OrderDetails" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSArray *arrTemp  = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if ([arrTemp count]>0)
    {
        OrderDetails *orderDetails = [arrTemp objectAtIndex:0];
        
        NSLog(@"PRODUCT QUANTITY : %@",orderDetails.productQuantity);
        
        [orderDetails setProductQuantity:[NSNumber numberWithInt:([orderDetails.productQuantity intValue])]];
    }
	return [self commitChangesToDatabase];
}

-(BOOL)updateOrderHistoryWithOrderHistory:(OrderHistory*)orderHistory
{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"(orderId = %d)",[orderHistory.orderId intValue]];
    [fetchRequest setPredicate:predicate];
    NSEntityDescription *entity;
    entity = [NSEntityDescription
              entityForName:@"OrderHistory" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSArray *arrTemp  = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if ([arrTemp count]>0) {
        OrderHistory *oldOrderHistory = [arrTemp objectAtIndex:0];
        
        oldOrderHistory.earnRewardPts = orderHistory.earnRewardPts;
        oldOrderHistory.payRewardPts = orderHistory.payRewardPts;
        oldOrderHistory.payRewardPtsStatus = orderHistory.payRewardPtsStatus;
        oldOrderHistory.totalPrice = orderHistory.totalPrice;
        
        oldOrderHistory.couponcode = orderHistory.couponcode;
        oldOrderHistory.couponValidFromDate = orderHistory.couponValidFromDate;
        oldOrderHistory.couponValidToDate = orderHistory.couponValidToDate;
        oldOrderHistory.couponValidForMinAmount = orderHistory.couponValidForMinAmount;
        oldOrderHistory.couponValidInBranchID = orderHistory.couponValidInBranchID;
        
        oldOrderHistory.customerName = orderHistory.customerName;
        oldOrderHistory.customerMobileNo = orderHistory.customerMobileNo;
        oldOrderHistory.carTableNo = orderHistory.carTableNo;
        oldOrderHistory.isBookedStatus = orderHistory.isBookedStatus;
    }
	return [self commitChangesToDatabase];
}

#pragma mark -
#pragma mark delete queries

-(BOOL)deleteRecordsOfTable:(NSString*)table forField:(NSString*)field withEqualityValue:(NSString*)value
{
    BOOL success =  FALSE;
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity;
    entity = [NSEntityDescription
              entityForName:table inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate;
    
    if ([[NSScanner scannerWithString:value] scanInt:nil]) {
        predicate = [NSPredicate predicateWithFormat:@"(%K == %d)",field,[value intValue]];
    }
    else {
        predicate = [NSPredicate predicateWithFormat:@"(%K == %@)",field,value];
    }
    [fetchRequest setPredicate:predicate];
    
    NSArray *arrTemp = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    if ([arrTemp count] > 0)
    {
        for (int i=0; i<[arrTemp count]; i++) {
            [self.managedObjectContext deleteObject:[arrTemp objectAtIndex:i]];
        }
        success = [self commitChangesToDatabase];
    }
    return success;
}

-(BOOL)deleteAllRecordsOfTable:(NSString*)table
{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity;
    entity = [NSEntityDescription
              entityForName:table inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSMutableArray *arrTemp = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];

    if ([arrTemp count] != 0)
    {
        for (int i=0; i<[arrTemp count]; i++) {
            [self.managedObjectContext deleteObject:[arrTemp objectAtIndex:i]];
        }
        return [self commitChangesToDatabase];
    }
    else
    {
        return NO;
    }
}

#pragma mark -
#pragma mark select queries

-(NSArray*)getAllRecordsOfTable:(NSString*)table
{

    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity;
    entity = [NSEntityDescription
              entityForName:table inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate;
    if ([table isEqualToString:@"CategoryMaster"] || [table isEqualToString:@"ProductMaster"] || [table isEqualToString:@"MenuMaster"]) {
        predicate = [NSPredicate predicateWithFormat:@"(isDelete == NO) AND (isActive == YES)"];
        [fetchRequest setPredicate:predicate];
    }
    
    NSArray *arrTemp = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    return arrTemp;
}

-(NSArray*)getAllRecordsOfTable:(NSString*)table WithSortByField1:(NSString*)field1 InAscending1:(BOOL)inAscending1 sortByField2:(NSString*)field2 InAscending2:(BOOL)inAscending2
{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity;
    entity = [NSEntityDescription
              entityForName:table inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate;
    if ([table isEqualToString:@"CategoryMaster"] || [table isEqualToString:@"ProductMaster"] || [table isEqualToString:@"MenuMaster"] || [table isEqualToString:@"PromoImageDetails"]) {
        predicate = [NSPredicate predicateWithFormat:@"(isDelete == NO) AND (isActive == YES)"];
        [fetchRequest setPredicate:predicate];
    }
    NSArray *sortDescriptors;
    NSSortDescriptor *sortDescriptor1;
    sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:[NSString stringWithFormat:@"%@",field1]
                                                  ascending:inAscending1 selector:@selector(caseInsensitiveCompare:)];
    
    if (![field2 isEqualToString:@""]) {
        NSSortDescriptor *sortDescriptor2;
        sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:[NSString stringWithFormat:@"%@",field2]
                                                      ascending:inAscending2 selector:@selector(caseInsensitiveCompare:)];
        sortDescriptors = [NSArray arrayWithObjects:sortDescriptor1,sortDescriptor2,nil];
    }
    else {
        sortDescriptors = [NSArray arrayWithObjects:sortDescriptor1,nil];
    }
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSArray *arrTemp = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    return arrTemp;
}



-(NSArray*)getRecordsOfTable:(NSString*)table forField:(NSString*)field withEqualityValue:(NSString*)value
{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity;
    entity = [NSEntityDescription
              entityForName:table inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate;
    
    if ([[NSScanner scannerWithString:value] scanInt:nil])
    {
        predicate = [NSPredicate predicateWithFormat:@"(%K == %d)",field,[value intValue]];
    }
    else
    {
        predicate = [NSPredicate predicateWithFormat:@"(%K == %@)",field,value];
    }
    [fetchRequest setPredicate:predicate];
    
    NSArray *arrTemp = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    return arrTemp;
}

-(NSArray*)getRecordsOfTable:(NSString*)table forField:(NSString*)field withEqualityValue:(NSString*)value WithSortByField:(NSString*)sortField InAscending:(BOOL)inAscending
{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity;
    entity = [NSEntityDescription
              entityForName:table inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate;
    
    if ([[NSScanner scannerWithString:value] scanInt:nil]) {
        if ([table isEqualToString:@"ProductMaster"] || [table isEqualToString:@"CategoryMaster"])
        {
            predicate = [NSPredicate predicateWithFormat:@"(%K == %d && isDelete == NO && isActive == YES)",field,[value intValue]];
        }
        else
        {
            predicate = [NSPredicate predicateWithFormat:@"(%K == %d)",field,[value intValue]];
        }
    }
    else {
        if ([table isEqualToString:@"ProductMaster"] || [table isEqualToString:@"CategoryMaster"])
        {
            predicate = [NSPredicate predicateWithFormat:@"(%K == %@ && isDelete == NO && isActive == YES)",field,value];
        }
        else
        {
            predicate = [NSPredicate predicateWithFormat:@"(%K == %@)",field,value];
        }
    }
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor1;
    //        NSSortDescriptor *sortDescriptor2;
    sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:[NSString stringWithFormat:@"%@",sortField]
                                                  ascending:inAscending selector:@selector(caseInsensitiveCompare:)];
    //        sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"categoryId"                                                     ascending:YES selector:@selector(caseInsensitiveCompare:)];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor1,nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSArray *arrTemp = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    return arrTemp;
}

-(NSArray*)getProductForcategory_Id:(int)category_Id isForHomeDelivery:(BOOL)isForHomeDelivery
{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSPredicate *predicate;
    NSEntityDescription *entity;
    if (isForHomeDelivery) {
        predicate = [NSPredicate predicateWithFormat:@"(categoryId == %d) AND (isHomeDeliverable == YES) AND (isActive == YES) AND (isDelete == NO)",category_Id];
    }
    else {
        predicate = [NSPredicate predicateWithFormat:@"(categoryId == %d) AND (isActive == YES) AND (isDelete == NO)",category_Id];
    }
    [fetchRequest setPredicate:predicate];
    entity = [NSEntityDescription
              entityForName:@"ProductMaster" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor1;
    sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:[NSString stringWithFormat:@"sequenceNo"]
                                                  ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor1,nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSArray *arrTemp1 = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    return arrTemp1;
}

-(NSArray*)getAllCategoriesIsForHomeDeliverable:(BOOL)isForHomeDeliverable forOutletID:(int)outletId
{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSPredicate *predicate;
    if (isForHomeDeliverable) {
        predicate = [NSPredicate predicateWithFormat:@"isHomeDeliverable == YES && isDelete == NO && isActive == YES"];
    }
    else {
        predicate = [NSPredicate predicateWithFormat:@"isDelete == NO && isActive == YES && outletId == %d",outletId];
    }
    [fetchRequest setPredicate:predicate];
    NSEntityDescription *entity;
    entity = [NSEntityDescription
              entityForName:@"ProductMaster" inManagedObjectContext:self.managedObjectContext];
    NSDictionary *entityProperties = [entity propertiesByName];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:[entityProperties objectForKey:@"categoryId"]]];
    NSArray *arrTemp = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *arrCategoryIds = [arrTemp valueForKey:@"categoryId"];
//    //NSLog(@"arr %d",[arrCategoryIds count]);
    
    predicate = [NSPredicate predicateWithFormat:@"(categoryId IN %@ && isDelete == NO && isActive == YES)",arrCategoryIds];
    [fetchRequest setPredicate:predicate];
    entity = [NSEntityDescription
              entityForName:@"CategoryMaster" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor1;
    sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:[NSString stringWithFormat:@"sequenceNo"]
                                                  ascending:YES selector:@selector(caseInsensitiveCompare:)];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor1,nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSArray *arrTemp1 = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return arrTemp1;
}

@end
