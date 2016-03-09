//
//  TestVC15.m
//  StaticTable
//
//  Created by zhoujinrui on 16/3/8.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "TestVC15.h"

@implementation TestVC15

- (NSArray<NSString *> *)allTestSelectors
{
    return @[
             @"testInitConvertion",
             @"testHiddenRowCount"
             ];
}

- (void)testInitConvertion
{
    [[self allIndexPaths] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath *ret1 = [self convertIndexPath:obj];
        assert([ret1 compare:obj] == NSOrderedSame);
        
        NSIndexPath *ret2 = [self recoverIndexPath:ret1];
        assert([ret1 compare:ret2] == NSOrderedSame);
    }];
}

- (void)testHiddenRowCount
{
    assert(self.hiddenSections.count == 0);
    assert(self.hiddenRows.count == 0);
    
    NSArray<NSIndexPath *> *indexPaths = @[
                                           [NSIndexPath indexPathForRow:1 inSection:0],
                                           [NSIndexPath indexPathForRow:2 inSection:0],
                                           [NSIndexPath indexPathForRow:4 inSection:0],
                                           [NSIndexPath indexPathForRow:5 inSection:0],
                                           [NSIndexPath indexPathForRow:7 inSection:0],
                                           ];
    [self deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    assert(self.hiddenSections.count == 0);
    assert(self.hiddenRows.count == 5);
    {
        NSArray<NSIndexPath *> *items = @[
                                          [NSIndexPath indexPathForRow:0 inSection:0],
                                          [NSIndexPath indexPathForRow:1 inSection:0],
                                          [NSIndexPath indexPathForRow:2 inSection:0],
                                          [NSIndexPath indexPathForRow:3 inSection:0],
                                          [NSIndexPath indexPathForRow:4 inSection:0],
                                          ];
        NSArray<NSIndexPath *> *expects = @[
                                            [NSIndexPath indexPathForRow:0 inSection:0],
                                            [NSIndexPath indexPathForRow:3 inSection:0],
                                            [NSIndexPath indexPathForRow:6 inSection:0],
                                            [NSIndexPath indexPathForRow:8 inSection:0],
                                            [NSIndexPath indexPathForRow:9 inSection:0],
                                            ];
        [items enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull orginal, NSUInteger idx, BOOL * _Nonnull stop) {
            NSIndexPath *convert = [self convertIndexPath:orginal];
            NSIndexPath *result = expects[idx];
            NSIndexPath *recover = [self recoverIndexPath:result];
            assert([result compare:convert] == NSOrderedSame);
            assert([recover compare:orginal] == NSOrderedSame);
        }];
    }
    
    indexPaths = @[
                   [NSIndexPath indexPathForRow:1 inSection:0],
                   [NSIndexPath indexPathForRow:4 inSection:0],
                   [NSIndexPath indexPathForRow:5 inSection:0],
                   ];
    [self insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    assert(self.hiddenRows.count == 2);
    {
        NSArray<NSIndexPath *> *items = @[
                                          [NSIndexPath indexPathForRow:0 inSection:0],
                                          [NSIndexPath indexPathForRow:1 inSection:0],
                                          [NSIndexPath indexPathForRow:2 inSection:0],
                                          [NSIndexPath indexPathForRow:3 inSection:0],
                                          [NSIndexPath indexPathForRow:4 inSection:0],
                                          [NSIndexPath indexPathForRow:5 inSection:0],
                                          [NSIndexPath indexPathForRow:6 inSection:0],
                                          [NSIndexPath indexPathForRow:7 inSection:0],
                                          ];
        NSArray<NSIndexPath *> *expects = @[
                                            [NSIndexPath indexPathForRow:0 inSection:0],
                                            [NSIndexPath indexPathForRow:1 inSection:0],
                                            [NSIndexPath indexPathForRow:3 inSection:0],
                                            [NSIndexPath indexPathForRow:4 inSection:0],
                                            [NSIndexPath indexPathForRow:5 inSection:0],
                                            [NSIndexPath indexPathForRow:6 inSection:0],
                                            [NSIndexPath indexPathForRow:8 inSection:0],
                                            [NSIndexPath indexPathForRow:9 inSection:0],
                                            ];
        [items enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull orginal, NSUInteger idx, BOOL * _Nonnull stop) {
            NSIndexPath *convert = [self convertIndexPath:orginal];
            NSIndexPath *result = expects[idx];
            NSIndexPath *recover = [self recoverIndexPath:result];
            assert([result compare:convert] == NSOrderedSame);
            assert([recover compare:orginal] == NSOrderedSame);
        }];
    }
    
    [self deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    assert(self.hiddenRows.count == 5);
    {
        NSArray<NSIndexPath *> *items = @[
                                          [NSIndexPath indexPathForRow:0 inSection:0],
                                          [NSIndexPath indexPathForRow:1 inSection:0],
                                          [NSIndexPath indexPathForRow:2 inSection:0],
                                          [NSIndexPath indexPathForRow:3 inSection:0],
                                          [NSIndexPath indexPathForRow:4 inSection:0],
                                          ];
        NSArray<NSIndexPath *> *expects = @[
                                            [NSIndexPath indexPathForRow:0 inSection:0],
                                            [NSIndexPath indexPathForRow:3 inSection:0],
                                            [NSIndexPath indexPathForRow:6 inSection:0],
                                            [NSIndexPath indexPathForRow:8 inSection:0],
                                            [NSIndexPath indexPathForRow:9 inSection:0],
                                            ];
        [items enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull orginal, NSUInteger idx, BOOL * _Nonnull stop) {
            NSIndexPath *convert = [self convertIndexPath:orginal];
            NSIndexPath *result = expects[idx];
            NSIndexPath *recover = [self recoverIndexPath:result];
            assert([result compare:convert] == NSOrderedSame);
            assert([recover compare:orginal] == NSOrderedSame);
        }];
    }
    
    indexPaths = @[
                   [NSIndexPath indexPathForRow:3 inSection:0],
                   [NSIndexPath indexPathForRow:6 inSection:0],
                   [NSIndexPath indexPathForRow:9 inSection:0],
                   ];
    [self deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    assert(self.hiddenRows.count == 8);
    {
        NSArray<NSIndexPath *> *items = @[
                                          [NSIndexPath indexPathForRow:0 inSection:0],
                                          [NSIndexPath indexPathForRow:1 inSection:0],
                                          ];
        NSArray<NSIndexPath *> *expects = @[
                                            [NSIndexPath indexPathForRow:0 inSection:0],
                                            [NSIndexPath indexPathForRow:8 inSection:0],
                                            ];
        [items enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull orginal, NSUInteger idx, BOOL * _Nonnull stop) {
            NSIndexPath *convert = [self convertIndexPath:orginal];
            NSIndexPath *result = expects[idx];
            NSIndexPath *recover = [self recoverIndexPath:result];
            assert([result compare:convert] == NSOrderedSame);
            assert([recover compare:orginal] == NSOrderedSame);
        }];
    }
}

@end
