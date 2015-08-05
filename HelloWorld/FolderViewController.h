//
//  ProfileViewController.h
//  HelloWorld
//
//  Created by Prem on 30/6/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FolderViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>{
	
	NSXMLParser *rssParser;
	NSMutableArray *articles;
	NSMutableArray *PrevArticles;
	NSMutableArray *PathHist;
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
- (void)parseXMLFileAtURL:(NSString *)FolderID;


@end
