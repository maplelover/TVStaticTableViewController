//
//  BaseWhiteBoxTest.m
//  StaticTable
//
//  Created by zhoujinrui on 16/3/9.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "BaseWhiteBoxTest.h"

@implementation BaseWhiteBoxTest

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self testWithIndex:@(0)];
}

- (NSArray<NSString *> *)allTestSelectors
{
    return nil;
}

- (void)testWithIndex:(NSNumber *)index
{
    NSArray<NSString *> *selectors = [self allTestSelectors];
    NSInteger count = selectors.count;
    
    if (index.integerValue >= count)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"测试通过" message:nil delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    [self insertRowsAtIndexPaths:[self allIndexPaths] withRowAnimation:UITableViewRowAnimationNone];
    
    SEL testFun = NSSelectorFromString(selectors[index.integerValue]);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self performSelector:testFun withObject:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self testWithIndex:@(index.integerValue + 1)];
        });
    });
}

@end
