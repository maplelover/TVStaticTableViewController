//
//  TVStaticTableViewController.m
//  TVExample
//
//  Created by zhoujr on 15/12/22.
//  Copyright © 2015年 Topvogues. All rights reserved.
//

#import "TVStaticTableViewController.h"

@interface TVStaticTableViewController ()

@property (nonatomic, strong) NSMutableArray <NSNumber *> *sectionsPool;
@property (nonatomic, strong) NSMutableArray <NSIndexPath *> *rowsPool;
@property (nonatomic, strong) NSMutableDictionary <NSIndexPath *, NSNumber *> *rowHeightDict;
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, NSNumber *> *sectionHeaderHeightDict;
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, NSNumber *> *sectionFooterHeightDict;

@end

@implementation TVStaticTableViewController

#pragma mark - Getter/Setter
- (NSMutableArray *)sectionsPool
{
    if (!_sectionsPool)
    {
        _sectionsPool = [NSMutableArray array];
    }
    return _sectionsPool;
}

- (NSArray *)sortedSectionsPool
{
    return [self.sectionsPool sortedArrayUsingSelector:@selector(compare:)];
}

- (NSMutableArray *)rowsPool
{
    if (!_rowsPool)
    {
        _rowsPool = [NSMutableArray array];
    }
    return _rowsPool;
}

- (NSArray *)sortedRowsPool
{
    return [self.rowsPool sortedArrayUsingSelector:@selector(compare:)];
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
    [sections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        [self.sectionsPool removeObject:@(idx)];
    }];
}

- (void)deleteSections:(NSIndexSet *)sections
{
    [sections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        NSNumber *section = @(idx);
        if (![self.sectionsPool containsObject:section])
        {
            [self.sectionsPool addObject:section];
        }
    }];
}

- (void)insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.rowsPool removeObject:obj];
    }];
}

- (void)deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![self.rowsPool containsObject:obj])
        {
            [self.rowsPool addObject:obj];
        }
    }];
}

- (void)insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    [self tv_processSections:sections withRowAnimation:animation handler:^(NSMutableIndexSet *targetSections) {
        [self insertSections:sections];
        [self.tableView insertSections:targetSections withRowAnimation:animation];
    }];
}

- (void)deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    [self tv_processSections:sections withRowAnimation:animation handler:^(NSMutableIndexSet *targetSections) {
        
        [self.sectionsPool enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [targetSections removeIndex:obj.integerValue];
        }];
        
        if (targetSections.count > 0)
        {
            [self deleteSections:sections];
            [self.tableView deleteSections:targetSections withRowAnimation:animation];
        }
    }];
}

- (void)insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    [self tv_processRowsAtIndexPaths:indexPaths withRowAnimation:animation handler:^(NSMutableArray *targetIndexPaths) {
        [self insertRowsAtIndexPaths:indexPaths];
        [self.tableView insertRowsAtIndexPaths:targetIndexPaths withRowAnimation:animation];
    }];
}

- (void)deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    [self tv_processRowsAtIndexPaths:indexPaths withRowAnimation:animation handler:^(NSMutableArray *targetIndexPaths) {
        
        [targetIndexPaths removeObjectsInArray:self.rowsPool];
        
        if (targetIndexPaths.count > 0)
        {
            [self deleteRowsAtIndexPaths:indexPaths];
            [self.tableView deleteRowsAtIndexPaths:targetIndexPaths withRowAnimation:animation];
        }
    }];
}

- (void)tv_processRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation handler:(void (^)(NSMutableArray *targetIndexPaths))handler
{
    [self.tableView beginUpdates];
    
    NSMutableArray *targetIndexPaths = [NSMutableArray array];
    for (NSIndexPath *item in indexPaths)
    {
        [targetIndexPaths addObject:[self recoverIndexPath:item]];
    }
    
    handler(targetIndexPaths);
    
    [self.tableView endUpdates];
}

- (void)tv_processSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation handler:(void (^)(NSMutableIndexSet *targetSections))handler
{
    [self.tableView beginUpdates];
    
    NSMutableIndexSet *targetSections = [NSMutableIndexSet indexSet];
    [sections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * stop) {
        [targetSections addIndex:[self recoverSection:idx]];
    }];
    
    handler(targetSections);
    
    [self.tableView endUpdates];
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
    return [super numberOfSectionsInTableView:tableView] - self.sectionsPool.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger realSection = [self convertSection:section];
    
    NSInteger count = 0;
    for (NSIndexPath *indexPath in self.rowsPool)
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
    for (NSNumber *item in [self sortedSectionsPool])
    {
        if (item.integerValue <= section)
        {
            ++section;
        }
    }
    
    return section;
}

- (NSIndexPath *)convertIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    for (NSIndexPath *item in [self sortedRowsPool])
    {
        if (item.section == indexPath.section
            && item.row <= row)
        {
            ++row;
        }
    }
    
    return [NSIndexPath indexPathForRow:row inSection:indexPath.section];
}

- (NSInteger)recoverSection:(NSInteger)section
{
    for (NSNumber *item in [self sortedSectionsPool])
    {
        if (item.integerValue < section)
        {
            --section;
        }
    }
    
    return section;
}

- (NSIndexPath *)recoverIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    for (NSIndexPath *item in [self sortedRowsPool])
    {
        if (item.section == indexPath.section
            && item.row < row)
        {
            --row;
        }
    }
    
    return [NSIndexPath indexPathForRow:row inSection:indexPath.section];
}

- (BOOL)isSectionVisible:(NSInteger)section
{
    return ![self.sectionsPool containsObject:@(section)];
}

- (BOOL)isIndexPathVisible:(NSIndexPath *)indexPath
{
    return ![self.rowsPool containsObject:indexPath];
}

@end
