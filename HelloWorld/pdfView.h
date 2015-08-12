//
//  pdfView.h
//  DocufloMBL
//
//  Created by Emi on 23/4/15.
//  Copyright (c) 2015 tfqnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pdfView : UIViewController <UIWebViewDelegate,UIScrollViewDelegate> {
	
	UIButton *BtnClose;
	
}

@property(nonatomic,retain) UIButton* BtnClose;
@property(nonatomic,retain) UIWebView *webView;
@property(nonatomic,retain) UILabel *lbl1,*lblApp,*button,*lblName,*lblIMG;



@end
