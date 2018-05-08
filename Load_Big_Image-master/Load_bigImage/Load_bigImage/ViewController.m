//
//  ViewController.m
//  加载高清大图
//
//  Created by H on 17/1/12.
//  Copyright © 2017年 H. All rights reserved.
//  思路:
// 分析卡顿原因:  runloop转一圈的时间太长了!!
// 因为一次Runloop循环需要解析18张大图!!很卡!!
// 接下来我要做:让runloop一次循环只解析一张大图!!!



#import "ViewController.h"
//#import "ViewController2.h"
//定义一个Block
typedef void(^RunloopBlock)(void);

static NSString * IDENTIFIER = @"IDENTIFIER";
static CGFloat CELL_HEIGHT = 135.f;

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *exampleTableView;

@property(nonatomic,strong)NSMutableArray * tasks;
/** 最大任务数 */
@property(assign,nonatomic)NSUInteger maxQueueLenght;



@end

@implementation ViewController

-(void)timerMethod{
    //啥都不干!!
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
    
    
    
             //注册Cell
    [self.exampleTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:IDENTIFIER];
    
    _tasks = [NSMutableArray array];
    _maxQueueLenght = 108;
    
    [self addRunloopObserver];
    
    
   
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    //让runloop长存
    //如果注释了下面这一行，子线程中的任务并不能正常执行
//    [[NSRunLoop currentRunLoop] addPort:[NSMachPort port] forMode:NSRunLoopCommonModes];
//    NSLog(@"启动RunLoop前--%@",[NSRunLoop currentRunLoop].currentMode);
//    [[NSRunLoop currentRunLoop] run];
}

//MARK: 内部实现方法

//添加文字
+(void)addlabel:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 300, 25)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor redColor];
    label.text = [NSString stringWithFormat:@"%zd - Drawing index is top priority", indexPath.row];
    label.font = [UIFont boldSystemFontOfSize:13];
    label.tag = 4;
    [cell.contentView addSubview:label];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 99, 300, 35)];
    label1.lineBreakMode = NSLineBreakByWordWrapping;
    label1.numberOfLines = 0;
    label1.backgroundColor = [UIColor clearColor];
    label1.textColor = [UIColor colorWithRed:0 green:100.f/255.f blue:0 alpha:1];
    label1.text = [NSString stringWithFormat:@"%zd - Drawing large image is low priority. Should be distributed into different run loop passes.", indexPath.row];
    label1.font = [UIFont boldSystemFontOfSize:13];
    label1.tag = 5;
    [cell.contentView addSubview:label1];

}


//加载第一张
+(void)addImage1With:(UITableViewCell *)cell{
    //第一张
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 20, 85, 85)];
    imageView.tag = 1;
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"spaceship" ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path1];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = image;
    [UIView transitionWithView:cell.contentView duration:0.3 options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve) animations:^{
        [cell.contentView addSubview:imageView];
    } completion:nil];
}



//加载第二张
+(void)addImage2With:(UITableViewCell *)cell{
    //第二张
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(105, 20, 85, 85)];
    imageView1.tag = 2;
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"spaceship" ofType:@"png"];
    UIImage *image1 = [UIImage imageWithContentsOfFile:path1];
    imageView1.contentMode = UIViewContentModeScaleAspectFit;
    imageView1.image = image1;
    [UIView transitionWithView:cell.contentView duration:0.3 options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve) animations:^{
        [cell.contentView addSubview:imageView1];
    } completion:nil];
}
//加载第三张
+(void)addImage3With:(UITableViewCell *)cell{
    //第三张
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(200, 20, 85, 85)];
    imageView2.tag = 3;
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"spaceship" ofType:@"png"];
    UIImage *image2 = [UIImage imageWithContentsOfFile:path1];
    imageView2.contentMode = UIViewContentModeScaleAspectFit;
    imageView2.image = image2;
    [UIView transitionWithView:cell.contentView duration:0.3 options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve) animations:^{
        [cell.contentView addSubview:imageView2];
    } completion:nil];
}

//MARK:  UI初始化方法
//设置tableview大小
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.exampleTableView.frame = self.view.bounds;
}

//Cell 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

//加载tableview
- (void)loadView {
    self.view = [UIView new];
    self.exampleTableView = [UITableView new];
    self.exampleTableView.delegate = self;
    self.exampleTableView.dataSource = self;
    [self.view addSubview:self.exampleTableView];
}

#pragma mark - <tableview>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    //干掉contentView上面的子控件!! 节约内存!!
    for (NSInteger i = 1; i <= 5; i++) {
        //干掉contentView 上面的所有子控件!!
        [[cell.contentView viewWithTag:i] removeFromSuperview];
    }
    //添加文字
    [ViewController addlabel:cell indexPath:indexPath];
    //添加图片
    [self addTask:^{
        [ViewController addImage1With:cell];
    }];
    
    [self addTask:^{
        [ViewController addImage2With:cell];
    }];
    [self addTask:^{
        [ViewController addImage3With:cell];
    }];
    
    return cell;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    ViewController2 * vc = [ViewController2 new];
//    [self presentViewController:vc animated:YES completion:nil];
}


#pragma mark - <关于Runloop的代码>

-(void)addTask:(RunloopBlock)task{
    //添加任务到数组!!
    [self.tasks addObject:task];
    if (self.tasks.count > self.maxQueueLenght) {
        [self.tasks removeObjectAtIndex:0];
    }
}

//添加Runloop观察者!!  CoreFoundtion 里面 Ref (引用)指针!!
-(void)addRunloopObserver{
    //拿到当前的runloop
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    //定义一个context
    CFRunLoopObserverContext context = {
        0,
        (__bridge void *)(self),
        &CFRetain,
        &CFRelease,
        NULL,
    };
    
    //定义观察
    static CFRunLoopObserverRef defaultModeObserver;
    //创建观察者
    defaultModeObserver = CFRunLoopObserverCreate(NULL, kCFRunLoopBeforeWaiting, YES, 0, &Callback, &context);
    //添加当前runloop的观察者!!
    CFRunLoopAddObserver(runloop, defaultModeObserver, kCFRunLoopCommonModes);
    //C 语言里面Create相关的函数!创建出来的指针!需要释放
    CFRelease(defaultModeObserver);
}

static void Callback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    NSLog(@"%lu---------------%@",activity,info);
    //拿到控制器
    ViewController * vc = (__bridge ViewController *)info;
    if (vc.tasks.count == 0) {
        return;
    }
    RunloopBlock task = vc.tasks.firstObject;
    task();
    //干掉第一个任务
    [vc.tasks removeObjectAtIndex:0];
}



@end

