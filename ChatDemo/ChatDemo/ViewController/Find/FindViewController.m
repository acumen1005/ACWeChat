//
//  FindViewController.m
//  ChatDemo
//
//  Created by acumen on 16/7/27.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import "FindViewController.h"
#import "FriendStatusViewController.h"
#import "HeaderFooterView.h"
#import "FindCell.h"
#import "UITableViewCell+Register.h"

@interface FindViewController ()

@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 20)]];
    
    [FindCell registerClassForTableView:self.tableView];
    [self.tableView registerClass:[HeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"HeaderFooterView"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self initData];
}

#pragma mark - init

- (void)initData {
    self.data = @[@[@{@"title":@"朋友圈",@"pic":@"ff_IconShowAlbum"}],
                  @[@{@"title":@"扫一扫",@"pic":@"ff_IconQRCode"},
                    @{@"title":@"摇一摇",@"pic":@"ff_IconShake"}],
                  @[@{@"title":@"附近的人",@"pic":@"ff_IconLocationService"},
                    @{@"title":@"漂流瓶",@"pic":@"ff_IconBottle"}],
                  @[@{@"title":@"购物",@"pic":@"CreditCard_ShoppingBag"},
                    @{@"title":@"游戏",@"pic":@"MoreGame"}]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FindCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FindCell" forIndexPath:indexPath];
    
    NSString *title = [self.data[indexPath.section][indexPath.row] objectForKey:@"title"];
    NSString *icon = [self.data[indexPath.section][indexPath.row] objectForKey:@"pic"];
    
    [cell setImageWithImageName:icon
                          title:title];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if(indexPath.row == 0 && indexPath.section == 0) {
        [cell setRightImageViewWithImageName:@"login_avatar_default"];
    }
    
    if(indexPath.row == 0) {
        [cell setTopLineStyle:SegmentationLineFill];
        if(indexPath.row == ([self.data[indexPath.section] count] - 1)) {
            [cell setBottomLineStyle:SegmentationLineFill];
        }
    } else {
        [cell setBottomLineStyle:SegmentationLineIndent];
        if(indexPath.row == ([self.data[indexPath.section] count] - 1)) {
            [cell setBottomLineStyle:SegmentationLineFill];
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && indexPath.section == 0) {
        FriendStatusViewController *friendStatusVC = [[FriendStatusViewController alloc] init];
        [friendStatusVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:friendStatusVC animated:YES];
    }
    
}

#pragma mark - tableView Delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HeaderFooterView"];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    HeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HeaderFooterView"];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return BUTTON_HEIGHT;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.data && self.data.count > section) {
        return section == 0 ? 15.0f : 10.0f;
    }
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.data && self.data.count > section) {
        return section == _data.count - 1 ? 30.0f : 10.0f;
    }
    return 10.0f;
}

@end
