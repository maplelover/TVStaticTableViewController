//
//  BaseSingleSectionTest.h
//  StaticTable
//
//  Created by zhoujinrui on 16/3/8.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "TVStaticTableViewController.h"

@interface BaseSingleSectionTest : TVStaticTableViewController

@property (nonatomic, getter=isTestSection) BOOL testSection;

- (NSArray<NSIndexPath *> *)allIndexPaths;
- (NSIndexSet *)allSections;

@end
