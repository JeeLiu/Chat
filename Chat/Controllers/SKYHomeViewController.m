//
//  SKYHomeViewController.m
//  Chat
//
//  Created by sky on 14/12/15.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import "SKYHomeViewController.h"
#import "EaseMob.h"
#import "ChineseToPinyin.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"

NSString * const ContactListCell = @"ContactListCell";


@interface SKYHomeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *contactsTableView;

@property (strong, nonatomic) NSMutableArray *contactsSource;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *sectionTitles;

@end

@implementation SKYHomeViewController

#pragma mark -life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSource = [NSMutableArray array];
    _contactsSource = [NSMutableArray array];
    _sectionTitles = [NSMutableArray array];
    
    
    //解决无数据的地方也显示 separator分割线的问题
    self.contactsTableView.tableFooterView = [[UIView alloc] init];
    
    [self reloadDataSource];
    [self setupRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh {
    [self.contactsTableView addHeaderWithTarget:self action:@selector(reloadDataSource)];
}


#pragma mark-UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return 0;
    }
    else
    {
        return [self.dataSource count] + 1;
    }

    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    
    return [[self.dataSource objectAtIndex:(section - 1)] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ContactListCell forIndexPath:indexPath];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        cell.imageView.image = [UIImage imageNamed:@"newFriends"];
        cell.textLabel.text = @"申请与通知";
    } else {
        if (indexPath.section == 0 && indexPath.row == 1) {
            cell.imageView.image = [UIImage imageNamed:@"groupPrivateHeader"];
            cell.textLabel.text = @"群组";
        }
        else{
            EMBuddy *buddy = [[self.dataSource objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
            cell.imageView.image = [UIImage imageNamed:@"chatListCellHead.png"];
            cell.textLabel.text = buddy.username;
        }
    }
    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 || [[self.dataSource objectAtIndex:(section - 1)] count] == 0)
    {
        return 0;
    }
    else{
        return 22;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0 || [[self.dataSource objectAtIndex:(section - 1)] count] == 0)
    {
        return nil;
    }
    
    UIView *contentView = [[UIView alloc] init];
    [contentView setBackgroundColor:[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 22)];
    label.backgroundColor = [UIColor clearColor];
    [label setText:[self.sectionTitles objectAtIndex:(section - 1)]];
    [contentView addSubview:label];
    return contentView;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray * existTitles = [NSMutableArray array];
    //section数组为空的title过滤掉，不显示
    for (int i = 0; i < [self.sectionTitles count]; i++) {
        if ([[self.dataSource objectAtIndex:i] count] > 0) {
            [existTitles addObject:[self.sectionTitles objectAtIndex:i]];
        }
    }
    return existTitles;
}

#pragma mark-UITableViewDelegate

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - private

- (NSMutableArray *)sortDataArray:(NSArray *)dataArray
{
    //建立索引的核心
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    
    [self.sectionTitles removeAllObjects];
    [self.sectionTitles addObjectsFromArray:[indexCollation sectionTitles]];
    
    //返回27，是a－z和＃
    NSInteger highSection = [self.sectionTitles count];
    //tableView 会被分成27个section
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i <= highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
    }
    
    //名字分section
    for (EMBuddy *buddy in dataArray) {
        //getUserName是实现中文拼音检索的核心，见NameIndex类
        NSString *firstLetter = [ChineseToPinyin pinyinFromChineseString:buddy.username];
        NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
        
        NSMutableArray *array = [sortedArray objectAtIndex:section];
        [array addObject:buddy];
    }
    
    //每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(EMBuddy *obj1, EMBuddy *obj2) {
            NSString *firstLetter1 = [ChineseToPinyin pinyinFromChineseString:obj1.username];
            firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
            
            NSString *firstLetter2 = [ChineseToPinyin pinyinFromChineseString:obj2.username];
            firstLetter2 = [[firstLetter2 substringToIndex:1] uppercaseString];
            
            return [firstLetter1 caseInsensitiveCompare:firstLetter2];
        }];
        
        
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
    }
    
    return sortedArray;
}


#pragma mark - dataSource
- (void)reloadDataSource
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"刷新数据...";
    hud.removeFromSuperViewOnHide = YES;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.dataSource removeAllObjects];
        [self.contactsSource removeAllObjects];
        
        NSArray *buddyList = [[EaseMob sharedInstance].chatManager buddyList];
        for (EMBuddy *buddy in buddyList) {
            if (buddy.followState != eEMBuddyFollowState_NotFollowed) {
                [self.contactsSource addObject:buddy];
            }
        }
        
        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
        NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
        if (loginUsername && loginUsername.length > 0) {
            EMBuddy *loginBuddy = [EMBuddy buddyWithUsername:loginUsername];
            [self.contactsSource addObject:loginBuddy];
        }
        
        [self.dataSource addObjectsFromArray:[self sortDataArray:self.contactsSource]];
        
        //防止block捕获self，导致内存泄露
        __weak __typeof(self)weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.contactsTableView reloadData];
        });
    });
    
    [self.contactsTableView headerEndRefreshing];
    [hud hide:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
