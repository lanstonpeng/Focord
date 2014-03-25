//
//  Record+Create.m
//  Focord
//
//  Created by Lanston Peng on 2/18/14.
//  Copyright (c) 2014 Vtmer. All rights reserved.
//

#import "Record+Create.h"


#define START_TIME @"startTime"
#define END_TIME @"endTime"
#define RECORD_DESCRIPTION @"recordDescription"
#define LATITUDE @"latitude"
#define LONGITUDE @"longitude"
@implementation Record (Create)
+(void)recordWithDayContainer:(Record *)record withDayContainer:(DayContainer *)dayContainer
{
    //[dayContainer addRecordObject:record];
    NSManagedObjectContext* context = record.managedObjectContext;
    NSError* error;
    /*
    Record* insertRecord = [NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:context];
    
    insertRecord.startTime = record.startTime;
    insertRecord.endTime = record.endTime;
    insertRecord.recordDescription = record.recordDescription;
    insertRecord.belongsTo = dayContainer;
     */
    record.belongsTo = dayContainer;
    [context save:&error];
}
@end
