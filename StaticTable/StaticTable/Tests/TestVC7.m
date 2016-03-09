//
//  TestVC7.m
//  StaticTable
//
//  Created by zhoujinrui on 16/3/8.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "TestVC7.h"

@implementation TestVC7

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.shouldHideBeforeAppear)
    {
        [self deleteRowsAtIndexPaths:[self halfIndexPaths]];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self insertRowsAtIndexPaths:[self allIndexPaths]];
        [self.tableView reloadData];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self testDelete];
        });
    });
}

- (void)testDelete
{
    if ([self isAnimated])
    {
        [self deleteRowsAtIndexPaths:[self halfIndexPaths] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else
    {
        [self deleteRowsAtIndexPaths:[self halfIndexPaths]];
    }
    
    [self.tableView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self testInsert];
    });
}

- (void)testInsert
{
    if ([self isAnimated])
    {
        [self insertRowsAtIndexPaths:[self halfIndexPaths] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else
    {
        [self insertRowsAtIndexPaths:[self halfIndexPaths]];
    }
    
    [self.tableView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self testDelete];
    });
}

- (NSArray<NSIndexPath *> *)halfIndexPaths
{
    NSArray<NSIndexPath *> *list = [self allIndexPaths];
    if ([self isTestFirstHalf])
    {
        return [list subarrayWithRange:NSMakeRange(0, list.count / 2)];
    }
    else
    {
        return [list subarrayWithRange:NSMakeRange(list.count / 2, list.count / 2)];
    }
}

@end
