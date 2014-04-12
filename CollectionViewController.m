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
#import "CubeGestureHandler.h"
#import "Config.h"
#import "CubeView.h"

#define DEBUG_MODE 1
#define RECORD_MOTION @"up"
#define DATE_FORMATE @"yyyy-MM-dd"

@interface CollectionViewController ()
@property  (strong,nonatomic)NSArray* results;
@property (strong,nonatomic)ArrayDataSource* recordDataSource;
@property (strong,nonatomic)NSMutableArray*  recordViewArray;
@property (strong,nonatomic)DayContainer* currentDayContainer;
@property (strong,nonatomic)DropBehaviour* dropBehaviour;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong,nonatomic)NSMutableArray* dropViewArray;
@property (strong,nonatomic)UICollectionViewLayout* layout;
@property (strong,nonatomic)NSTimer* timer;
@property (strong,nonatomic)CubeView* currentCubeView;
@property (strong,nonatomic)ItemCell* currentItemCell;
@property (strong,nonatomic)Counter* counter;
@property (strong,nonatomic)MotionMonitor* motionMonitor;
@property (nonatomic)BOOL   isRunningCubeBlock;
@property (strong,nonatomic)Config* config;
@end
@implementation CollectionViewController


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
}
static const CGSize DROP_SIZE = { 40, 40 };
- (UICollectionView *)myCollection{
    if(!_myCollection){
        UICollectionViewFlowLayout* customLayout = [[collectionFlowLayout alloc]init];
        _myCollection = [[UICollectionView alloc]initWithFrame: CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_HEIGHT)collectionViewLayout:customLayout];
        _myCollection.scrollEnabled = YES;
        //_myCollection.collectionViewLayout = customLayout;
        _myCollection.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundTile"]];
        _myCollection.pagingEnabled = YES;
        _myCollection.bounces = NO;
    }
    return _myCollection;
}
- (NSMutableArray *)recordViewArray
{
    if(!_recordViewArray){
        _recordViewArray = [[NSMutableArray alloc]init];
    }
    return _recordViewArray;
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
        _animator =[[UIDynamicAnimator alloc]initWithCollectionViewLayout:self.layout];
        //_animator =[[UIDynamicAnimator alloc]initWithReferenceView:self.myCollection];
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
    [dropView setBackgroundColor:[Util randomColor]];
    [self.myCollection addSubview:dropView];
    [self.dropViewArray addObject:dropView];
    
    [self.dropBehaviour addItem:dropView];
}
- (void)showCube
{
    
}

- (void)dropCube
{
    [self.dropBehaviour addItem:self.currentCubeView];
}
-(void)drawCube
{
    CubeView* cubeView =[[CubeView alloc]init];
    cubeView.frame = CGRectMake(IPHONE_SCREEN_WIDTH/2 - 20, IPHONE_SCREEN_HEIGHT / 3, 40, 40);
    UILabel* indicator = [[UILabel alloc]init];
    [cubeView setBackgroundColor:[Util randomColor]];
    [cubeView addSubview:indicator];
    [self.myCollection addSubview:cubeView];
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(blinkCube:) userInfo:@{@"view":cubeView} repeats:YES];
    self.currentCubeView = cubeView;
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSDefaultRunLoopMode];
}
- (void)blinkCube:(id)sender{
    NSTimer* timer = (NSTimer*)sender;
    static float alphaCount = 0.5;
    CubeView* cubeView= [timer.userInfo objectForKey:@"view"];
    alphaCount= fmod(alphaCount + 0.05,1);
    [cubeView setAlpha:alphaCount];
}

-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  [self.myCollection reloadData];
}


#pragma Monitor Handler
-(void)handleMonitor:(id)sender{
    NSNotification* notification = (NSNotification*)sender;
    NSString* type = [notification.userInfo objectForKey:@"type"];
    if([type isEqualToString:MOTION_UP]){
        //NSLog(@"Motion Up");
        if(self.counter.status == CounterStop){
            [self.counter startCount];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self drawCube];
            });
        }
    }
    else if([type isEqualToString:MOTION_OTHER]){
        //NSLog(@"Motion Other and isRunningBlock: %d",self.isRunningCubeBlock);
        
        if(self.isRunningCubeBlock || self.counter.status == CounterStop){
            //NSLog(@"Motion other and quit");
            return;
        }
        self.isRunningCubeBlock = YES;
        [self.counter stopCount];
        [self.timer invalidate];
        Record* record = [[Record alloc]init];
        record.recordID = [[NSNumber alloc]initWithDouble:NSTimeIntervalSince1970];
        record.endTime =  [[NSNumber alloc]initWithDouble:self.counter.endTime];
        record.startTime = [[NSNumber alloc]initWithDouble:self.counter.startTime];
        record.recordDescription = @"Well,Test Data";
        NSTimeInterval duration = self.counter.duration;
        //only duration more 30s is count
        if(self.currentCubeView){
            if(duration > self.config.minSecond){
                    [Record addRecord:record belongsToDate:self.currentDayContainer.date];
                    if([(NSString*)[notification.userInfo objectForKey:@"timing"] isEqualToString:TIMING_LASTCALL]){
                        [self.currentCubeView removeFromSuperview];
                    }
                    else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self dropCube];
                        });
                    }
                    DayContainer* dc =[DayContainer getAllDayContainer][0];
                    NSLog(@"Current Data ==> %@",dc.record);
            }
            else{
                //otherwise it should disappear
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        //self.currentCubeView.alpha = 0.0;
                        CGRect cubeFrame = self.currentCubeView.frame;
                        self.currentCubeView.frame= CGRectMake(cubeFrame.origin.x + cubeFrame.size.width/2, cubeFrame.origin.y  + cubeFrame.size.height/2, 0,0);
                    } completion:^(BOOL finished) {
                        [self.currentCubeView removeFromSuperview];
                    }];
                });
            }
        }
        self.isRunningCubeBlock = NO;
    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"view did load");
    //self.myCollection.alwaysBounceHorizontal = YES;

#pragma Motion Stuffs
    self.motionMonitor = [MotionMonitor sharedMotionManager];
    self.counter = [Counter sharedConter];
    
#pragma CollectionView DataSource
    collectionCellConfigure configureBlock = ^(id cell,id item,NSInteger idx){
        ItemCell* itemcell = (ItemCell*)cell;
        DayContainer* cellDayContainer = (DayContainer*)item;
        if((int)idx > 0){
            NSLog(@"stop Monitor");
            [self.motionMonitor stopMonitor];
        }
        else{
            NSLog(@"start Monitor");
            [self.motionMonitor addListener:self withSelector:@selector(handleMonitor:)];
            [self.motionMonitor startMonitor];
        }
        [itemcell configureCell];
        
        for (int i = 0; i < [cellDayContainer.record count]; i++) {
            CubeView* cubeView= [[CubeView alloc]initWithIndex:i];
            [CubeGestureHandler addCubeView:cubeView];
            [self.recordViewArray addObject:cubeView];
            [itemcell addSubview:cubeView];
        }
        
        NSString* count = [NSString stringWithFormat:@"%lu",(unsigned long)[cellDayContainer.record count]];
        itemcell.countLabel.text = count;
        NSString* date = cellDayContainer.date;
        itemcell.timeLabel.text = date;
    };
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DATE_FORMATE];
    DayContainer* todayContainer = [[DayContainer searchDayContainer:@"date" withValue:[dateFormatter stringFromDate:[NSDate date]]] firstObject];
    if(!todayContainer){//if there's the first time entering the app in a day, create a new dayContainer
        DayContainer* dayContainer = [[DayContainer alloc]init];
        dayContainer.dayID = [[NSNumber alloc]initWithDouble:NSTimeIntervalSince1970];
        dayContainer.date = [dateFormatter stringFromDate:[NSDate date]];
        dayContainer.record = [[NSMutableArray alloc]initWithCapacity:0];
        [DayContainer addDayContainer:dayContainer];
    }
    self.results = [DayContainer getAllDayContainer];
    self.currentDayContainer = [self.results firstObject];
    
    self.recordDataSource = [[ArrayDataSource alloc]initWithItems:self.results cellIdentifier:@"cell" cellConfigurateBlock:configureBlock];
    [self.myCollection registerClass:[ItemCell class] forCellWithReuseIdentifier:@"cell"];
    self.myCollection.delegate = self;
    self.myCollection.dataSource = self.recordDataSource;
    [self.view addSubview:self.myCollection];
    
    //prevent app from sleeping
    [[UIApplication sharedApplication]setIdleTimerDisabled:YES];
    
    //DataAbstract* da = [DataAbstract sharedData];
    //[da removeDataFile];
}
@end
