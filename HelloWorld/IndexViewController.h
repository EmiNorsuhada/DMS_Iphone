//
//  ProfileViewController.h
//  HelloWorld
//
//  Created by Prem on 30/6/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndexViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>{
	
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


- (IBAction)BackBtn:(id)sender;
- (IBAction)SearchBtn:(id)sender;
- (IBAction)TxtDidEnd:(id)sender;
- (void)parseXMLFileAtURL:(NSString *)URL;

@end
