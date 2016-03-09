//
//  TestVC13.m
//  StaticTable
//
//  Created by zhoujinrui on 16/3/8.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "TestVC13.h"

@interface TestVC13 ()

@property (nonatomic, weak) IBOutlet UILabel *headerLabel;
@property (nonatomic, getter=isPaused) BOOL paused;
@property (nonatomic, getter=isAnimated) BOOL animated;

@end

@implementation TestVC13

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.headerLabel.text = @"全部显示";
    
    [self hideRandom];
}

- (void)hideRandom
{
    NSMutableArray *hiddenIndexPaths = nil;
    NSMutableString *title = nil;
    UITableViewRowAnimation animation = [self isAnimated] ? UITableViewRowAnimationAutomatic : UITableViewRowAnimationNone;

    if (![self isPaused])
    {
        title = [NSMutableString stringWithString:@"隐藏："];
        
        hiddenIndexPaths = [NSMutableArray array];
        [[self allIndexPaths] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (arc4random() % 3 == 0)
            {
                [hiddenIndexPaths addObject:obj];
                [title appendFormat:@"%tu ", idx + 1];
            }
        }];
        
        self.headerLabel.text = @"全部显示";
        [self insertRowsAtIndexPaths:[self allIndexPaths] withRowAnimation:animation];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (![self isPaused])
        {
            self.headerLabel.text = title;
            [self deleteRowsAtIndexPaths:hiddenIndexPaths withRowAnimation:animation];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hideRandom];
        });
    });
}

- (IBAction)pressPauseItem:(UIBarButtonItem *)sender
{
    self.paused = ![self isPaused];
    
    sender.title = [self isPaused] ? @"继续" : @"暂停";
}

- (IBAction)pressAnimationItem:(UIBarButtonItem *)sender
{
    self.animated = ![self isAnimated];
    sender.title = [self isAnimated] ? @"关动画" : @"开动画";
}

@end
