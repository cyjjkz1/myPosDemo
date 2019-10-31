//
//  BlueToothDevController.m
//  MposDemo
//
//  Created by Ynboo on 2019/10/8.
//  Copyright © 2019 Ynboo. All rights reserved.
//

#import "BlueToothDevController.h"
#import "XLPOSManager.h"
#import "BlueToothProgressVC.h"

@interface BlueToothDevController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, retain) UITableView *tableView;
@property(nonatomic, retain) NSMutableArray *arrayData;

@end

@implementation BlueToothDevController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addsubView];
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"设备列表";
    
    __weak typeof(self) weakSelf = self;
    [[XLPOSManager shareInstance] startSearchDev:60 searchOneDeviceBlcok:^(XLResponseModel *model) {
        [weakSelf.arrayData addObject:model.data[@"pos_name"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    } completeBlock:^(XLResponseModel *model) {
        NSLog(@"%@",model.data);
    }];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //断开搜索
    [[XLPOSManager shareInstance] stopSearchDev];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self layoutSubviews];
}

- (void)addsubView{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.arrayData = [NSMutableArray array];
}

- (void)layoutSubviews{
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    self.tableView.frame = CGRectMake(0, 0, width, height);
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"kArrivedTableCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arrayData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"kArrivedTableCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.arrayData[indexPath.row];
        return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[XLPOSManager shareInstance] stopSearchDev];
    //保存选中的刷卡器
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:self.arrayData[indexPath.row] forKey:@"MposName"];
    [userDefaults synchronize];
    
    BlueToothProgressVC *progressVC = [[BlueToothProgressVC alloc] init];
    progressVC.deviceName = self.arrayData[indexPath.row];
    progressVC.havePos = false;
    [self.navigationController pushViewController:progressVC animated:true];
}

@end
