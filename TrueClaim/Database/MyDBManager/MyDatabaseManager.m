//
//  MyDatabaseManager.m
//  DatabaseManager

#import "MyDatabaseManager.h"
#import "IQDatabaseManagerSubclass.h"

@implementation MyDatabaseManager

+(NSURL*)modelURL
{
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MyDatabase" withExtension:IQ_MODEL_EXTENSION_momd];
    
    if (modelURL == nil)    modelURL = [[NSBundle mainBundle] URLForResource:@"MyDatabase" withExtension:IQ_MODEL_EXTENSION_mom];

    return modelURL;
}

#pragma mark - Get All Record From Table
- (NSArray *)allRecordsSortByAttribute:(NSString*)attribute fromTable:(NSString*)tableName
{
    NSSortDescriptor *sortDescriptor = nil;
    
    if ([attribute length]) sortDescriptor = [[NSSortDescriptor alloc] initWithKey:attribute ascending:YES];
    
    return [self allObjectsFromTable:tableName sortDescriptor:sortDescriptor];
}

- (NSArray *)allRecordsSortByAttribute:(NSString*)attribute where:(NSString*)key contains:(id)value
{
    NSSortDescriptor *sortDescriptor = nil;
    
    if ([attribute length]) sortDescriptor = [[NSSortDescriptor alloc] initWithKey:attribute ascending:YES];
    
    return [self allObjectsFromTable:NSStringFromClass([MassegeDetail class]) where:key contains:value sortDescriptor:sortDescriptor];
}

//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

#pragma mark - Insert Record From Table

- (id) insertRecordInTable:(NSString*)tableName withDataDict:(NSDictionary*)recordAttributes
{
    if([tableName isEqualToString:TBL_MASSEGE_DETAIL])
    {
       return (MassegeDetail*)[self insertRecordInTable:tableName withAttribute:recordAttributes];
    }
    else if ([tableName isEqualToString:TBL_CLAIM])
    {
        return (Claim*)[self insertRecordInTable:tableName withAttribute:recordAttributes];
    }
    else if ([tableName isEqualToString:TBL_FAQ_DETAIL])
    {
        return (FAQDetail*)[self insertRecordInTable:tableName withAttribute:recordAttributes];
    }
    return nil;
}

//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#pragma mark - MsgDetails

- (MassegeDetail*) insertRecordInMassegeDetailTable:(NSDictionary*)recordAttributes
{
    return (MassegeDetail*)[self insertRecordInTable:NSStringFromClass([MassegeDetail class]) withAttribute:recordAttributes];
}

- (MassegeDetail*) insertUpdateRecordInMassegeDetailTable:(NSDictionary*)recordAttributes
{
    return (MassegeDetail*)[self insertRecordInTable:NSStringFromClass([MassegeDetail class]) withAttribute:recordAttributes updateOnExistKey:kEmail equals:[recordAttributes objectForKey:kEmail]];
}

- (MassegeDetail*) updateRecord:(MassegeDetail*)record inMassegeDetailTable:(NSDictionary*)recordAttributes
{
    return (MassegeDetail*)[self updateRecord:record withAttribute:recordAttributes];
}

- (BOOL) deleteMassegeDetailTableRecord:(MassegeDetail*)record
{
     return [self deleteRecord:record];
}

//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#pragma mark - RecordTable
-(RecordTable*) insertRecordInRecordTable:(NSDictionary*)recordAttribute
{
    return (RecordTable*)[self insertRecordInTable:NSStringFromClass([RecordTable class]) withAttribute:recordAttribute];
}

- (RecordTable*) insertUpdateRecordInRecordTable:(NSDictionary*)recordAttribute
{
    return (RecordTable*)[self insertRecordInTable:NSStringFromClass([RecordTable class]) withAttribute:recordAttribute updateOnExistKey:kEmail equals:[recordAttribute objectForKey:kEmail]];
}

- (RecordTable*) updateRecord:(RecordTable*)record inRecordTable:(NSDictionary*)recordAttribute
{
    return (RecordTable*)[self updateRecord:record withAttribute:recordAttribute];
}

- (BOOL) deleteTableRecord:(RecordTable*)record
{
    return [self deleteRecord:record];
}

//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

-(BOOL) deleteAllRecordOfTable:(NSString*)tableName
{
    return [self flushTable:tableName];
}

//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#pragma mark - Settings
- (Settings*) settings
{
    Settings *settings = (Settings*)[self firstObjectFromTable:NSStringFromClass([Settings class])];
    
    //No settings
    if (settings == nil)
    {
        //Inserting default settings
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],kPassword, nil];
        
        settings = (Settings*)[self insertRecordInTable:NSStringFromClass([Settings class]) withAttribute:dict];
    }
    return settings;
}

- (Settings*) saveSettings:(NSDictionary*)settings
{
    Settings *mySettings = (Settings*)[self firstObjectFromTable:NSStringFromClass([Settings class]) createIfNotExist:YES];
    return (Settings*)[self updateRecord:mySettings withAttribute:settings];
}

@end
