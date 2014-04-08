//
//  DayContainer.m
//  Focord
//
//  Created by Lanston Peng on 3/13/14.
//  Copyright (c) 2014 Vtmer. All rights reserved.
//

#import "Record.h"
#import "objc/runtime.h"
@implementation DayContainer

+ (DayContainer*)dictionary2DayContainer:(NSDictionary*)dic{
    DayContainer* dayContainer = [[DayContainer alloc]init];
    dayContainer.dayID = [dic objectForKey:@"dayID"];
    dayContainer.date  =[dic objectForKey:@"date"];
    dayContainer.record  =[dic objectForKey:@"record"];
    return dayContainer;
}
+ (void)addDayContainer:(DayContainer*)dayContainer{
    DataAbstract* da = [DataAbstract sharedData];
    if([[da searchItem:@"date" value:dayContainer.date] count] == 0)
    {
        [da addItem:dayContainer];
    }
}

+ (NSArray*)searchDayContainer:(NSString*)key withValue:(NSString*)value{
    NSMutableArray* results = [[NSMutableArray alloc]init];
    DataAbstract* da = [DataAbstract sharedData];
    for(NSDictionary* item in [da searchItem:key value:value]){
        DayContainer* dayContainer = [DayContainer dictionary2DayContainer:item];
        [results addObject:dayContainer];
    }
    return results;
}
+ (NSArray*)getAllDayContainer{
    DataAbstract* da = [DataAbstract sharedData];
    NSMutableArray* allItems = [[NSMutableArray alloc]init];
    for(NSDictionary* item in [da getAllItem]){
        DayContainer* dayContainer = [DayContainer dictionary2DayContainer:item];
        [allItems addObject:dayContainer];
    }
    return allItems;
}
+ (void)updateDayContainer:(NSNumber*)dayID withDayContainer:(DayContainer*)dayContainer{}
+ (void)removeDayContainer:(NSNumber*)dayID
{
    
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        self.dayID = [aDecoder decodeObjectForKey:@"dayID"];
        self.date = [aDecoder decodeObjectForKey:@"date"];
        self.record = [aDecoder decodeObjectForKey:@"record"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.dayID forKey:@"dayID"];
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeObject:self.record forKey:@"record"];
}
@end
