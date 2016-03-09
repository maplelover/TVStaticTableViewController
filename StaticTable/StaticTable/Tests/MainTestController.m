//
//  MainTestController.m
//  StaticTable
//
//  Created by zhoujinrui on 16/3/8.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "MainTestController.h"
#import "BaseSingleSectionTest.h"
#import "TestVC7.h"

@implementation MainTestController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"hideSectionWithoutAnimation"]
        || [segue.identifier isEqualToString:@"hideSectionWithAnimation"]
        || [segue.identifier isEqualToString:@"hideSectionBeforeAppear"])
    {
        BaseSingleSectionTest *vc = segue.destinationViewController;
        vc.testSection = YES;
    }
    else if ([segue.identifier isEqualToString:@"hideFirstHalfWithoutAnimation"])
    {
        TestVC7 *vc = segue.destinationViewController;
        vc.testFirstHalf = YES;
    }
    else if ([segue.identifier isEqualToString:@"hideFirstHalfWithAnimation"])
    {
        TestVC7 *vc = segue.destinationViewController;
        vc.testFirstHalf = YES;
        vc.animated = YES;
    }
    else if ([segue.identifier isEqualToString:@"hideFirstHalfBeforeAppear"])
    {
        TestVC7 *vc = segue.destinationViewController;
        vc.testFirstHalf = YES;
        vc.shouldHideBeforeAppear = YES;
    }
    else if ([segue.identifier isEqualToString:@"hideLaterHalfWithAnimation"])
    {
        TestVC7 *vc = segue.destinationViewController;
        vc.animated = YES;
    }
    else if ([segue.identifier isEqualToString:@"hideLaterHalfBeforeAppear"])
    {
        TestVC7 *vc = segue.destinationViewController;
        vc.shouldHideBeforeAppear = YES;
    }
    
    if ([sender isKindOfClass:UITableViewCell.class])
    {
        UITableViewCell *cell = sender;
        segue.destinationViewController.navigationItem.title = cell.textLabel.text;
    }
}

@end
