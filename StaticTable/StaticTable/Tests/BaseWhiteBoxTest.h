//
//  BaseWhiteBoxTest.h
//  StaticTable
//
//  Created by zhoujinrui on 16/3/9.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "BaseSingleSectionTest.h"

@interface TVStaticTableViewController ()

@property (nonatomic, strong) NSMutableIndexSet *hiddenSections;  // NSIndexSet 内部已经排序(+)
@property (nonatomic, strong) NSMutableArray <NSIndexPath *> *hiddenRows;   // 插入新数据时已经排序(+)
@property (nonatomic, strong) NSMutableDictionary <NSIndexPath *, NSNumber *> *rowHeightDict;
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, NSNumber *> *sectionHeaderHeightDict;
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, NSNumber *> *sectionFooterHeightDict;

@end

@interface BaseWhiteBoxTest : BaseSingleSectionTest

- (NSArray<NSString *> *)allTestSelectors;
- (void)testWithIndex:(NSNumber *)index;

@end
