//
//  DayContainer+Create.h
//  Focord
//
//  Created by Lanston Peng on 2/18/14.
//  Copyright (c) 2014 Vtmer. All rights reserved.
//

#import "DayContainer.h"

@interface DayContainer (Create)
+(DayContainer*)dayWithInfo:(DayContainer*)daycontainer;
+(void)insertRecordWithDayContainer:(Record*)record withDayContainer:(DayContainer*)daycontainer intoManagedObjectContext:(NSManagedObjectContext*)context;
@end
