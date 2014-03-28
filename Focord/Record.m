//
//  Record.m
//  Focord
//
//  Created by Lanston Peng on 3/13/14.
//  Copyright (c) 2014 Vtmer. All rights reserved.
//

#import "Record.h"
#import "DayContainer.h"
#define DAYCONTAINER_DATE @"date"
@implementation Record
+(void)addRecord:(Record*)record belongsToDate:(NSString*)dateString
{
    DataAbstract* da = [DataAbstract sharedData];
    id result = [da searchItem:DAYCONTAINER_DATE value:dateString];
    if(!result){
        DayContainer* dayContainer = (DayContainer*)result;
        [dayContainer.record insertObject:record atIndex:0];
    }
}
+(void)removeRecord:(NSNumber*)recordID{
}
+(NSArray*)getAllRecords{
    NSArray* result;
    return result;
}
@end
