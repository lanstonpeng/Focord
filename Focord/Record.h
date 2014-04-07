//
//  Record.h
//  Focord
//
//  Created by Lanston Peng on 3/13/14.
//  Copyright (c) 2014 Vtmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataAbstract.h"

@interface Record : NSObject<NSCoding>

@property (nonatomic, strong) NSNumber*  recordID;
@property (nonatomic, strong) NSNumber * endTime;
@property (nonatomic, strong) NSNumber * latitude;
@property (nonatomic, strong) NSNumber * longitude;
@property (nonatomic, strong) NSString * recordDescription;
@property (nonatomic, strong) NSNumber * startTime;

+(void)addRecord:(Record*)record belongsToDate:(NSString*)dateString;
+(void)removeRecord:(NSNumber*)recordID;
+(NSArray*)getAllRecords;
@end
