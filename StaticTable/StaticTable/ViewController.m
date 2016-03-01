//
//  ViewController.m
//  StaticTable
//
//  Created by zhoujinrui on 16/3/1.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *animationSegment;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self deleteRowsAtIndexPaths:@[self.showHideIndexPath1]];
}

- (NSIndexPath *)showHideIndexPath1
{
    return [NSIndexPath indexPathForRow:0 inSection:0];
}

- (NSIndexPath *)showHideIndexPath2
{
    return [NSIndexPath indexPathForRow:1 inSection:0];
}

- (NSIndexPath *)rowHeightIndexPath
{
    return [NSIndexPath indexPathForRow:2 inSection:0];
}

- (BOOL)isReloadWithAnimation
{
    return self.animationSegment.selectedSegmentIndex == 0;
}

- (IBAction)testShowHide:(UIButton *)sender
{
    sender.selected = ![sender isSelected];
    
    if ([sender isSelected])
    {
        if ([self isReloadWithAnimation])
        {
            [self insertRowsAtIndexPaths:@[self.showHideIndexPath1, self.showHideIndexPath2] withRowAnimation:UITableViewRowAnimationFade];
        }
        else
        {
            [self insertRowsAtIndexPaths:@[self.showHideIndexPath1, self.showHideIndexPath2]];
            [self.tableView reloadData];
        }
    }
    else
    {
        if ([self isReloadWithAnimation])
        {
            [self deleteRowsAtIndexPaths:@[self.showHideIndexPath1, self.showHideIndexPath2] withRowAnimation:UITableViewRowAnimationFade];
        }
        else
        {
            [self deleteRowsAtIndexPaths:@[self.showHideIndexPath1, self.showHideIndexPath2]];
            [self.tableView reloadData];
        }
    }
}

- (IBAction)testRowHeight:(UIButton *)sender
{
    sender.selected = ![sender isSelected];
    
    if ([sender isSelected])
    {
        [self setRowHeight:200 forIndexPath:self.rowHeightIndexPath];
    }
    else
    {
        [self setRowHeight:56 forIndexPath:self.rowHeightIndexPath];
    }
    
    if ([self isReloadWithAnimation])
    {
        [self.tableView beginUpdates];
        [self.tableView reloadData];
        [self.tableView endUpdates];
    }
    else
    {
        [self.tableView reloadData];
    }
}

@end
