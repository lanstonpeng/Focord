//
//  CollectionViewController.m
//  Focord
//
//  Created by Lanston Peng on 2/14/14.
//  Copyright (c) 2014 Vtmer. All rights reserved.
//

#import "CollectionViewController.h"
#import "ItemCell.h"
#import "collectionFlowLayout.h"
#import "DayContainer+Create.h"
#import "Record+Create.h"
#import "Util.h"
#import "LocationMonitor.h"
#import "MotionMonitor.h"
#import "Counter.h"
#import "ArrayDataSource.h"
#import "DropBehaviour.h"

#define RECORD_MOTION @"up"

@interface CollectionViewController ()
@property  (strong,nonatomic)NSArray* results;
@property (strong,nonatomic)ArrayDataSource* recordDataSource;
@property (strong,nonatomic)NSArray*  records;
@property (strong,nonatomic)DayContainer* currentDayContainer;
@property (strong,nonatomic)DropBehaviour* dropBehaviour;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong,nonatomic)NSMutableArray* dropViewArray;
@property (strong,nonatomic)UICollectionViewLayout* layout;
@end
@implementation CollectionViewController
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
}
static const CGSize DROP_SIZE = { 40, 40 };
- (NSMutableArray *)dropViewArray
{
    if(!_dropViewArray){
        _dropViewArray = [[NSMutableArray alloc]init];
    }
    return _dropViewArray;
}
- (DropBehaviour *)dropBehaviour
{
    if (!_dropBehaviour) {
    _dropBehaviour = [[DropBehaviour alloc] init];
        [self.animator addBehavior:_dropBehaviour];
    }
    return _dropBehaviour;
}

- (UIDynamicAnimator *)animator
{
    if (!_animator) {
        _animator =[[UIDynamicAnimator alloc]initWithCollectionViewLayout:self.layout];
        _animator.delegate = self;
    }
    return _animator;
}
- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    for(UIView* view in self.dropViewArray){
        [self.dropBehaviour removeItem:view];
    }
}

- (void)drop
{
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size = DROP_SIZE;
    int x = (arc4random()%(int)self.myCollection.bounds.size.width) / DROP_SIZE.width;
    frame.origin.x = x * DROP_SIZE.width;
    
    UIView *dropView = [[UIView alloc] initWithFrame:frame];
    [dropView setBackgroundColor:[self randomColor]];
    [self.myCollection addSubview:dropView];
    [self.dropViewArray addObject:dropView];
    
    [self.dropBehaviour addItem:dropView];
}

- (UIColor *)randomColor
{
    switch (arc4random()%5) {
        case 0: return [UIColor greenColor];
        case 1: return [UIColor blueColor];
        case 2: return [UIColor orangeColor];
        case 3: return [UIColor redColor];
        case 4: return [UIColor purpleColor];
    }
    return [UIColor blackColor];
}

-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  [self.myCollection reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.myCollection.alwaysBounceHorizontal = YES;
    self.myCollection.scrollEnabled = YES;
    UICollectionViewFlowLayout* customLayout = [[collectionFlowLayout alloc]init];
    self.myCollection.collectionViewLayout = customLayout;
    [self.myCollection setPagingEnabled:YES];
    
    //Motion
    MotionMonitor * montion = [[MotionMonitor alloc]init];
    Counter* counter = [[Counter alloc]init];
    [montion addListener:self usingBlock:^(NSNotification * notification) {
        NSString* type = [notification.userInfo objectForKey:@"type"];
        if([type isEqualToString:MOTION_UP]){
            [counter startCount];
            //TODO ,save data
        }
        else if([type isEqualToString:MOTION_OTHER]){
            [counter stopCount];
            //NSTimeInterval duration = counter.duration;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self drop];
            });
        }
    }];
    [montion startMonitor];
    collectionCellConfigure configureBlock = ^(id cell,id item,NSInteger idx){
        ItemCell* itemcell = (ItemCell*)cell;
        NSString* text = @"testing";
        [itemcell setText:text];
        [itemcell setBackgroundColor:[UIColor blackColor]];
    };
    self.results = @[@1,@2];
    self.recordDataSource = [[ArrayDataSource alloc]initWithItems:self.results cellIdentifier:@"cell" cellConfigurateBlock:configureBlock];
    self.myCollection.dataSource = self.recordDataSource;
}
-(void)refreshData
{
}
@end
