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
    if(result){
        DayContainer* dayContainer = [[DayContainer alloc]init];
        result = (NSDictionary*)result;
        [dayContainer setValuesForKeysWithDictionary:result];
        [dayContainer.record insertObject:record atIndex:0];
        [da updateItem:dayContainer];
        [da flushData];
    }
}
+(void)removeRecord:(NSNumber*)recordID{
}
+(NSArray*)getAllRecords{
    NSArray* result;
    return result;
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        self.recordID = [aDecoder decodeObjectForKey:@"recordID"];
        self.endTime = [aDecoder decodeObjectForKey:@"endTime"];
        self.latitude = [aDecoder decodeObjectForKey:@"latitude"];
        self.longitude = [aDecoder decodeObjectForKey:@"longitude"];
        self.recordDescription = [aDecoder decodeObjectForKey:@"recordDescription"];
        self.startTime = [aDecoder decodeObjectForKey:@"startTime"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.recordID forKey:@"recordID"];
    [aCoder  encodeObject:self.endTime forKey:@"endTime"];
    [aCoder encodeObject:self.latitude forKey:@"latitude"];
    [aCoder encodeObject:self.longitude forKey:@"longitude"];
    [aCoder encodeObject:self.recordDescription forKey:@"recordDescription"];
    [aCoder encodeObject:self.startTime forKey:@"startTime"];
}

@end
