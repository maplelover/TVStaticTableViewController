//
//  TVStaticTableViewController.h
//  TVExample
//
//  Created by zhoujr on 15/12/22.
//  Copyright © 2015年 Topvogues. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 静态表格控制器
 * Dynamically hide rows and sections in static UITableView inside UITableViewController.
 * 参考 https://github.com/k06a/ABStaticTableViewController
 */
@interface TVStaticTableViewController : UITableViewController

- (BOOL)isSectionHidden:(NSInteger)section;
- (BOOL)isIndexPathHidden:(NSIndexPath *)indexPath;

/**
 * 表现层->数据层
 */
- (NSInteger)convertSection:(NSInteger)section;
- (NSIndexPath *)convertIndexPath:(NSIndexPath *)indexPath;

/**
 * 数据层->表现层
 */
- (NSInteger)recoverSection:(NSInteger)section;
- (NSIndexPath *)recoverIndexPath:(NSIndexPath *)indexPath;

/**
 * 需要调用[self.tableView reloadData]以更新TableView
 */
- (void)insertSections:(NSIndexSet *)sections;
- (void)deleteSections:(NSIndexSet *)sections;
- (void)insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;
- (void)deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

/**
 * 不需要调用[self.tableView reloadData]
 */
- (void)insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation;
- (void)deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation;
- (void)insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;
- (void)deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;

/**
 * 设置行高、Header高度、Footer高度
 */
- (void)setRowHeight:(CGFloat)rowHeight forIndexPath:(NSIndexPath *)indexPath;
- (void)setHeaderHeight:(CGFloat)headerHeight forSection:(NSInteger)section;
- (void)setFooterHeight:(CGFloat)footerHeight forSection:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
