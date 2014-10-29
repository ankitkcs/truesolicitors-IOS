//
//  MyDatabaseManager.h
//  DatabaseManager

#import "IQDatabaseManager.h"
#import "MyDatabaseConstants.h"

@interface MyDatabaseManager : IQDatabaseManager

// get Records
- (NSArray *)allRecordsSortByAttribute:(NSString*)attribute byAcending:(BOOL)yn fromTable:(NSString*)tableName;

//- (NSArray *)allRecordsSortByAttribute:(NSString*)attribute where:(NSString*)key contains:(id)value;
- (NSArray *)allRecordsSortByAttribute:(NSString*)attribute where:(NSString*)key contains:(id)value byAcending:(BOOL)yn fromTable:(NSString*)tableName;

// global insert Method
- (id) insertRecordInTable:(NSString*)tableName withDataDict:(NSDictionary*)recordAttributes;


// global update Method
-(id) updateRecordInTable:(NSString*)tableName ofRecord:(id)record recordDetail:(NSDictionary*)recordAttributes;


////RecordTable Method
//- (RecordTable*) insertRecordInRecordTable:(NSDictionary*)recordAttributes;
//- (RecordTable*) insertUpdateRecordInRecordTable:(NSDictionary*)recordAttributes;
//- (RecordTable*) updateRecord:(RecordTable*)record inRecordTable:(NSDictionary*)recordAttributes;
//- (BOOL) deleteTableRecord:(RecordTable*)record;


////MessageDetails Method
//- (MassegeDetail*) insertRecordInMassegeDetailTable:(NSDictionary*)recordAttributes;
//- (MassegeDetail*) insertUpdateRecordInMassegeDetailTable:(NSDictionary*)recordAttributes;
//- (MassegeDetail*) updateRecord:(MassegeDetail*)record inMassegeDetailTable:(NSDictionary*)recordAttributes;
//-(BOOL) deleteMassegeDetailTableRecord:(MassegeDetail*)record;

//Claims Method



//Delete All Records of Table
-(BOOL) deleteAllRecordOfTable:(NSString*)tableName;

- (Settings*) settings;
- (Settings*) saveSettings:(NSDictionary*)settings;

@end
