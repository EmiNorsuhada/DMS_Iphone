//
//  SearchViewController.m
//  HelloWorld
//
//  Created by Emi on 30/6/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import "SearchViewController.h"
#import "ModuleViewController.h"
#import "DMSViewController.h"
#import "ProfileViewController.h"
#import "pdfView.h"
#import <QuartzCore/QuartzCore.h>

@interface SearchViewController ()

@end

@implementation SearchViewController
@synthesize UserNameTxt,ProfileNameTxt, SView;

NSString *temp;
int count;
NSString *strName;
NSString *strIDno;
NSString *strLicNO;
NSString *strDocType;
NSString *strVerID;
NSString *strProfileID;
NSString *strDocID;
NSString *strImageName;


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
	count = 0;
	temp = @"";
	
	UserNameTxt.text = @"";
	
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)BackBtn:(id)sender {
	
	UITapGestureRecognizer *tapImageRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(displayOldView:)];
	UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(displayOldView:)];
	swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
	
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [[NSBundle mainBundle] loadNibNamed:@"PopupView_IPAD@" owner:self options:nil];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.2;
        transition.type = kCATransitionMoveIn;
        [SView.layer addAnimation:transition forKey:nil];
        [self.view addGestureRecognizer:tapImageRecognizer];
        [self.view addGestureRecognizer:swipeRecognizer];
        [self.view addSubview:SView];
        
        [UserNameTxt resignFirstResponder];

    } else
    {
        [[NSBundle mainBundle] loadNibNamed:@"PopupView" owner:self options:nil];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.2;
        transition.type = kCATransitionMoveIn;
        [SView.layer addAnimation:transition forKey:nil];
        [self.view addGestureRecognizer:tapImageRecognizer];
        [self.view addGestureRecognizer:swipeRecognizer];
        [self.view addSubview:SView];
        
        [UserNameTxt resignFirstResponder];
        
    }

	
}



- (IBAction)TxtDidEnd:(id)sender {
	
//	[self parseXMLFileAtURL];
//	[self.SearchTableView reloadData];
//	
//	[UserNameTxt resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	[self parseXMLFileAtURL];
	[self.SearchTableView reloadData];
	
	[UserNameTxt resignFirstResponder];
	
	return NO;
}

#pragma mark - XMLParser

- (void)parseXMLFileAtURL
{
	//NSString *post = @"Profile_Name=PPL&Column_Desc=Name|ID%20No&Column_Data=Jacob%20Chin|1";
    
    
//    
//     NSString *post = [NSString stringWithFormat:@"Profile_Name=%@&Column_Desc=Name|ID20No&Column_Data=%@|1",@"PPL",UserNameTxt.text];
//    
    NSString *post = [NSString stringWithFormat:@"strCriteria=%@",UserNameTxt.text];
    
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	
	
	[request setURL:[NSURL URLWithString:@"http://192.168.2.28/DocufloSDK/docuflosdk.asmx/Search"]];
	
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
	if ([elementName isEqualToString:@"DataProfileResult"]) {
		item = [[NSMutableDictionary alloc] init];
	}
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
		ElementValue = [[NSMutableString alloc]initWithString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
//		NSLog(@"%d-set into Item: elementName: %@ ElementValue: %@", count, elementName, ElementValue);
	
		if ([temp isEqualToString:@"Name"] && (![elementName isEqualToString:@"Col_Desc"]  && ![elementName isEqualToString:@"Col_ID"] && ![elementName isEqualToString:@"Col_Name"]) ) {
			strName = ElementValue;
		}
		else if ([temp isEqualToString:@"IDNo"] && (![elementName isEqualToString:@"Col_Desc"]  && ![elementName isEqualToString:@"Col_ID"] && ![elementName isEqualToString:@"Col_Name"]) ) {
			strIDno = ElementValue;
		}
		else if ([temp isEqualToString:@"LicNo"] && (![elementName isEqualToString:@"Col_Desc"]  && ![elementName isEqualToString:@"Col_ID"] && ![elementName isEqualToString:@"Col_Name"]) ) {
			strLicNO = ElementValue;
		}
		else if ([temp isEqualToString:@"DocType"] && (![elementName isEqualToString:@"Col_Desc"]  && ![elementName isEqualToString:@"Col_ID"] && ![elementName isEqualToString:@"Col_Name"]) ) {
			strDocType = ElementValue;
		}
		else if ([elementName isEqualToString:@"VerID"]) {
			strVerID = ElementValue;
		}
		else if ([elementName isEqualToString:@"ProfileID"]) {
			strProfileID = ElementValue;
		}
		else if ([elementName isEqualToString:@"DocID"]) {
			strDocID = ElementValue;
		}
		else if ([elementName isEqualToString:@"ImageName"]) {
			strImageName = ElementValue;
		}
	
		if ([elementName isEqualToString:@"DataProfileResult"]) {
			NSDictionary *tempData = [[NSDictionary alloc] initWithObjectsAndKeys:strName, @"Name", strIDno, @"IDNo", strLicNO, @"LicNo", strDocType, @"DocType", strVerID, @"VerID", strProfileID, @"ProfileID", strDocID, @"DocID", strImageName, @"ImageName",nil];
			[articles addObject:[tempData copy]];
		}
		
		temp = ElementValue;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	
	if (errorParsing == NO)
	{
		NSLog(@"%@", articles);
		temp = @"";
		NSLog(@"XML processing done!");
	} else {
		NSLog(@"Error occurred during XML processing");
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
			
			NSString *imgName = [[articles objectAtIndex:indexPath.row ]objectForKey:@"ImageName"];
			NSArray *split = [imgName componentsSeparatedByString:@"."];
			NSString *imgType = [split objectAtIndex:[split count] - 1];
			
			//			NSLog(@"tt: %@", imgType);
			
			UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 35, 35)];
			
			if ([imgType isEqualToString:@"jpg"]) {
				imgView.image = [UIImage imageNamed:@"Jpg1.png"];
			}
			else if ([imgType isEqualToString:@"tif"]) {
            imgView.image = [UIImage imageNamed:@"Tiff1.png"];
			}
			else if ([imgType isEqualToString:@"pdf"]) {
				imgView.image = [UIImage imageNamed:@"PDF1.png"];
			}
			else if ([imgType isEqualToString:@"gif"]) {
				imgView.image = [UIImage imageNamed:@"Gif1.png"];
			}
			else if ([imgType isEqualToString:@"IMG"]) {
				imgView.image = [UIImage imageNamed:@"IMG2.png"];
			}
			else {
				imgView.image = [UIImage imageNamed:@"doc1.png"];
			}
			[cell.contentView addSubview:imgView];
			
			NSString *Name = [[articles objectAtIndex:indexPath.row ]objectForKey:@"Name"];
			NSString *AppNo = [[articles objectAtIndex:indexPath.row ]objectForKey:@"LicNo"];
			NSString *ID = [[articles objectAtIndex:indexPath.row ]objectForKey:@"IDNo"];
            NSString *DocType = [[articles objectAtIndex:indexPath.row ]objectForKey:@"DocType"];
			NSString *strPrint = [NSString stringWithFormat:@"%@, %@, %@",AppNo, ID,DocType];
			
			UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(50, -5, 300, 45)];
			label1.text = Name;
			label1.tag = 2001;
			label1.font = [UIFont systemFontOfSize:14.0];
			label1.backgroundColor =[UIColor clearColor];
//			label1.numberOfLines = 2;
			[cell.contentView addSubview:label1];
			
			UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(50,7, 300, 45)];
			label2.text = strPrint;
			label2.tag = 2002;
			label2.font = [UIFont systemFontOfSize:10.0];
			label2.textColor = [UIColor grayColor];
			label2.backgroundColor =[UIColor clearColor];
			[cell.contentView addSubview:label2];
		}
	}
	
	[cell setAccessoryType: UITableViewCellAccessoryDetailButton];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	cell.backgroundColor = [UIColor clearColor];
	cell.backgroundView.backgroundColor = [UIColor clearColor];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSLog(@"celltext %@", [[articles objectAtIndex:indexPath.row ]objectForKey:@"DocID"]);
    
    NSString *ProfileID = [[articles objectAtIndex:indexPath.row ]objectForKey:@"ProfileID"];
    NSString *VerID = [[articles objectAtIndex:indexPath.row ]objectForKey:@"VerID"];
    NSString *post = [NSString stringWithFormat:@"VerID=%@&DocProfileID=%@&FileType=1",VerID,ProfileID];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://192.168.2.28/DocufloSDK/docuflosdk.asmx/ViewFileMobile"]];
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
    NSLog(@"astr %@",aStr);
    NSArray *Separate = [aStr componentsSeparatedByString:@">"];
    NSString *DEleteAfter = [Separate objectAtIndex:2];
    NSArray  *LastTrim = [DEleteAfter componentsSeparatedByString:@"</string"];
    NSString *LAstURL = [LastTrim objectAtIndex:0];
    NSUserDefaults *pdfURL = [NSUserDefaults standardUserDefaults];
    NSString *Url =LAstURL;
    
    NSString *NameValue = [[articles objectAtIndex:indexPath.row ]objectForKey:@"Name"];
    NSString *ImageNameValue = [[articles objectAtIndex:indexPath.row ]objectForKey:@"DocType"];
    NSString * IdNO =[[articles objectAtIndex:indexPath.row ]objectForKey:@"IDNo"];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:NameValue forKey:@"NameValue"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:ImageNameValue forKey:@"ApplicationNo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:IdNO forKey:@"ID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
    [pdfURL setObject:Url forKey:@"URL"];
    pdfView *viewController = [[pdfView alloc] init];
    [self presentViewController:viewController animated:YES completion:nil];
    
}

- (IBAction)upload:(id)sender
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        ProfileViewController *controller = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController_IPAD@" bundle:nil];
        
        
        [self presentViewController:controller animated:YES completion:Nil];
    } else
    {
        ProfileViewController *controller = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
        [self presentViewController:controller animated:YES completion:Nil];
        
    }

    
}


-(IBAction)displayOldView:(id)sender {
	
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5f];
	//	SView.transform = CGAffineTransformMakeTranslation(SView.frame.origin.x, 480.0f + (SView.frame.size.height/2));
	
	SView.transform = CGAffineTransformMakeTranslation(-300,SView.frame.origin.y);
	[UIView commitAnimations];
}

- (IBAction)LogoutBtn:(id)sender
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        DMSViewController *controller = [[DMSViewController alloc] initWithNibName:@"DMSViewController_IPAD@" bundle:nil];
        
        
        [self presentViewController:controller animated:YES completion:Nil];
    } else
    {
        DMSViewController *controller = [[DMSViewController alloc] initWithNibName:@"DMSViewController" bundle:nil];
        [self presentViewController:controller animated:YES completion:Nil];
        
    }

    
}

- (IBAction)UploadBtn:(id)sender {
	
	[self upload:nil];
}

@end
