//
//  TestSwipeViewViewController.m
//  Docuflo
//
//  Created by Emi on 7/8/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import "TestSwipeViewViewController.h"

@interface TestSwipeViewViewController ()

@end

@implementation TestSwipeViewViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self setUpView];
}

-(void)setUpView
{
	UIView *clipperView = [[UIView alloc] initWithFrame:self.view.frame];
	clipperView.clipsToBounds = YES;
	
	[self.view addSubview:self.bottomView];
	[clipperView addSubview:self.topView];
	[self.maskView addSubview:clipperView];
	[self.view addSubview:self.maskView];
}

#pragma mark - UIScroll Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	CGFloat xDelta = scrollView.contentOffset.x;
	
	self.topView.center = CGPointMake(self.topCenterInitialX + xDelta, self.topView.center.y);
}


#pragma mark - Accessors
-(UIView *)bottomView
{
	if (!_bottomView) {
		_bottomView = [self createTemplateView];
		_bottomView.backgroundColor = [UIColor blackColor];
		((UIView *)[_bottomView.subviews firstObject]).backgroundColor = [UIColor whiteColor];
	}
	
	return _bottomView;
}

-(UIView *)topView
{
	if (!_topView) {
		_topView = [self createTemplateView];
		_topView.backgroundColor = [UIColor whiteColor];
		((UIView *)[_topView.subviews firstObject]).backgroundColor = [UIColor blackColor];
		
		self.topCenterInitialX = _topView.center.x;
	}
	
	return _topView;
}

-(UIScrollView *)maskView
{
	if (!_maskView) {
		_maskView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
		_maskView.contentSize = CGSizeMake(2 * CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
		_maskView.pagingEnabled = YES;
		_maskView.bounces = NO;
		_maskView.showsHorizontalScrollIndicator = NO;
		_maskView.delegate = self;
	}
	
	return _maskView;
}

#pragma mark - View Creation
-(UIView *)createTemplateView
{
	UIView *containerView = [[UIView alloc] initWithFrame:self.view.frame];
	
	UIView *contentView = [UIView new];
	contentView.bounds = CGRectMake(0.0, 0.0, 280., 40.);
	contentView.center = containerView.center;
	
	[containerView addSubview:contentView];
	
	return containerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
