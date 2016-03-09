//
//  TVStaticTableViewController.m
//  TVExample
//
//  Created by zhoujr on 15/12/22.
//  Copyright © 2015年 Topvogues. All rights reserved.
//

#import "TVStaticTableViewController.h"

@interface TVStaticTableViewController ()

@property (nonatomic, strong) NSMutableIndexSet *hiddenSections;  // NSIndexSet 内部已经排序(+)
@property (nonatomic, strong) NSMutableArray <NSIndexPath *> *hiddenRows;   // 插入新数据时已经排序(+)
@property (nonatomic, strong) NSMutableDictionary <NSIndexPath *, NSNumber *> *rowHeightDict;
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, NSNumber *> *sectionHeaderHeightDict;
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, NSNumber *> *sectionFooterHeightDict;

@end

@implementation TVStaticTableViewController

#pragma mark - Getter/Setter
- (NSMutableIndexSet *)hiddenSections
{
    if (!_hiddenSections)
    {
        _hiddenSections = [NSMutableIndexSet indexSet];
    }
    return _hiddenSections;
}

- (NSMutableArray<NSIndexPath *> *)hiddenRows
{
    if (!_hiddenRows)
    {
        _hiddenRows = [NSMutableArray array];
    }
    return _hiddenRows;
}

- (NSMutableDictionary<NSIndexPath *,NSNumber *> *)rowHeightDict
{
    if (!_rowHeightDict)
    {
        _rowHeightDict = [NSMutableDictionary dictionary];
    }
    return _rowHeightDict;
}

- (NSMutableDictionary<NSNumber *,NSNumber *> *)sectionHeaderHeightDict
{
    if (!_sectionHeaderHeightDict)
    {
        _sectionHeaderHeightDict = [NSMutableDictionary dictionary];
    }
    return _sectionHeaderHeightDict;
}

- (NSMutableDictionary<NSNumber *,NSNumber *> *)sectionFooterHeightDict
{
    if (!_sectionFooterHeightDict)
    {
        _sectionFooterHeightDict = [NSMutableDictionary dictionary];
    }
    return _sectionFooterHeightDict;
}

#pragma mark - Public Interface
- (void)insertSections:(NSIndexSet *)sections
{
    [self.hiddenSections removeIndexes:sections];
}

- (void)deleteSections:(NSIndexSet *)sections
{
    [self.hiddenSections addIndexes:sections];
}

- (void)insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.hiddenRows removeObject:obj];
    }];
}

- (void)deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![self isIndexPathHidden:obj])
        {
            [self.hiddenRows addObject:obj];
        }
    }];
    
    self.hiddenRows = [[self.hiddenRows sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
}

- (void)insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    NSMutableIndexSet *actionSections = [NSMutableIndexSet indexSet];
    [sections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self isSectionHidden:idx])
        {
            [actionSections addIndex:idx];
        }
    }];
    
    [actionSections enumerateIndexesUsingBlock:^(NSUInteger section, BOOL * _Nonnull stop) {
        [self insertSections:[NSIndexSet indexSetWithIndex:section]];
        
        NSIndexSet *targetSections = [NSIndexSet indexSetWithIndex:[self recoverSection:section]];
        [self.tableView insertSections:targetSections withRowAnimation:animation];
    }];
}

- (void)deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    NSMutableIndexSet *actionSections = [[NSMutableIndexSet alloc] initWithIndexSet:sections];
    [actionSections removeIndexes:self.hiddenSections];
    
    [actionSections enumerateIndexesUsingBlock:^(NSUInteger section, BOOL * _Nonnull stop) {
        [self deleteSections:[NSIndexSet indexSetWithIndex:section]];
        
        NSIndexSet *targetSections = [NSIndexSet indexSetWithIndex:[self recoverSection:section]];
        [self.tableView deleteSections:targetSections withRowAnimation:animation];
    }];
}

- (void)insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    NSMutableArray <NSIndexPath *> *actionIndexPaths = [NSMutableArray arrayWithCapacity:indexPaths.count];
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self isIndexPathHidden:obj])
        {
            [actionIndexPaths addObject:obj];
        }
    }];
    
    [actionIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
        [self insertRowsAtIndexPaths:@[indexPath]];
        
        NSIndexPath *targetIndexPath = [self recoverIndexPath:indexPath];
        [self.tableView insertRowsAtIndexPaths:@[targetIndexPath] withRowAnimation:animation];
    }];
}

- (void)deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    NSMutableArray <NSIndexPath *> *actionIndexPaths = [NSMutableArray arrayWithArray:indexPaths];
    [actionIndexPaths removeObjectsInArray:self.hiddenRows];
    
    NSMutableIndexSet *filterIndexes = [NSMutableIndexSet indexSet];
    [actionIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self.hiddenSections containsIndex:obj.section])
        {
            [filterIndexes addIndex:idx];
        }
    }];
    
    if (filterIndexes.count > 0)
    {
        [actionIndexPaths removeObjectsAtIndexes:filterIndexes];
    }
    
    [actionIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
        [self deleteRowsAtIndexPaths:@[indexPath]];
        
        NSIndexPath *targetIndexPath = [self recoverIndexPath:indexPath];
        [self.tableView deleteRowsAtIndexPaths:@[targetIndexPath] withRowAnimation:animation];
    }];
}

#pragma mark - Height
- (void)setRowHeight:(CGFloat)rowHeight forIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath)
    {
        self.rowHeightDict[indexPath] = @(rowHeight);
    }
}

- (void)setHeaderHeight:(CGFloat)headerHeight forSection:(NSInteger)section
{
    self.sectionHeaderHeightDict[@(section)] = @(headerHeight);
}

- (void)setFooterHeight:(CGFloat)footerHeight forSection:(NSInteger)section
{
    self.sectionFooterHeightDict[@(section)] = @(footerHeight);
}

#pragma mark - Table View Controller
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [super tableView:tableView indentationLevelForRowAtIndexPath:[self convertIndexPath:indexPath]];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [super tableView:tableView titleForHeaderInSection:[self convertSection:section]];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return [super tableView:tableView titleForFooterInSection:[self convertSection:section]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *realIndexPath = [self convertIndexPath:indexPath];
    NSNumber *height = _rowHeightDict[realIndexPath];
    if (height)
    {
        return [height floatValue];
    }
    else
    {
        return [super tableView:tableView heightForRowAtIndexPath:realIndexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSInteger realSection = [self convertSection:section];
    NSNumber *height = _sectionHeaderHeightDict[@(realSection)];
    if (height)
    {
        return [height floatValue];
    }
    else
    {
        return [super tableView:tableView heightForHeaderInSection:realSection];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSInteger realSection = [self convertSection:section];
    NSNumber *height = _sectionFooterHeightDict[@(realSection)];
    if (height)
    {
        return [height floatValue];
    }
    else
    {
        return [super tableView:tableView heightForFooterInSection:realSection];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [super numberOfSectionsInTableView:tableView] - self.hiddenSections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger realSection = [self convertSection:section];
    
    NSInteger count = 0;
    for (NSIndexPath *indexPath in self.hiddenRows)
    {
        if (indexPath.section == realSection)
        {
            ++count;
        }
    }
    
    return [super tableView:tableView numberOfRowsInSection:realSection] - count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [super tableView:tableView cellForRowAtIndexPath:[self convertIndexPath:indexPath]];
}

#pragma mark - Util Functions
- (NSInteger)convertSection:(NSInteger)section
{
    __block NSInteger ret = section;
    [self.hiddenSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx <= ret)
        {
            ++ret;
        }
    }];
    return ret;
}

- (NSIndexPath *)convertIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = [self convertSection:indexPath.section];

    for (NSIndexPath *item in self.hiddenRows)
    {
        if (item.section == section
            && item.row <= row)
        {
            ++row;
        }
    }
    
    return [NSIndexPath indexPathForRow:row inSection:section];
}

- (NSInteger)recoverSection:(NSInteger)section
{
    __block NSInteger ret = section;
    
    [self.hiddenSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < section)
        {
            --ret;
        }
    }];
    
    return ret;
}

- (NSIndexPath *)recoverIndexPath:(NSIndexPath *)indexPath
{
    __block NSInteger row = indexPath.row;
    NSInteger section = [self recoverSection:indexPath.section];
    
    [self.hiddenRows enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.section == indexPath.section
            && obj.row < indexPath.row)
        {
            --row;
        }
    }];
    
    return [NSIndexPath indexPathForRow:row inSection:section];
}

- (BOOL)isSectionHidden:(NSInteger)section
{
    return [self.hiddenSections containsIndex:section];
}

- (BOOL)isIndexPathHidden:(NSIndexPath *)indexPath
{
    return [self.hiddenRows containsObject:indexPath];
}

@end
