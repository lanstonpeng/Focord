//
//  Counter.h
//  Focord
//
//  Created by Lanston Peng on 2/18/14.
//  Copyright (c) 2014 Vtmer. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{
   CounterRunning = 0,
   CounterStop
} CounterEnum;

@interface Counter : NSObject
@property(nonatomic)NSTimeInterval startTime;
@property(nonatomic)NSTimeInterval endTime;
@property(nonatomic)NSInteger duration;
@property(nonatomic)CounterEnum status;
+(instancetype)sharedConter;
-(void)startCount;
-(void)stopCount;
@end
