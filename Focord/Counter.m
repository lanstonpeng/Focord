//
//  Counter.m
//  Focord
//
//  Created by Lanston Peng on 2/18/14.
//  Copyright (c) 2014 Vtmer. All rights reserved.
//

#import "Counter.h"
@interface Counter()
@property BOOL hasStart;
@end


@implementation Counter
+ (instancetype)sharedConter{
    static Counter* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Counter alloc]init];
        instance.isCounting = NO;
        instance.hasStart = NO;
    });
    return instance;
}
- (NSInteger)duration{
    NSDate* date = [[NSDate alloc]init];
    return [date timeIntervalSince1970]- self.startTime;
}
-(void)startCount{
  if(!self.hasStart){
    NSDate* date = [[NSDate alloc]init];
    self.startTime = [date timeIntervalSince1970];
    self.isCounting = YES;
  }
  self.hasStart = YES;
}

-(void)stopCount{
  NSDate* date = [[NSDate alloc]init];
  self.endTime = [date timeIntervalSince1970];
  if(self.hasStart){
    self.duration = self.endTime - self.startTime;
    self.isCounting = NO;
  }
  self.hasStart = NO;
}
@end
