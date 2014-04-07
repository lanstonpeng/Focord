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

-(void)drawCube
{
    UIView* cube = [[UIView alloc]initWithFrame:CGRectMake(IPHONE_SCREEN_WIDTH/2 - 40, IPHONE_SCREEN_HEIGHT / 3, 40, 40)];
    [cube setBackgroundColor:[self randomColor]];
    [self.myCollection addSubview:cube];
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
            Record* record = [[Record alloc]init];
            record.recordID = [[NSNumber alloc]initWithDouble:NSTimeIntervalSince1970];
            record.endTime =  [[NSNumber alloc]initWithDouble:counter.endTime];
            record.endTime = [[NSNumber alloc]initWithDouble:counter.startTime];
            record.recordDescription = @"Well,Test Data";
            //[Record addRecord:record belongsToDate:self.currentDayContainer.date];
            //NSTimeInterval duration = counter.duration;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self drop];
            });
            NSLog(@"%@",[[[DayContainer getAllDayContainer] firstObject]valueForKey:@"record"]);
        }
    }];
    [montion startMonitor];
    collectionCellConfigure configureBlock = ^(id cell,id item,NSInteger idx){
        ItemCell* itemcell = (ItemCell*)cell;
        NSDictionary* dayContainerDic = (NSDictionary*)item;
        UILabel* recordCount = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, 200)];
        NSString* count = [NSString stringWithFormat:@"%lu",(unsigned long)[[dayContainerDic objectForKey:@"record" ] count]];
        [recordCount setTextColor:[UIColor whiteColor]];
        [recordCount setText:count];
        [itemcell addSubview:recordCount];
        NSString* date = [dayContainerDic objectForKey:@"date"];
        UILabel* title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, 80)];
        [title setFont:[UIFont fontWithName:@"Helvetica" size:27]];
        [title setText:date];
        [title setTextColor:[UIColor whiteColor]];
        [itemcell addSubview:title];
        [itemcell setBackgroundColor:[UIColor blackColor]];
    };
    
    DataAbstract* da = [DataAbstract sharedData];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDictionary* todayContainer = [da searchItem:@"date" value:[dateFormatter stringFromDate:[NSDate date]]];
    if(!todayContainer){
        DayContainer* dayContainer = [[DayContainer alloc]init];
        dayContainer.dayID = [[NSNumber alloc]initWithDouble:NSTimeIntervalSince1970];
        dayContainer.date = [dateFormatter stringFromDate:[NSDate date]];
        dayContainer.record = [[NSMutableArray alloc]initWithCapacity:0];
        self.currentDayContainer = [DayContainer addDayContainer:dayContainer];
    }
    
#warning Performance Issue
    self.results = [DayContainer getAllDayContainer];
    [self.currentDayContainer setValuesForKeysWithDictionary:[self.results firstObject]];
    self.recordDataSource = [[ArrayDataSource alloc]initWithItems:self.results cellIdentifier:@"cell" cellConfigurateBlock:configureBlock];
    self.myCollection.dataSource = self.recordDataSource;
    
    /*
    DataAbstract* da = [DataAbstract sharedData];
    [da removeDataFile];
     */
    //[DayContainer searchDayContainer:@1];
}
-(void)refreshData
{
}
@end
