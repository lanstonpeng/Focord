//
//  DayContainer+Create.m
//  Focord
//
//  Created by Lanston Peng on 2/18/14.
//  Copyright (c) 2014 Vtmer. All rights reserved.
//

#import "DayContainer+Create.h"
#import "Record+Create.h"
@implementation DayContainer (Create)

#define CONTAINER_DATE @"date"

+(DayContainer*)dayWithInfo:(DayContainer*)daycontainer
{
  DayContainer* dayContainer = nil;
  NSManagedObjectContext* context = daycontainer.managedObjectContext;
  NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"DayContainer"];
  request.predicate = [NSPredicate predicateWithFormat:@"date = %@",daycontainer.date];
  NSError* error;
  NSArray* matches = [context executeFetchRequest:request error:&error];
  NSLog(@"match counts: %d",(int)[matches count]);
  //NSLog(@"match result: %@", matches);
  if([matches count] == 1){
    dayContainer = [matches firstObject];
  }
  else{
    NSLog(@"Create dayContainer %@",context);
    dayContainer = [NSEntityDescription insertNewObjectForEntityForName:@"DayContainer" inManagedObjectContext:context];
    dayContainer.date = daycontainer.date;
    dayContainer.record = [NSSet setWithArray:@[]];
    NSError* saveError;
    [context save:&saveError];
  }
  return dayContainer;
}
+(void)insertRecordWithDayContainer:(Record*)record withDayContainer:(DayContainer*)daycontainer intoManagedObjectContext:(NSManagedObjectContext*)context{
  if([daycontainer.record count]){
    //Record* record = nil;
    //record.startTime = recordDictionary valueForKey:
    //NSMutableSet* set = [NSMutableSet alloc]initWithArray:@[
  }
}
@end
