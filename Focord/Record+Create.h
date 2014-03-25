//
//  Record+Create.h
//  Focord
//
//  Created by Lanston Peng on 2/18/14.
//  Copyright (c) 2014 Vtmer. All rights reserved.
//

#import "Record.h"
#import "DayContainer.h"
@interface Record (Create)
+ (void)recordWithDayContainer:(Record*)record withDayContainer:(DayContainer*)dayContainer;
@end
