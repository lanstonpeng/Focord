//
//  DayContainer.h
//  Focord
//
//  Created by Lanston Peng on 3/13/14.
//  Copyright (c) 2014 Vtmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataAbstract.h"
#import "DayContainer.h"
@class Record;
@interface DayContainer :NSObject<NSCoding>
@property (nonatomic,strong)  NSNumber* dayID;
@property (nonatomic, strong) NSString * date;
@property (nonatomic, strong) NSMutableArray *record;


+ (DayContainer*)dictionary2DayContainer:(NSDictionary*)dic;
+ (void)addDayContainer:(DayContainer*)dayContainer;
+ (void)removeDayContainer:(NSNumber*)dayID;
+ (NSArray*)searchDayContainer:(NSString*)key withValue:(NSString*)value;
+ (void)updateDayContainer:(NSNumber*)dayID withDayContainer:(DayContainer*)dayContainer;
+ (NSArray*)getAllDayContainer;
@end
