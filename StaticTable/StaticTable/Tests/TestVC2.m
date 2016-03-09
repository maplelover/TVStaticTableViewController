//
//  TestVC2.m
//  StaticTable
//
//  Created by zhoujinrui on 16/3/8.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "TestVC2.h"

@implementation TestVC2

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self testDelete];
    });
}

- (void)testDelete
{
    if ([self isTestSection])
    {
        [self deleteSections:[self allSections] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else
    {
        [self deleteRowsAtIndexPaths:[self allIndexPaths] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    [self.tableView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self testInsert];
    });
}

- (void)testInsert
{
    if ([self isTestSection])
    {
        [self insertSections:[self allSections] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else
    {
        [self insertRowsAtIndexPaths:[self allIndexPaths] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    [self.tableView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self testDelete];
    });
}

@end
