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
+ (DayContainer*)addDayContainer:(DayContainer*)dayContainer{
    DataAbstract* da = [DataAbstract sharedData];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    if(! (dic = [da searchItem:@"date" value:dayContainer.date]))
    {
        [da addItem:dayContainer];
    }
    return dayContainer;
}

+ (void)searchDayContainer:(NSNumber*)dayID{
}
+ (NSArray*)getAllDayContainer{
    
    DataAbstract* da = [DataAbstract sharedData];
    return [da getAllItem];
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
