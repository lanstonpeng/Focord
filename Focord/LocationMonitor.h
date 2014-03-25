//
//  locationMonitor.h
//  Focord
//
//  Created by Lanston Peng on 2/18/14.
//  Copyright (c) 2014 Vtmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface LocationMonitor : NSObject<CLLocationManagerDelegate>
@property (strong,nonatomic)CLLocationManager* locationManager;
-(void)startMonitor;
@end
