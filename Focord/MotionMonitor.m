//
//  MotionMonitor.m
//  Focord
//
//  Created by Lanston Peng on 2/18/14.
//  Copyright (c) 2014 Vtmer. All rights reserved.
//

#import "MotionMonitor.h"
@interface MotionMonitor()
@property (strong,nonatomic)id notifier;
@end
@implementation MotionMonitor
-(CMMotionManager*)motionManager{
  if(!_motionManager){
    _motionManager = [[CMMotionManager alloc]init];
    _motionManager.accelerometerUpdateInterval = 0.9;
  }
  return _motionManager;
}
-(id)notifier{
  if(!_notifier){
    _notifier = [NSNotificationCenter defaultCenter];
  }
  return _notifier;
}
-(void)startMonitor
{
  NSOperationQueue* queue = [[NSOperationQueue alloc]init];
  NSMutableArray* acelerometer = [[NSMutableArray alloc]init];
  NSLog(@"%@",self.motionManager);
  [self.motionManager startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData *latestAcc, NSError *error) {
    if (error) {
      [self.motionManager stopAccelerometerUpdates];
    }
    acelerometer[0] = [NSString stringWithFormat:@"%0.2f",latestAcc.acceleration.x];
    acelerometer[1] = [NSString stringWithFormat:@"%0.2f",latestAcc.acceleration.y];
    acelerometer[2] = [NSString stringWithFormat:@"%0.2f",latestAcc.acceleration.z];
    double z = latestAcc.acceleration.z;
    if(z < -0.95 && z > -1.05){
      [self.notifier postNotificationName:@"motionDetect" object:nil userInfo:@{
                                                                                @"type":MOTION_UP
                                                                                }];
    }
    else{
      [self.notifier postNotificationName:@"motionDetect" object:self userInfo:@{
                                                                                 @"type":MOTION_OTHER
                                                                                 }];
    }
  }];
}
-(void)addListener:(id)observer usingBlock:(void (^)(NSNotification *))block
{
  [self.notifier addObserverForName:@"motionDetect" object:nil queue:nil usingBlock:^(NSNotification* n){
    block(n);
  }];
}
/*
-(void)sucker:(NSNotification*)notification
{
  NSLog(@"sucker youku");
}
*/
@end
