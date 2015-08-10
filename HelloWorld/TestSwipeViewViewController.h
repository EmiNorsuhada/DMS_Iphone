//
//  TestSwipeViewViewController.h
//  Docuflo
//
//  Created by Emi on 7/8/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestSwipeViewViewController : UIViewController <UIScrollViewDelegate>

#pragma mark - UIView
@property (nonatomic) UIView *bottomView;
@property (nonatomic) UIView *topView;
@property (nonatomic) UIScrollView *maskView;

#pragma mark - View Properties
@property (nonatomic) CGFloat topCenterInitialX;


@end
