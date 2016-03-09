//
//  TestVC7.h
//  StaticTable
//
//  Created by zhoujinrui on 16/3/8.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "BaseSingleSectionTest.h"

@interface TestVC7 : BaseSingleSectionTest

@property (nonatomic) BOOL shouldHideBeforeAppear;
@property (nonatomic, getter=isTestFirstHalf) BOOL testFirstHalf;
@property (nonatomic, getter=isAnimated) BOOL animated;

@end
