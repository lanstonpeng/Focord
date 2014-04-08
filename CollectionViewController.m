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
#import "Util.h"
#import "LocationMonitor.h"
#import "MotionMonitor.h"
#import "Counter.h"
#import "ArrayDataSource.h"
#import "DropBehaviour.h"
#import "DayContainer.h"
#import "Record.h"
#import "DeviceInfo.h"

#define RECORD_MOTION @"up"
#define DATE_FORMATE @"yyyy-MM-dd"

@interface CollectionViewController ()
@property  (strong,nonatomic)NSArray* results;
@property (strong,nonatomic)ArrayDataSource* recordDataSource;
@property (strong,nonatomic)NSMutableArray*  records;
@property (strong,nonatomic)DayContainer* currentDayContainer;
@property (strong,nonatomic)DropBehaviour* dropBehaviour;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong,nonatomic)NSMutableArray* dropViewArray;
@property (strong,nonatomic)UICollectionViewLayout* layout;
@property (strong,nonatomic)NSTimer* timer;
@property (strong,nonatomic)UIView* currentCubeView;
@property (strong,nonatomic)ItemCell* currentItemCell;
@property (nonatomic)BOOL isCouting;
@end
@implementation CollectionViewController
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
}
static const CGSize DROP_SIZE = { 40, 40 };
- (NSMutableArray *)records
{
    if(!_records){
        _records = [[NSMutableArray alloc]init];
    }
    return _records;
}
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
-(DayContainer*)currentDayContainer
{
    if(!_currentDayContainer){
        _currentDayContainer = [[DayContainer alloc]init];
    }
    return _currentDayContainer;
}

- (UIDynamicAnimator *)animator
{
    if (!_animator) {
        //_animator =[[UIDynamicAnimator alloc]initWithCollectionViewLayout:self.layout];
        _animator =[[UIDynamicAnimator alloc]initWithReferenceView:self.myCollection];
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
-(void)handleSingleTap
{
    NSLog(@"taping");
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
- (void)dropCube
{
    [self.dropBehaviour addItem:self.currentCubeView];
}
-(void)drawCube
{
    if(!self.isCouting){
        UIView* cubeView = [[UIView alloc]initWithFrame:CGRectMake(IPHONE_SCREEN_WIDTH/2 - 20, IPHONE_SCREEN_HEIGHT / 3, 40, 40)];
        [cubeView setBackgroundColor:[self randomColor]];
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap)];
        [cubeView addGestureRecognizer:singleTap];
        [self.myCollection addSubview:cubeView];
        self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(bigifyCube:) userInfo:@{@"view":cubeView} repeats:YES];
        self.isCouting = YES;
        self.currentCubeView = cubeView;
        [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }
    
}
-(void)bigifyCube:(id)sender{
    NSTimer* timer = (NSTimer*)sender;
    UIView* cubeView= [timer.userInfo objectForKey:@"view"];
    CGRect frame;
    frame.origin = cubeView.frame.origin;
    frame.size.width = cubeView.frame.size.width + 1;
    frame.size.height = cubeView.frame.size.height + 1;
    [cubeView setFrame:frame];
}
- (UIView*)generateCube:(Record*)record
{
    int duration = [record.endTime intValue] - [record.startTime intValue];
    UIView* cube = [[UIView alloc]initWithFrame:CGRectMake(arc4random()% 300 , 0, 20 + duration, 20 + duration)];
    CGFloat cubeWidth =cube.frame.size.width;
    CGFloat cubeHeight = cube.frame.size.height;
    UILabel* durationLabel  = [[UILabel alloc]initWithFrame:CGRectMake(cubeWidth * 0.4, cubeWidth*0.4, cubeWidth* 0.6, cubeHeight*0.6)];
    [durationLabel setText:[NSString stringWithFormat:@"%d",duration ]];
    [durationLabel setTextColor:[UIColor whiteColor]];
    [cube addSubview:durationLabel];
    [cube setBackgroundColor:[self randomColor]];
    return cube;
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
    self.isCouting = NO;
    //Motion
    MotionMonitor * montion = [[MotionMonitor alloc]init];
    Counter* counter = [[Counter alloc]init];
    
    [montion addListener:self usingBlock:^(NSNotification * notification) {
        NSString* type = [notification.userInfo objectForKey:@"type"];
        if([type isEqualToString:MOTION_UP]){
            [counter startCount];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self drawCube];
            });
            //TODO ,save data
        }
        else if([type isEqualToString:MOTION_OTHER]){
            [counter stopCount];
            self.isCouting = NO;
            [self.timer invalidate];
            Record* record = [[Record alloc]init];
            record.recordID = [[NSNumber alloc]initWithDouble:NSTimeIntervalSince1970];
            record.endTime =  [[NSNumber alloc]initWithDouble:counter.endTime];
            record.startTime = [[NSNumber alloc]initWithDouble:counter.startTime];
            record.recordDescription = @"Well,Test Data";
            //[Record addRecord:record belongsToDate:self.currentDayContainer.date];
            //NSTimeInterval duration = counter.duration;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dropCube];
            });
            //NSLog(@"%@",[[[DayContainer getAllDayContainer] firstObject]valueForKey:@"record"]);
        }
    }];
    [montion startMonitor];
    
#pragma CollectionView DataSource
    collectionCellConfigure configureBlock = ^(id cell,id item,NSInteger idx){
        ItemCell* itemcell = (ItemCell*)cell;
        DayContainer* cellDayContainer = (DayContainer*)item;
        UILabel* recordCount = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, 200)];
        NSString* count = [NSString stringWithFormat:@"%lu",(unsigned long)[cellDayContainer.record count]];
        
        for(Record* recordItem in cellDayContainer.record){
                UIView* temp = [self generateCube:recordItem];
                //[self.dropBehaviour addItem:temp];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.dropBehaviour addItem:temp];
                });
                [itemcell addSubview:temp];
        }
        [recordCount setTextColor:[UIColor whiteColor]];
        [recordCount setText:count];
        [itemcell addSubview:recordCount];
        NSString* date = cellDayContainer.date;
        UILabel* title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, 80)];
        [title setFont:[UIFont fontWithName:@"Helvetica" size:37]];
        [title setText:date];
        [title setTextColor:[UIColor whiteColor]];
        [itemcell addSubview:title];
        [itemcell setBackgroundColor:[UIColor blackColor]];
    };
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DATE_FORMATE];
    DayContainer* todayContainer = [[DayContainer searchDayContainer:@"date" withValue:[dateFormatter stringFromDate:[NSDate date]]] firstObject];
    if(!todayContainer){
        DayContainer* dayContainer = [[DayContainer alloc]init];
        dayContainer.dayID = [[NSNumber alloc]initWithDouble:NSTimeIntervalSince1970];
        dayContainer.date = [dateFormatter stringFromDate:[NSDate date]];
        dayContainer.record = [[NSMutableArray alloc]initWithCapacity:0];
        [DayContainer addDayContainer:dayContainer];
    }
    [[UIApplication sharedApplication]setIdleTimerDisabled:YES];
    self.results = [DayContainer getAllDayContainer];
    self.currentDayContainer = [self.results firstObject];
    self.recordDataSource = [[ArrayDataSource alloc]initWithItems:self.results cellIdentifier:@"cell" cellConfigurateBlock:configureBlock];
    self.myCollection.dataSource = self.recordDataSource;
    
    //[da removeDataFile];
    //[DayContainer searchDayContainer:@1];
}
-(void)refreshData
{
}
@end
