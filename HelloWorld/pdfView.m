//
//  pdfView.m
//  DocufloMBL
//
//  Created by Emi on 23/4/15.
//  Copyright (c) 2015 tfqnet. All rights reserved.
//

#import "pdfView.h"
#import "SearchViewController.h"

@implementation pdfView

@synthesize BtnClose;


- (void)viewDidLoad {
	
	
	CGRect rect = [[UIScreen mainScreen] bounds];
	CGSize screenSize = rect.size;
	NSLog(@"size: %f", screenSize.height);
	UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(3,100,320,568)];
	webView.scalesPageToFit = YES;
    
    UINavigationBar *myBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 15, 320, 50)];
    self.navigationItem.title =@"View";
    [self.view addSubview:myBar];
	
	NSUserDefaults *pdfURL = [NSUserDefaults standardUserDefaults];
	NSString *strURL = [pdfURL stringForKey:@"URL"];
	
	NSURL *targetURL = [NSURL URLWithString:strURL];
	NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
	[webView loadRequest:request];
	
	[self.view addSubview:webView];
	
	BtnClose = [UIButton buttonWithType:UIButtonTypeCustom];
	BtnClose = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 70, 40)];
	BtnClose.backgroundColor = [UIColor clearColor];
	BtnClose.layer.borderColor = [UIColor clearColor].CGColor;
	BtnClose.layer.borderWidth = 0.5f;
	BtnClose.layer.cornerRadius = 10.0f;
	[BtnClose addTarget:self action:@selector(CloseX) forControlEvents:UIControlEventTouchUpInside];
	[BtnClose setTitle:@"Back" forState:UIControlStateNormal];
	
	BtnClose.highlighted = YES;
	[BtnClose setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
	[self.view addSubview:BtnClose];
	

	
}



-(void)CloseX {
//	NSUserDefaults *pdfURL = [NSUserDefaults standardUserDefaults];
//	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"URL"];
	[self dismissViewControllerAnimated:YES completion: nil];
}

@end
