//
//  DayContainer.h
//  Focord
//
//  Created by Lanston Peng on 3/13/14.
//  Copyright (c) 2014 Vtmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Record;
@interface DayContainer :NSObject

@property (nonatomic,strong)  NSNumber* dayID;
@property (nonatomic, strong) NSDate * date;
@property (nonatomic, strong) NSSet *record;

+ (void)addDayContainer:(DayContainer*)dayContainer;
+ (void)removeDayContainer:(NSNumber*)dayID;
+ (void)searchDayContainer:(NSNumber*)dayID;
+ (void)updateDayContainer:(DayContainer*)dayContainer;
@end
