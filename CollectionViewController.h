//
//  CollectionViewController.h
//  Focord
//
//  Created by Lanston Peng on 2/14/14.
//  Copyright (c) 2014 Vtmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <AudioToolbox/AudioServices.h>
#import "objc/runtime.h"
@interface CollectionViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIDynamicAnimatorDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *myCollection;
@property (strong,nonatomic)NSManagedObjectContext* managedObjectContext;
@end
