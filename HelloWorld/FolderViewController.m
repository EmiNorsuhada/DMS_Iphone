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
#import "pdfView.h"

@interface FolderViewController  ()

@end

@implementation FolderViewController
@synthesize UserNameTxt,ProfileNameTxt;

NSString *temp;
int count;
NSString *colID;
NSString *colName;
NSString *colDesc;
NSString *colData;



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
    [self parseXMLFileAtURL];
	count = 0;
	temp = @"";
	
	UserNameTxt.text = @"Jacob*";
	
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
	[self.SearchTableView reloadData];
	
	[UserNameTxt resignFirstResponder];
}

- (IBAction)TxtDidEnd:(id)sender {

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
    NSString *Username = [[NSUserDefaults standardUserDefaults]
                           stringForKey:@"Username"];
    
    NSString *Password = [[NSUserDefaults standardUserDefaults]
                           stringForKey:@"Password"];

    NSString *post = [NSString stringWithFormat:@"UserId=%@&ParentId=%@",@"3",@"1"];
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
        colID = ElementValue;
    }
    
    
    if ([elementName isEqualToString:@"FolderInfo"]) {
        NSDictionary *tempData = [[NSDictionary alloc] initWithObjectsAndKeys:colID, @"FolderName",

                                  nil];

        [articles addObject:[tempData copy]];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	
	if (errorParsing == NO)
	{
		NSLog(@"%@", articles);
		//[self generateLabel];
		temp = @"";
		NSLog(@"XML processing done!");
	} else {
		NSLog(@"Error occurred during XML processing");
	}
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
                imgView.image = [UIImage imageNamed:@"JPEG.png"];
            }
            else if ([imgType isEqualToString:@"tif"]) {
                imgView.image = [UIImage imageNamed:@"tiff-128.png"];
            }
            else if ([imgType isEqualToString:@"pdf"]) {
                imgView.image = [UIImage imageNamed:@"PDF.png"];
            }
            else if ([imgType isEqualToString:@"gif"]) {
                imgView.image = [UIImage imageNamed:@"gif.png"];
            }
            else if ([imgType isEqualToString:@"IMG"]) {
                imgView.image = [UIImage imageNamed:@"IMG.png"];
            }
            else {
                imgView.image = [UIImage imageNamed:@"doc.png"];
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



@end