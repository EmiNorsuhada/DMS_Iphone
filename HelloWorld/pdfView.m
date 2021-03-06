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

@synthesize BtnClose,webView,lbl1,lblApp,lblName,lblIMG;


- (void)viewDidLoad {
	
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize screenSize = rect.size;
    NSLog(@"size: %f", screenSize.height);

	
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(3,130,750,568)];
        lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 770, 120)];
    
    }
    else
    {
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(3,130,320,568)];
        lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 120)];
    }

    
    
	webView.scalesPageToFit = YES;
    webView.delegate = self;
	NSUserDefaults *pdfURL = [NSUserDefaults standardUserDefaults];
	NSString *strURL = [pdfURL stringForKey:@"URL"];
	NSURL *targetURL = [NSURL URLWithString:strURL];
	NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
	[webView loadRequest:request];
	
	[self.view addSubview:webView];
	
	BtnClose = [UIButton buttonWithType:UIButtonTypeCustom];
	BtnClose = [[UIButton alloc] initWithFrame:CGRectMake(4.0, 16.0, 28.0, 28.0)];
	BtnClose.backgroundColor = [UIColor clearColor];
	BtnClose.layer.borderColor = [UIColor clearColor].CGColor;
	BtnClose.layer.borderWidth = 0.5f;
	BtnClose.layer.cornerRadius = 10.0f;
	[BtnClose addTarget:self action:@selector(CloseX) forControlEvents:UIControlEventTouchUpInside];
	[BtnClose setTitle:@"Back" forState:UIControlStateNormal];
	
	BtnClose.highlighted = YES;
	[BtnClose setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
	[self.view addSubview:BtnClose];
    
    NSString *NameValue = [[NSUserDefaults standardUserDefaults]
                           stringForKey:@"NameValue"];
    
    NSString *ImageNameValue = [[NSUserDefaults standardUserDefaults]
                                stringForKey:@"ApplicationNo"];
    
    
    NSString *IdNO = [[NSUserDefaults standardUserDefaults]
                      stringForKey:@"ID"];
    
    
    lbl1.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.7f];
    lbl1.textColor=[UIColor whiteColor];
    lbl1.userInteractionEnabled=NO;
    [self.view addSubview:lbl1];
    
    UILabel *lblNAme = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, 200, 39)];
    lblNAme.font =[UIFont fontWithName:@"HelveticaNeue-Light" size:34];
    lblNAme.textColor=[UIColor whiteColor];
    lblNAme.userInteractionEnabled=NO;
    lblNAme.adjustsFontSizeToFitWidth = YES;
    lblNAme.text =NameValue;
    [self.view addSubview:lblNAme];
    
    lblApp = [[UILabel alloc] initWithFrame:CGRectMake(62, 65, 200, 30)];
    lblApp.textColor=[UIColor whiteColor];
    lblApp.backgroundColor=[UIColor clearColor];
    lblApp.userInteractionEnabled=NO;
    lblApp.text =IdNO;
    [self.view addSubview:lblApp];
    
    lblIMG = [[UILabel alloc] initWithFrame:CGRectMake(62, 85, 200, 30)];
    lblIMG.textColor=[UIColor whiteColor];
    lblIMG.userInteractionEnabled=NO;
    lblIMG.text =ImageNameValue;
    [self.view addSubview:lblIMG];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self
               action:@selector(CloseX)
     forControlEvents:UIControlEventTouchDown];
    button.frame = CGRectMake(4.0, 16.0, 28.0, 28.0);
    UIImage *image = [UIImage imageNamed:@"close.png"];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [self.view addSubview:button];
    
}
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    
//    webView.scrollView.delegate = self; // set delegate method of UISrollView
//   // webView.scrollView.maximumZoomScale = 10000; // set as you want.
//    //webView.scrollView.minimumZoomScale = 1; // set as you want.
//    
//    //// Below two line is for iOS 6, If your app only supported iOS 7 then no need to write this.
//    webView.scrollView.zoomScale = 1.4;
//    //webView.scrollView.zoomScale = 1;
}



-(void)CloseX {
//	NSUserDefaults *pdfURL = [NSUserDefaults standardUserDefaults];
//	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"URL"];
	[self dismissViewControllerAnimated:YES completion: nil];
}

@end
