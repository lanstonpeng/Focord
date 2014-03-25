//
//  Record.h
//  Focord
//
//  Created by Lanston Peng on 3/13/14.
//  Copyright (c) 2014 Vtmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DayContainer;

@interface Record : NSManagedObject

@property (nonatomic, retain) NSNumber * endTime;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * recordDescription;
@property (nonatomic, retain) NSNumber * startTime;
@property (nonatomic, retain) DayContainer *belongsTo;

@end
