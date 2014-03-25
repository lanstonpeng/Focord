//
//  Cell.h
//  Focord
//
//  Created by Lanston Peng on 2/14/14.
//  Copyright (c) 2014 Vtmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface Cell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet MKMapView *myMap;
-(void)setProperty;
@end
