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
@property (strong,nonatomic)NSMutableArray* currentObservers;
@end


@implementation MotionMonitor
+(instancetype)sharedMotionManager{
    static MotionMonitor* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MotionMonitor alloc]init];
    });
    return instance;
}
- (NSMutableArray *)currentObservers{
    if(!_currentObservers){
        _currentObservers = [[NSMutableArray alloc]init];
    }
    return _currentObservers;
}
-(CMMotionManager*)motionManager{
  if(!_motionManager){
    _motionManager = [[CMMotionManager alloc]init];
    _motionManager.accelerometerUpdateInterval = 1.0;
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
  [self.motionManager startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData *latestAcc, NSError *error) {
    if (error) {
      [self.motionManager stopAccelerometerUpdates];
    }
    acelerometer[0] = [NSString stringWithFormat:@"%0.2f",latestAcc.acceleration.x];
    acelerometer[1] = [NSString stringWithFormat:@"%0.2f",latestAcc.acceleration.y];
    acelerometer[2] = [NSString stringWithFormat:@"%0.2f",latestAcc.acceleration.z];
    double z = latestAcc.acceleration.z;
    if(z < -0.95 && z > -1.05){
      [self.notifier postNotificationName:NOTIFICATION_NAME object:self userInfo:@{ @"type":MOTION_UP}];
    }
    else{
      [self.notifier postNotificationName:NOTIFICATION_NAME object:self userInfo:@{ @"type":MOTION_OTHER }];
    }
  }];
}
-(void)addListener:(id)observer usingBlock:(void (^)(NSNotification *))block
{
  [self.notifier addObserverForName:NOTIFICATION_NAME object:self queue:nil usingBlock:^(NSNotification* n){
    block(n);
  }];
}
-(void)addListener:(id)observer withSelector:(SEL)sel
{
    [self.currentObservers addObject:observer];
    [self.notifier addObserver:observer selector:sel name:NOTIFICATION_NAME object:self];
}
-(void)removeListener:(id)observer{
    //[self.notifier removeObserver:observer]; //remove all notifications
    [self.notifier removeObserver:observer name:NOTIFICATION_NAME object:self];
}
-(void)stopMonitor{
    [self.notifier postNotificationName:NOTIFICATION_NAME object:self userInfo:@{ @"type":MOTION_OTHER,@"timing":TIMING_LASTCALL }];
    [self.motionManager stopAccelerometerUpdates];
    for (id observer in self.currentObservers) {
        [self removeListener:observer];
    }
}
@end
