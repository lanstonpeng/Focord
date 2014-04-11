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
@interface MotionMonitor : NSObject
@property (strong,nonatomic) CMMotionManager* motionManager;
-(CMMotionManager*)motionManager;
-(void)startMonitor;
-(void)addListener:(id)observer usingBlock:(void (^)(NSNotification *))block;
-(void)addListenerBySelector:(SEL)sel;
@end
