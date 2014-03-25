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
-(void)startCount{
  if(!self.hasStart){
    NSDate* date = [[NSDate alloc]init];
    self.startTime = [date timeIntervalSince1970];
  }
  self.hasStart = YES;
  
}
-(void)stopCount{
  NSDate* date = [[NSDate alloc]init];
  self.endTime = [date timeIntervalSince1970];
  if(self.hasStart){
    self.duration = self.endTime - self.startTime;
  }
  self.hasStart = NO;
}
@end
