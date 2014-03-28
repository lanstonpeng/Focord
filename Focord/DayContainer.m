//
//  DayContainer.m
//  Focord
//
//  Created by Lanston Peng on 3/13/14.
//  Copyright (c) 2014 Vtmer. All rights reserved.
//

#import "DayContainer.h"
#import "Record.h"
#import "objc/runtime.h"
@implementation DayContainer
+ (void)addDayContainer:(DayContainer*)dayContainer{
    DataAbstract* da = [DataAbstract sharedData];
    if(![da searchItem:@"date" value:dayContainer.date])
    {
        [da addItem:dayContainer];
    }
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
@end
