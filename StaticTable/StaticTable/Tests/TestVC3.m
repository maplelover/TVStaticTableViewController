//
//  TestVC3.m
//  StaticTable
//
//  Created by zhoujinrui on 16/3/8.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "TestVC3.h"

@implementation TestVC3

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self testDelete];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self testInsert];
    });
}

- (void)testDelete
{
    if ([self isTestSection])
    {
        [self deleteSections:[self allSections]];
    }
    else
    {
        [self deleteRowsAtIndexPaths:[self allIndexPaths]];
    }
}

- (void)testInsert
{
    if ([self isTestSection])
    {
        [self insertSections:[self allSections]];
    }
    else
    {
        [self insertRowsAtIndexPaths:[self allIndexPaths]];
    }
    
    [self.tableView reloadData];
}

@end
