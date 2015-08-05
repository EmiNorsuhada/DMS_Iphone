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
#import "pdfView.h"
#import "FolderViewController.h"

@interface IndexViewController  ()

@end

@implementation IndexViewController
@synthesize UserNameTxt,ProfileNameTxt;

NSString *temp;
int count;
NSString *colID;
NSString *colName;
NSString *colDesc;
NSString *colData;
NSString *Compulsory;
NSString *DataLength;
bool proceed;



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
    [self parseXMLFileAtURL];
	
//	UserNameTxt.text = @"Jacob*";
	
	NSString *pName = [[NSUserDefaults standardUserDefaults] stringForKey:@"profileName"];
	
	UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(25, 75, 300, 50)];
	label1.text = pName;
	label1.tag = 111;
	label1.font = [UIFont boldSystemFontOfSize:17.0];
	label1.backgroundColor =[UIColor clearColor];
	[self.view addSubview:label1];
	
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)BackBtn:(id)sender {
	
	ProfileViewController *controller = [[ProfileViewController alloc]init];
	[self presentViewController:controller animated:YES completion:Nil];
}

- (IBAction)SearchBtn:(id)sender
{
	
	[self parseXMLFileAtURL];
	
	[UserNameTxt resignFirstResponder];
}

- (IBAction)TxtDidEnd:(id)sender {

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	[textField resignFirstResponder];
	
	return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	
	if(range.length + range.location > textField.text.length)
	{
		return NO;
	}
	
	NSUInteger newLength = [textField.text length] + [string length] - range.length;
	int totLen = [[[articles objectAtIndex:textField.tag -1 ] objectForKey:@"DataLength"] intValue];
	return newLength <= totLen;
}

#pragma mark - XMLParser

- (void)parseXMLFileAtURL
{
    NSString *NameValue = [[NSUserDefaults standardUserDefaults]
                           stringForKey:@"NameValue"];
    
//    NSString *ImageNameValue = [[NSUserDefaults standardUserDefaults]
//                                stringForKey:@"ApplicationNo"];

	//NSString *post = @"Profile_Name=PPL&Column_Desc=Name|ID%20No&Column_Data=Jacob%20Chin|1";
     NSString *post = [NSString stringWithFormat:@"intProfileID=%@",NameValue];
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	
	
	[request setURL:[NSURL URLWithString:@"http://192.168.2.28/DocufloSDK/docuflosdk.asmx/LoadProfileField"]];
    
	
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
	if ([elementName isEqualToString:@"ProfileField"]) {
		item = [[NSMutableDictionary alloc] init];
	}
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
		ElementValue = [[NSMutableString alloc]initWithString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
		NSLog(@"%d-set into Item: elementName: %@ ElementValue: %@", count, elementName, ElementValue);
	
    if ([elementName isEqualToString:@"colID"]) {
        colID = ElementValue;
    }
    else if ([elementName isEqualToString:@"colName"]) {
        colName = ElementValue;
    }
    
    else if ([elementName isEqualToString:@"colDesc"]) {
        colDesc = ElementValue;
    }
    
    else if ([elementName isEqualToString:@"colDataType"]) {
        colData = ElementValue;
    }
	else if ([elementName isEqualToString:@"Compulsory"]) {
		Compulsory = ElementValue;
	}
	
	else if ([elementName isEqualToString:@"DataLength"]) {
		DataLength = ElementValue;
	}
	
	
    if ([elementName isEqualToString:@"ProfileField"]) {
        NSDictionary *tempData = [[NSDictionary alloc] initWithObjectsAndKeys:colID, @"colID",
                                  colName, @"colName",
                                  colDesc, @"colDesc",
                                  colData, @"colDataType",
								  Compulsory, @"Compulsory",
								  DataLength, @"DataLength",
                                  nil];

        [articles addObject:[tempData copy]];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	
	if (errorParsing == NO)
	{
//		NSLog(@"%@", articles);
		[self generateLabel];
		temp = @"";
		NSLog(@"XML processing done!");
	} else {
		NSLog(@"Error occurred during XML processing");
	}
}

- (void)generateLabel {
	
//	int totalIdx = [articles.count];
	NSString *labelName;
	
	int addY = 0;
	if (articles.count != 0) {
		for (int m = 0; m < articles.count; m = m + 1) {
			
			labelName = [[articles objectAtIndex:m] objectForKey:@"colDesc"];
//			NSLog(@"label name: %@",labelName);
			
			addY = addY + 30;
			
			UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 110+addY, 280, 25)];
			textField.borderStyle = UITextBorderStyleRoundedRect;
			textField.font = [UIFont systemFontOfSize:15];
			textField.placeholder = labelName;
			textField.tag = m+1;
			textField.autocorrectionType = UITextAutocorrectionTypeNo;
			textField.keyboardType = UIKeyboardTypeDefault;
			textField.returnKeyType = UIReturnKeyDone;
			textField.clearButtonMode = UITextFieldViewModeWhileEditing;
			textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
			textField.delegate = self;
			[self.view addSubview:textField];
		}
	}
}

- (IBAction)NExt:(id)sender
{
	proceed = YES;
	NSString *combineStr = @"";
	if (articles.count != 0) {
		for (int m = 0; m < articles.count; m = m + 1) {
			NSString *text = [(UITextField *)[self.view viewWithTag:m+1] text];
			NSString *labelName = [[articles objectAtIndex:m] objectForKey:@"colDesc"];
			Compulsory = [[articles objectAtIndex:m] objectForKey:@"Compulsory"];
			if ([combineStr isEqualToString:@""]) {
				combineStr = text;
			}
			else {
				combineStr = [NSString stringWithFormat:@"%@|%@", combineStr, text];
			}
			
			if ([Compulsory isEqualToString:@"true"] && text.length <=0) {
				proceed = NO;
				NSString *AlertMsg = [NSString stringWithFormat:@"%@ is compulsory",labelName];
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
																message:AlertMsg
															   delegate:self
													  cancelButtonTitle:@"OK"
													  otherButtonTitles:nil];
				[alert show];
				[[self.view viewWithTag:m+1] becomeFirstResponder];
			}
		}
	}
	
	if (proceed) {
		NSLog(@"CB: %@", combineStr);
        [[NSUserDefaults standardUserDefaults] setObject:combineStr forKey:@"combineStrIndex"];
        [[NSUserDefaults standardUserDefaults] synchronize];
		FolderViewController *viewController = [[FolderViewController alloc] init];
		[self presentViewController:viewController animated:YES completion:nil];
	}
	
}


@end
