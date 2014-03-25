//
//  DayContainer.h
//  Focord
//
//  Created by Lanston Peng on 3/13/14.
//  Copyright (c) 2014 Vtmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Record;

@interface DayContainer : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSSet *record;
@end

@interface DayContainer (CoreDataGeneratedAccessors)

- (void)addRecordObject:(Record *)value;
- (void)removeRecordObject:(Record *)value;
- (void)addRecord:(NSSet *)values;
- (void)removeRecord:(NSSet *)values;

@end
