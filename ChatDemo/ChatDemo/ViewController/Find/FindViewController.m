//
//  FindViewController.m
//  ChatDemo
//
//  Created by acumen on 16/7/27.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import "FindViewController.h"
#import "FriendStatusTableViewController.h"
#import "HeaderFooterView.h"
#import "FindCell.h"

@interface FindViewController ()

@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 20)]];
    
    [self.tableView registerClass:[FindCell class] forCellReuseIdentifier:@"FindCell"];
    [self.tableView registerClass:[HeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"HeaderFooterView"];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    
    self.data = [NSArray arrayWithObjects:
                 @[@{@"title":@"朋友圈",@"pic":@"ff_IconShowAlbum"}],
                 @[@{@"title":@"扫一扫",@"pic":@"ff_IconQRCode"},
                   @{@"title":@"摇一摇",@"pic":@"ff_IconShake"}],
                 @[@{@"title":@"附近的人",@"pic":@"ff_IconLocationService"},
                   @{@"title":@"漂流瓶",@"pic":@"ff_IconBottle"}],
                 @[@{@"title":@"购物",@"pic":@"CreditCard_ShoppingBag"},
                   @{@"title":@"游戏",@"pic":@"MoreGame"}],nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - init



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
    
    [cell setImageWithImageName:icon Title:title];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    if(indexPath.row == 0 && indexPath.section == 0){
        [cell setRightImageViewWithImageName:@"login_avatar_default"];
    }
    
    
    if(indexPath.row == 0){
        [cell setTopLineStyle:SegmentationLineFill];
        if(indexPath.row == ([self.data[indexPath.section] count] - 1)){
            [cell setBottomLineStyle:SegmentationLineFill];
        }
    }
    else {
        [cell setBottomLineStyle:SegmentationLineIndent];
        if(indexPath.row == ([self.data[indexPath.section] count] - 1)){
            [cell setBottomLineStyle:SegmentationLineFill];
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0 && indexPath.section == 0) {
        FriendStatusTableViewController *friendStatusTableVC = [[FriendStatusTableViewController alloc] init];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:friendStatusTableVC animated:YES];
        [self setHidesBottomBarWhenPushed:NO];
    }
    
    
}

#pragma mark - tableView Delegate

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HeaderFooterView"];
    if (_data && _data.count > section) {
//        TLSettingGrounp *group = [_data objectAtIndex:section];
//        [view setText:group.headerTitle];
    }
    return view;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    HeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HeaderFooterView"];
    if (_data && _data.count > section) {
//        TLSettingGrounp *group = [_data objectAtIndex:section];
//        [view setText:group.footerTitle];
    }
    return view;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_data && _data.count > indexPath.section) {
//        TLSettingGrounp *group = [_data objectAtIndex:indexPath.section];
//        TLSettingItem *item = [group itemAtIndex:indexPath.row];
        return BUTTON_HEIGHT;
    }
    return BUTTON_HEIGHT;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_data && _data.count > section) {
//        TLSettingGrounp *group = [_data objectAtIndex:section];
//        if (group.headerTitle == nil) {
//            return section == 0 ? 15.0f : 10.0f;
//        }
        return section == 0 ? 15.0f : 10.0f;
    }
    return 10.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_data && _data.count > section) {
//        TLSettingGrounp *group = [_data objectAtIndex:section];
//        if (group.footerTitle == nil) {
//            return section == _data.count - 1 ? 30.0f : 10.0f;
//        }
        return section == _data.count - 1 ? 30.0f : 10.0f;
    }
    return 10.0f;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
