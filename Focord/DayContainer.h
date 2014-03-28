//
//  DayContainer.h
//  Focord
//
//  Created by Lanston Peng on 3/13/14.
//  Copyright (c) 2014 Vtmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataAbstract.h"

@class Record;
@interface DayContainer :NSObject
@property (nonatomic,strong)  NSNumber* dayID;
@property (nonatomic, strong) NSString * date;
@property (nonatomic, strong) NSMutableArray *record;

+ (void)addDayContainer:(DayContainer*)dayContainer;
+ (void)removeDayContainer:(NSNumber*)dayID;
+ (void)searchDayContainer:(NSNumber*)dayID;
+ (void)updateDayContainer:(NSNumber*)dayID withDayContainer:(DayContainer*)dayContainer;
+ (NSArray*)getAllDayContainer;
@end
