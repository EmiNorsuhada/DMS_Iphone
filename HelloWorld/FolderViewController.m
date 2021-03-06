//
//  SearchViewController.m
//  HelloWorld
//
//  Created by Prem on 30/6/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import "ProfileViewController.h"
#import "ModuleViewController.h"
#import "DMSViewController.h"
#import "IndexViewController.h"
#import "FolderViewController.h"
#import "APPViewController.h"
#import "pdfView.h"

@interface FolderViewController  ()

@end

@implementation FolderViewController
@synthesize UserNameTxt,ProfileNameTxt;

int count;
NSString *FolderID;
NSString *FolderName;
NSString *colDesc;
NSString *colData;
NSString *folderDir;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self.SearchTableView sizeToFit];
	[self parseXMLFileAtURL:@"1"];
	folderDir = @"";
	count = 0;
	
	UserNameTxt.text = @"Jacob*";
	PathHist = [[NSMutableArray alloc] init];
	NSDictionary *tempD = [[NSDictionary alloc] initWithObjectsAndKeys:@"", @"FolderName",
							  @"1", @"FolderID",
							  nil];
	[PathHist addObject:[tempD copy]];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self
                   action:@selector(backFolder:)
         forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"Choose the location" forState:UIControlStateNormal];
        button.tag = 1001;
        button.frame = CGRectMake(230, 78, 280, 40);
        [self.view addSubview:button];
    } else
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self
                   action:@selector(backFolder:)
         forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"Choose the location" forState:UIControlStateNormal];
        button.tag = 1001;
        button.frame = CGRectMake(16, 78, 280, 40);
        [self.view addSubview:button];
        
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)BackBtn:(id)sender
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        IndexViewController *controller = [[IndexViewController alloc] initWithNibName:@"IndexViewController_IPAD@" bundle:nil];
        [self presentViewController:controller animated:YES completion:Nil];
    }
    else
    {
        IndexViewController *controller = [[IndexViewController alloc] initWithNibName:@"IndexViewController" bundle:nil];
        [self presentViewController:controller animated:YES completion:Nil];
        
    }

}

- (IBAction)SearchBtn:(id)sender
{
	
	[self parseXMLFileAtURL:@"1"];
	[self.SearchTableView reloadData];
	
	[UserNameTxt resignFirstResponder];
}


- (void)backFolder:(UIButton*)button
{
	
//	NSLog(@"button click");
	if (button.tag == 1001) {
//		button.userInteractionEnabled = true;
		
		if (PathHist.count == 1) {
//			button.userInteractionEnabled = false;
			[button setTitle:@"Choose the location" forState:UIControlStateNormal];
		}
		else if (PathHist.count != 0) {
			
			NSString *fID = [[PathHist objectAtIndex:PathHist.count-2]objectForKey:@"FolderID"];
			NSString *fname = [[PathHist objectAtIndex:PathHist.count-2]objectForKey:@"FolderName"];
			
			if ([fname isEqualToString:@""]) {
//				button.userInteractionEnabled = false;
				[button setTitle:@"Choose the location" forState:UIControlStateNormal];
			}
			else {
//				button.userInteractionEnabled = true;
				NSString *t = [NSString stringWithFormat:@"<  %@", fname];
				[button setTitle:t forState:UIControlStateNormal];
			}

			
			[PathHist removeLastObject];
			[articles removeAllObjects];
			[self parseXMLFileAtURL:fID];
			[self.SearchTableView reloadData];
		}
		
		
	}
}


#pragma mark - XMLParser

- (void)parseXMLFileAtURL:(NSString *)FolderID
{
    NSString *Username = [[NSUserDefaults standardUserDefaults]
                           stringForKey:@"Username"];
    
    NSString *Password = [[NSUserDefaults standardUserDefaults]
                           stringForKey:@"Password"];

    NSString *post = [NSString stringWithFormat:@"UserId=%@&ParentId=%@",@"3",FolderID];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    
    [request setURL:[NSURL URLWithString:@"http://192.168.2.28/DocufloSDK/docuflosdk.asmx/LoadFolderList"]];
    
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSData *urlData;
    NSURLResponse *response;
    NSError *error;
    urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(conn) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }
    NSString *aStr = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    
    

	
	NSData *xmlFile;
	xmlFile = [ NSURLConnection sendSynchronousRequest:request returningResponse: nil error: nil ];
	
	
	articles = [[NSMutableArray alloc] init];
	errorParsing=NO;
	
	rssParser = [[NSXMLParser alloc] initWithData:xmlFile];
	[rssParser setDelegate:self];
	// You may need to turn some of these on depending on the type of XML file you are parsing
	[rssParser setShouldProcessNamespaces:NO];
	[rssParser setShouldReportNamespacePrefixes:NO];
	[rssParser setShouldResolveExternalEntities:NO];
	
	[rssParser parse];
	
	
}



- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	
	NSString *errorString = [NSString stringWithFormat:@"Error code %i", [parseError code]];
	NSLog(@"Error parsing XML: %@", errorString);
	
	
	errorParsing=YES;
}

- (void)parserDidStartDocument:(NSXMLParser *)parser{
	NSLog(@"File found and parsing started");
	
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	currentElement = [elementName copy];
	ElementValue = [[NSMutableString alloc] init];
	if ([elementName isEqualToString:@"FolderInfo"]) {
		item = [[NSMutableDictionary alloc] init];
	}
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
		ElementValue = [[NSMutableString alloc]initWithString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
		NSLog(@"%d-set into Item: elementName: %@ ElementValue: %@", count, elementName, ElementValue);
	
    if ([elementName isEqualToString:@"FolderName"]) {
        FolderName = ElementValue;
    }
	else if ([elementName isEqualToString:@"FolderId"]) {
		FolderID = ElementValue;
	}
	
	
	if ([elementName isEqualToString:@"FolderInfo"] && ![FolderID isEqualToString:@"0"]) {
        NSDictionary *tempData = [[NSDictionary alloc] initWithObjectsAndKeys:FolderName, @"FolderName",
								  FolderID, @"FolderID",
                                  nil];
        [articles addObject:[tempData copy]];
    }
	else if ([elementName isEqualToString:@"FolderInfo"] && [FolderID isEqualToString:@"0"]){
		[self GoToSnap];
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	
	if (errorParsing == NO)
	{
		NSLog(@"%@", articles);
		//[self generateLabel];
		NSLog(@"XML processing done!");
	} else {
		NSLog(@"Error occurred during XML processing");
	}
}

-(void)GoToSnap {
	NSString *fname = [[PathHist objectAtIndex:PathHist.count-2]objectForKey:@"FolderName"];
	UIButton *btn = (UIButton*)[self.view viewWithTag:1001];
	if (PathHist.count == 2) {
		[btn setTitle:@"Choose the location" forState:UIControlStateNormal];
	}
	else {
		[btn setTitle:[NSString stringWithFormat:@"<  %@", fname] forState:UIControlStateNormal];
	}
	
	NSString *FolderPath = @"";
	if (PathHist != 0) {
		for (int a = 0; a < PathHist.count; a = a + 1) {
			NSString *tempPath = [[PathHist objectAtIndex:a]objectForKey:@"FolderName"];
			if ([FolderPath isEqualToString:@""]) {
				FolderPath = tempPath;
			}
			else {
				FolderPath = [NSString stringWithFormat:@"%@>%@", FolderPath, tempPath];
			}
		}
	}
	
	NSLog(@"Folder Path: %@", FolderPath);
	
	[[NSUserDefaults standardUserDefaults] setObject:FolderPath forKey:@"FolderPath"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	[PathHist removeLastObject];
	[articles removeAllObjects];
	[articles addObjectsFromArray:PrevArticles];
	
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		APPViewController *controller = [[APPViewController alloc] initWithNibName:@"APPViewController_IPAD@" bundle:nil];
		[self presentViewController:controller animated:YES completion:Nil];
	}
	else
	{
		APPViewController *controller = [[APPViewController alloc] initWithNibName:@"APPViewController" bundle:nil];
		[self presentViewController:controller animated:YES completion:Nil];
		
	}

}


#pragma mark - `Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [articles count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    [[cell.contentView viewWithTag:2001] removeFromSuperview ];
    [[cell.contentView viewWithTag:2002] removeFromSuperview ];
    
    if (articles.count != 0) {
        if(indexPath.row < [articles count]){
            
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 35, 35)];
            imgView.image = [UIImage imageNamed:@"open folder.png"];
            
            [cell.contentView addSubview:imgView];
            
            NSString *fName = [[articles objectAtIndex:indexPath.row ]objectForKey:@"FolderName"];
			
            UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(50, 0, 300, 45)];
            label1.text = fName;
            label1.tag = 2001;
            label1.font = [UIFont systemFontOfSize:16.0];
            label1.backgroundColor =[UIColor clearColor];
            [cell.contentView addSubview:label1];
			
        }
    }
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		UIImage *image = [UIImage   imageNamed:@"folder_next.png"];
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		CGRect frame = CGRectMake(cell.frame.size.width  - image.size.width, cell.frame.size.height - image.size.height, image.size.width, image.size.height);
		button.frame = frame;
		[button setBackgroundImage:image forState:UIControlStateNormal];
		[button addTarget:self action:@selector(didTapStar:event:)  forControlEvents:UIControlEventTouchUpInside];
		button.backgroundColor = [UIColor clearColor];
		cell.accessoryView = button;

	}
	else
	{
		[cell setAccessoryType:UITableViewCellAccessoryDetailButton];
		
	}

	
	
	
	
	
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView.backgroundColor = [UIColor clearColor];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

	
    NSString *fID = [[articles objectAtIndex:indexPath.row]objectForKey:@"FolderID"];
	NSString *fname = [[articles objectAtIndex:indexPath.row]objectForKey:@"FolderName"];
	
	UIButton *btn = (UIButton*)[self.view viewWithTag:1001];
	[btn setTitle:[NSString stringWithFormat:@"<  %@", fname] forState:UIControlStateNormal];
	
	NSDictionary *tempD = [[NSDictionary alloc] initWithObjectsAndKeys:fname, @"FolderName",
							  fID, @"FolderID",
							  nil];
	[PathHist addObject:[tempD copy]];
	
	PrevArticles = [[NSMutableArray alloc] init];
	[PrevArticles removeAllObjects];
	[PrevArticles addObjectsFromArray:articles];
	
	[self GoToSnap];

}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	
	NSLog(@"TAPBtnPress");
	NSString *fID = [[articles objectAtIndex:indexPath.row]objectForKey:@"FolderID"];
	NSString *fname = [[articles objectAtIndex:indexPath.row]objectForKey:@"FolderName"];
	
	UIButton *btn = (UIButton*)[self.view viewWithTag:1001];
	[btn setTitle:[NSString stringWithFormat:@"<  %@", fname] forState:UIControlStateNormal];
	
	NSDictionary *tempD = [[NSDictionary alloc] initWithObjectsAndKeys:fname, @"FolderName",
							  fID, @"FolderID",
							  nil];
	[PathHist addObject:[tempD copy]];
	
	PrevArticles = [[NSMutableArray alloc] init];
	[PrevArticles removeAllObjects];
	[PrevArticles addObjectsFromArray:articles];
	
//	[articles removeAllObjects];
	[self parseXMLFileAtURL:fID];
	
	
	[tableView beginUpdates];
	[tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
			 withRowAnimation:UITableViewRowAnimationFade];
	[self.SearchTableView reloadData];
	[tableView endUpdates];
	
}

- (void)didTapStar:(id)sender event:(id)event {
	
	
	NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView:self.SearchTableView];
	NSIndexPath *indexPath = [self.SearchTableView indexPathForRowAtPoint: currentTouchPosition];
	if (indexPath != nil){
		[self tableView: self.SearchTableView accessoryButtonTappedForRowWithIndexPath: indexPath];
	}
	
}

@end
