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
- (NSArray *)allRecordsSortByAttribute:(NSString*)attribute byAcending:(BOOL)yn fromTable:(NSString*)tableName
{
    NSSortDescriptor *sortDescriptor = nil;
    
    if ([attribute length]) sortDescriptor = [[NSSortDescriptor alloc] initWithKey:attribute ascending:yn];
    
    return [self allObjectsFromTable:tableName sortDescriptor:sortDescriptor];
}

- (NSArray *)allRecordsSortByAttribute:(NSString*)attribute where:(NSString*)key contains:(id)value byAcending:(BOOL)yn fromTable:(NSString*)tableName
{
    NSSortDescriptor *sortDescriptor = nil;
    
    if ([attribute length]) sortDescriptor = [[NSSortDescriptor alloc] initWithKey:attribute ascending:yn];
    
    if([tableName isEqualToString:TBL_MASSEGE_DETAIL])
    {
         return [self allObjectsFromTable:tableName where:key contains:value sortDescriptor:sortDescriptor];
    }
    else  if([tableName isEqualToString:TBL_DOCUMENT_TYPE])
    {
        return [self allObjectsFromTable:tableName where:key equals:value sortDescriptor:sortDescriptor];
    }
    
    return nil;
}

//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

#pragma mark - Insert Record From Table

- (id) insertRecordInTable:(NSString*)tableName withDataDict:(NSDictionary*)recordAttributes
{
    if([tableName isEqualToString:TBL_MASSEGE_DETAIL])
    {
       return (MassegeDetail*)[self insertRecordInTable:tableName withAttribute:recordAttributes];
    }
    else if ([tableName isEqualToString:TBL_LINK_CLAIM])
    {
        return (LinkToClaim*)[self insertRecordInTable:tableName withAttribute:recordAttributes];
    }
    else if ([tableName isEqualToString:TBL_DOCUMENT_DETAIL])
    {
        return (DocumentDetail*)[self insertRecordInTable:tableName withAttribute:recordAttributes];
    }
    else if ([tableName isEqualToString:TBL_DOCUMENT_TYPE])
    {
        return (DocumentsType*)[self insertRecordInTable:tableName withAttribute:recordAttributes];
    }
    else if ([tableName isEqualToString:TBL_FAQ_DETAIL])
    {
        return (FAQDetail*)[self insertRecordInTable:tableName withAttribute:recordAttributes];
    }
    return nil;
}

#pragma mark - Update Record From Table

//- (MassegeDetail*) updateRecord:(MassegeDetail*)record inMassegeDetailTable:(NSDictionary*)recordAttributes
//{
//    if([tableName isEqualToString:TBL_MASSEGE_DETAIL])
//    {
//        return (MassegeDetail*)[self updateRecord:record withAttribute:recordAttributes];
//    }
//    
//    return nil;
//}

-(id) updateRecordInTable:(NSString*)tableName ofRecord:(id)record recordDetail:(NSDictionary*)recordAttributes
{
    if([tableName isEqualToString:TBL_MASSEGE_DETAIL])
    {
        MassegeDetail *msgRecord;
        if([record isKindOfClass:[MassegeDetail class]])
        {
            msgRecord = (MassegeDetail*)record;
        }
        return (MassegeDetail*)[self updateRecord:msgRecord withAttribute:recordAttributes];
    }
    else if([tableName isEqualToString:TBL_DOCUMENT_DETAIL])
    {
        DocumentDetail *docRecord;
        if([record isKindOfClass:[DocumentDetail class]])
        {
            docRecord = (DocumentDetail*)record;
        }
        return (DocumentDetail*)[self updateRecord:docRecord withAttribute:recordAttributes];
    }
    
    return nil;
}


//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//#pragma mark - MsgDetails
//
//- (MassegeDetail*) insertRecordInMassegeDetailTable:(NSDictionary*)recordAttributes
//{
//    return (MassegeDetail*)[self insertRecordInTable:NSStringFromClass([MassegeDetail class]) withAttribute:recordAttributes];
//}
//
//- (MassegeDetail*) insertUpdateRecordInMassegeDetailTable:(NSDictionary*)recordAttributes
//{
//    return (MassegeDetail*)[self insertRecordInTable:NSStringFromClass([MassegeDetail class]) withAttribute:recordAttributes updateOnExistKey:kEmail equals:[recordAttributes objectForKey:kEmail]];
//}
//
//- (MassegeDetail*) updateRecord:(MassegeDetail*)record inMassegeDetailTable:(NSDictionary*)recordAttributes
//{
//    return (MassegeDetail*)[self updateRecord:record withAttribute:recordAttributes];
//}
//
//- (BOOL) deleteMassegeDetailTableRecord:(MassegeDetail*)record
//{
//     return [self deleteRecord:record];
//}

////::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//#pragma mark - RecordTable
//-(RecordTable*) insertRecordInRecordTable:(NSDictionary*)recordAttribute
//{
//    return (RecordTable*)[self insertRecordInTable:NSStringFromClass([RecordTable class]) withAttribute:recordAttribute];
//}
//
//- (RecordTable*) insertUpdateRecordInRecordTable:(NSDictionary*)recordAttribute
//{
//    return (RecordTable*)[self insertRecordInTable:NSStringFromClass([RecordTable class]) withAttribute:recordAttribute updateOnExistKey:kEmail equals:[recordAttribute objectForKey:kEmail]];
//}
//
//- (RecordTable*) updateRecord:(RecordTable*)record inRecordTable:(NSDictionary*)recordAttribute
//{
//    return (RecordTable*)[self updateRecord:record withAttribute:recordAttribute];
//}

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
