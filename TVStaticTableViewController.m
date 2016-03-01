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
    
    [self tv_processSections:actionSections withRowAnimation:animation ignored:NO handler:^(NSIndexSet *targetSections) {
        [self insertSections:actionSections];
        [self.tableView insertSections:targetSections withRowAnimation:animation];
    }];
}

- (void)deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    NSMutableIndexSet *actionSections = [[NSMutableIndexSet alloc] initWithIndexSet:sections];
    [actionSections removeIndexes:self.hiddenSections];
    
    [self tv_processSections:actionSections withRowAnimation:animation ignored:YES handler:^(NSIndexSet *targetSections) {
        [self deleteSections:actionSections];
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
    
    [self tv_processRowsAtIndexPaths:actionIndexPaths withRowAnimation:animation handler:^(NSArray <NSIndexPath *> *targetIndexPaths) {
        [self insertRowsAtIndexPaths:actionIndexPaths];
        [self.tableView insertRowsAtIndexPaths:targetIndexPaths withRowAnimation:animation];
    }];
}

- (void)deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    NSMutableArray <NSIndexPath *> *actionIndexPaths = [NSMutableArray arrayWithArray:indexPaths];
    [actionIndexPaths removeObjectsInArray:self.hiddenRows];
    
    [self tv_processRowsAtIndexPaths:actionIndexPaths withRowAnimation:animation handler:^(NSArray <NSIndexPath *> *targetIndexPaths) {
        [self deleteRowsAtIndexPaths:actionIndexPaths];
        [self.tableView deleteRowsAtIndexPaths:targetIndexPaths withRowAnimation:animation];
    }];
}

- (void)tv_processRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation handler:(void (^)(NSArray <NSIndexPath *> *targetIndexPaths))handler
{
    if (indexPaths.count > 0)
    {
        [self.tableView beginUpdates];
        
        NSArray <NSIndexPath *> *targetIndexPaths = [self recoverIndexPaths:indexPaths];
        handler(targetIndexPaths);
        
        [self.tableView endUpdates];
    }
}

// @param ignored 是否忽略计算已经处理过的section
- (void)tv_processSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation ignored:(BOOL)ignored handler:(void (^)(NSIndexSet *targetSections))handler
{
    if (sections.count > 0)
    {
        [self.tableView beginUpdates];
        
        NSIndexSet *targetSections = [self recoverSections:sections ignored:ignored];
        handler(targetSections);
        
        [self.tableView endUpdates];
    }
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
    return [self recoverSection:section ignoredSections:nil];
}

- (NSIndexSet *)recoverSections:(NSIndexSet *)sections ignored:(BOOL)ignored
{
    NSMutableIndexSet *targetSections = [NSMutableIndexSet indexSet];
    
    [sections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * stop) {
        NSUInteger section = [self recoverSection:idx ignoredSections:ignored ? nil : targetSections];
        NSAssert(![targetSections containsIndex:section], @"Unexpected section: %tu", section);
        [targetSections addIndex:section];
    }];
    
    NSAssert(sections.count == targetSections.count, @"Target sections count error: %@", targetSections);
    return targetSections;
}

- (NSInteger)recoverSection:(NSInteger)section ignoredSections:(NSIndexSet *)ignoredSections
{
    __block NSInteger ret = section;
    NSMutableIndexSet *sortedSections = [[NSMutableIndexSet alloc] initWithIndexSet:self.hiddenSections];
    NSAssert(![ignoredSections containsIndex:section], @"Can't recover section-%tu which contains in ignored sections.", section);
    
    [sortedSections removeIndexes:ignoredSections];
    
    [sortedSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < section)
        {
            --ret;
        }
    }];
    
    return ret;
}

- (NSIndexPath *)recoverIndexPath:(NSIndexPath *)indexPath
{
    return [self recoverIndexPath:indexPath ignoredIndexPaths:nil];
}

- (NSArray <NSIndexPath *> *)recoverIndexPaths:(NSArray <NSIndexPath *> *)indexPaths
{
    NSArray <NSIndexPath *> *sortedIndexPaths = [indexPaths sortedArrayUsingSelector:@selector(compare:)];
    
    NSMutableArray <NSIndexPath *> *targetIndexPaths = [NSMutableArray array];
    for (NSIndexPath *item in sortedIndexPaths)
    {
        NSIndexPath *targetIndexPath = [self recoverIndexPath:item ignoredIndexPaths:targetIndexPaths];
        [targetIndexPaths addObject:targetIndexPath];
    }
    
    return targetIndexPaths;
}

- (NSIndexPath *)recoverIndexPath:(NSIndexPath *)indexPath ignoredIndexPaths:(NSArray <NSIndexPath *> *)ignoredIndexPaths
{
    __block NSInteger row = indexPath.row;
    NSInteger section = [self recoverSection:indexPath.section];
    
    NSArray <NSIndexPath *> *sortedRows = self.hiddenRows;
    
    if (sortedRows.count > 0
        && ignoredIndexPaths.count > 0)
    {
        NSMutableArray <NSIndexPath *> *temp = [NSMutableArray arrayWithArray:sortedRows];
        [temp removeObjectsInArray:ignoredIndexPaths];
        sortedRows = temp;
    }
    
    [sortedRows enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
