//
//  BaseSingleSectionTest.m
//  StaticTable
//
//  Created by zhoujinrui on 16/3/8.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "BaseSingleSectionTest.h"

@implementation BaseSingleSectionTest

- (NSArray<NSIndexPath *> *)allIndexPaths
{
    NSMutableArray<NSIndexPath *> *list = [NSMutableArray array];
    
    for (int i = 0; i < 10; ++i)
    {
        [list addObject:[NSIndexPath indexPathForItem:i inSection:0]];
    }
    
    return list;
}

- (NSIndexSet *)allSections
{
    return [NSIndexSet indexSetWithIndex:0];
}

@end
