//
//  locationMonitor.m
//  Focord
//
//  Created by Lanston Peng on 2/18/14.
//  Copyright (c) 2014 Vtmer. All rights reserved.
//

#import "locationMonitor.h"
@implementation LocationMonitor
bool isStart = false;
-(CLLocationManager*)locationManager{
  if(!_locationManager){
    _locationManager = [[CLLocationManager alloc] init];
  }
  return _locationManager;
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
  //CLLocation* mylocation = [locations lastObject];
  //self.coordinate = mylocation.coordinate;
  NSLog(@"%@",locations);
  [self.locationManager stopUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
  NSLog(@"error%@",error);
}
-(void)startMonitor{
  if(!isStart){
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    NSLog(@"%d",[CLLocationManager authorizationStatus]);
    [self.locationManager startUpdatingLocation];
    isStart = true;
  }
}
@end
