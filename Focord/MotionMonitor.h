//
//  MotionMonitor.h
//  Focord
//
//  Created by Lanston Peng on 2/18/14.
//  Copyright (c) 2014 Vtmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#define MOTION_UP @"up"
#define MOTION_OTHER @"other"
#define NOTIFICATION_NAME @"montionDetect"
#define TIMING_LASTCALL @"lastnotificatoin"
@interface MotionMonitor : NSObject
@property (strong,nonatomic) CMMotionManager* motionManager;
+(instancetype)sharedMotionManager;
-(CMMotionManager*)motionManager;
-(void)startMonitor;
-(void)addListener:(id)observer usingBlock:(void (^)(NSNotification *))block;
-(void)addListener:(id)observer withSelector:(SEL)sel;
-(void)removeListener:(id)observer;
-(void)stopMonitor;
@end
