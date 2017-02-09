//
//  ViewController.m
//  TodayOfHistory
//
//  Created by #incloud on 17/1/17.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "ViewController.h"
#import "timeTableViewCell.h"
//#import "AFURLSessionManager.h"
//#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"


@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *timeTabelView;
@property (nonatomic, retain) NSMutableArray *titleArray;
@property (nonatomic, retain) NSMutableArray *numArray;
@property (nonatomic, retain) NSMutableArray *descriptionArray;

@end

@implementation ViewController 
{
    int cellCount;
}

-(NSMutableArray *)numArray
{
    if (!_numArray)
    {
        _numArray = [[NSMutableArray alloc] init];
    }
    return _numArray;
}

- (NSMutableArray *)descriptionArray
{
    if (!_descriptionArray)
    {
        _descriptionArray = [[NSMutableArray alloc] init];
    }
    return _descriptionArray;
}

- (NSMutableArray *)titleArray
{
    if (!_titleArray)
    {
        _titleArray = [[NSMutableArray alloc] init];
    }
    return _titleArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    cellCount = 0;
    
    
    UITableView *timeTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    [self.view addSubview:timeTabelView];
    
    timeTabelView.delegate = self;
    timeTabelView.dataSource = self;
    timeTabelView.bounces = NO;
    timeTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.timeTabelView = timeTabelView;
    
    
    
    // 获取代表公历的NSCalendar对象
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取当前日期
    NSDate* dt = [NSDate date];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |  NSCalendarUnitDay |
    NSCalendarUnitHour |  NSCalendarUnitMinute |
    NSCalendarUnitSecond | NSCalendarUnitWeekday;
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components: unitFlags
                                          fromDate:dt];
    NSDictionary *parameters = @{@"key" : @"e91339cf90d6a95f5513aa8faedc97cc",
                                 @"v" : @"1.0",
                                 @"month" : [NSString stringWithFormat:@"%ld",comp.month],
                                 @"day" : [NSString stringWithFormat:@"%ld", comp.day],
                                };
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:@"http://api.juheapi.com/japi/toh" parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
             } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSLog(@"请求成功:%@", responseObject);
            
            NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                    cellCount = (int)[JSON[@"result"] count];
                     for(int i = 0; i < cellCount; i++)
                     {
                         NSString *titleStr = JSON[@"result"][i][@"title"];
                         [self.titleArray addObject:titleStr];
                         NSString *yearStr = JSON[@"result"][i][@"_id"];
                         yearStr = [yearStr substringToIndex:4];
                         [self.numArray addObject:yearStr];
                         NSString *desStr = JSON[@"result"][i][@"des"];
                         [self.descriptionArray addObject:desStr];
                     }
                    [self.timeTabelView reloadData];
                 });
            
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                    NSLog(@"请求失败:%@", error.description);
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return cellCount;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    timeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"timeTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    cell.backgroundColor = [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = self.titleArray[indexPath.row];
    cell.titleLabel.numberOfLines = 0;
    cell.yearLabel.text = self.numArray[indexPath.row];
    cell.contentLabel.text = self.descriptionArray[indexPath.row];
    cell.contentLabel.numberOfLines = 0;
    return cell;
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
