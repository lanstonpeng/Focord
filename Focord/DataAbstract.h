//
//  DataAbstract.h
//  Focord
//
//  Created by Lanston Peng on 3/26/14.
//  Copyright (c) 2014 Vtmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DayContainer.h"

@interface DataAbstract : NSObject
+(instancetype)sharedData;
-(BOOL)addItem:(id)item;
-(BOOL)removeItem:(NSDictionary*)item;
-(BOOL)updateItem:(id)dayContainer;
-(id)searchItem:(NSString*)key value:(NSString*)value;
-(id)getAllItem;
-(void)removeDataFile;
-(void)flushData;
@end
