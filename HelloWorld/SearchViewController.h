//
//  SearchViewController.h
//  HelloWorld
//
//  Created by Emi on 30/6/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface SearchViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>{
	
	NSXMLParser *rssParser;
	NSMutableArray *articles;
	NSMutableDictionary *item;
	NSString *currentElement;
	NSMutableString *ElementValue;
	BOOL errorParsing;
	

}

@property (weak, nonatomic) IBOutlet UITextField *ProfileNameTxt;
@property (weak, nonatomic) IBOutlet UITextField *UserNameTxt;
@property (weak, nonatomic) IBOutlet UITableView *SearchTableView;
@property (strong, nonatomic) IBOutlet UILabel *Type;
@property (nonatomic, retain) IBOutlet UIView *SView;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *Swipe;



- (IBAction)BackBtn:(id)sender;
- (IBAction)displayOldView:(id)sender;
- (IBAction)LogoutBtn:(id)sender;
- (IBAction)AddBtn:(id)sender;
- (IBAction)UploadBtn:(id)sender;


- (IBAction)SearchBtn:(id)sender;
- (IBAction)TxtDidEnd:(id)sender;
- (void)parseXMLFileAtURL;
- (IBAction)upload:(id)sender;



@end
