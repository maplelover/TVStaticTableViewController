//
//  TestVC14.m
//  StaticTable
//
//  Created by zhoujinrui on 16/3/8.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "TestVC14.h"

@implementation TestVC14

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray<NSIndexPath *> *indexPaths = @[
                                           [NSIndexPath indexPathForRow:1 inSection:0],
                                           [NSIndexPath indexPathForRow:2 inSection:0],
                                           [NSIndexPath indexPathForRow:4 inSection:0],
                                           [NSIndexPath indexPathForRow:5 inSection:0],
                                           [NSIndexPath indexPathForRow:7 inSection:0],
                                           ];
    [self deleteRowsAtIndexPaths:indexPaths];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self test];
    });
}

- (void)test
{
    NSArray<NSIndexPath *> *indexPaths = @[
                                           [NSIndexPath indexPathForRow:1 inSection:0],
                                           [NSIndexPath indexPathForRow:4 inSection:0],
                                           [NSIndexPath indexPathForRow:5 inSection:0],
                                           ];
    [self insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
