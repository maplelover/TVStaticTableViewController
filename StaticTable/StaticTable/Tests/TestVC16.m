//
//  TestVC16.m
//  StaticTable
//
//  Created by zhoujinrui on 16/3/9.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "TestVC16.h"

@implementation TestVC16

- (NSArray<NSString *> *)allTestSelectors
{
    return @[
             @"testBaseSectionInfo",
             @"testHiddenSectionCount",
             ];
}

- (void)testBaseSectionInfo
{
    assert(self.hiddenSections.count == 0);
    assert(self.hiddenRows.count == 0);
    assert([self.tableView numberOfSections] == 5);
    assert([self.tableView numberOfRowsInSection:0] == 3);
    assert([self.tableView numberOfRowsInSection:1] == 3);
    assert([self.tableView numberOfRowsInSection:2] == 3);
    assert([self.tableView numberOfRowsInSection:3] == 3);
    assert([self.tableView numberOfRowsInSection:4] == 3);
}

- (void)testHiddenSectionCount
{
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSetWithIndex:0];
    [self deleteSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    assert(self.hiddenSections.count == 1);
    assert([self.tableView numberOfSections] == 4);
    assert([self.hiddenSections containsIndex:0]);
    {
        for (int orginal = 0; orginal < [self.tableView numberOfSections]; ++orginal)
        {
            NSInteger convert = [self convertSection:orginal];
            NSInteger result = orginal + 1;
            NSInteger recover = [self recoverSection:convert];
            assert(result == convert);
            assert(recover == orginal);
        }
    }
    
    [self insertSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    assert(self.hiddenSections.count == 0);
    {
        for (int orginal = 0; orginal < [self.tableView numberOfSections]; ++orginal)
        {
            NSInteger convert = [self convertSection:orginal];
            NSInteger result = orginal;
            NSInteger recover = [self recoverSection:convert];
            assert(result == convert);
            assert(recover == orginal);
        }
    }
    
    [indexSet addIndexesInRange:NSMakeRange(0, 3)];
    [self deleteSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    assert(self.hiddenSections.count == 3);
    assert([self.tableView numberOfSections] == 2);
    assert([self.hiddenSections containsIndex:0]);
    assert([self.hiddenSections containsIndex:1]);
    assert([self.hiddenSections containsIndex:2]);
    {
        for (int orginal = 0; orginal < [self.tableView numberOfSections]; ++orginal)
        {
            NSInteger convert = [self convertSection:orginal];
            NSInteger result = orginal + 3;
            NSInteger recover = [self recoverSection:convert];
            assert(result == convert);
            assert(recover == orginal);
        }
    }
    
    [indexSet addIndexesInRange:NSMakeRange(0, 5)];
    [self deleteSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    assert(self.hiddenSections.count == 5);
    assert([self.tableView numberOfSections] == 0);
    
    [indexSet removeIndex:1];
    [indexSet removeIndex:2];
    [indexSet removeIndex:4];
    [self insertSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic]; // 0, 3
    assert(self.hiddenSections.count == 3);
    assert([self.tableView numberOfSections] == 2);
    {
        for (int orginal = 0; orginal < 2; ++orginal)
        {
            NSInteger convert = [self convertSection:orginal];
            NSInteger result = 0==orginal ? 0 : 3;
            NSInteger recover = [self recoverSection:convert];
            assert(result == convert);
            assert(recover == orginal);
        }
    }
    
    NSArray<NSIndexPath *> *indexPaths = @[
                                           [NSIndexPath indexPathForRow:1 inSection:0],
                                           [NSIndexPath indexPathForRow:1 inSection:1],
                                           [NSIndexPath indexPathForRow:1 inSection:2],
                                           [NSIndexPath indexPathForRow:2 inSection:3],
                                           [NSIndexPath indexPathForRow:1 inSection:4],
                                           ];
    [self deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    assert(self.hiddenSections.count == 3);
    assert(self.hiddenRows.count == 2);
}

@end
