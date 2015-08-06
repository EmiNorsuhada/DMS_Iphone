//
//  APPViewController.m
//  HelloWorld
//
//  Created by Prem on 30/6/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//


#import "APPViewController.h"
#import "FolderViewController.h"
#import "Base64.h"

@interface APPViewController ()

@end

@implementation APPViewController
@synthesize encoded;
NSString *temp;
int count;
NSString *colID;
NSString *colName;
NSString *colDesc;
NSString *colData;
NSString *Compulsory;
NSString *DataLength;
bool proceed;


- (void)viewDidLoad {
    
    [super viewDidLoad];
    count = 0;
    temp = @"";
	
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Device has no camera"
                                                        delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}

- (IBAction)Upload:(id)sender
{
     [self parseXMLFileAtURL];
}

- (IBAction)takePhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (IBAction)selectPhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];

    
}

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    
    NSData* data = UIImageJPEGRepresentation(chosenImage, 0.2f);
    encoded = [Base64 encode:data];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)parseXMLFileAtURL
{
    NSString *FolderPath = [[NSUserDefaults standardUserDefaults]
                           stringForKey:@"FolderPath"];
    NSString *combineStrIndex = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"combineStrIndex"];
    NSString *combineTest = [[NSUserDefaults standardUserDefaults]
                                 stringForKey:@"combineTest"];
    NSString *combineTest2 =[NSString stringWithFormat:@"%@.png",combineTest];
    
    NSString *post = [NSString stringWithFormat:
                      @"FileContent=%@&strFileName=%@&strProfile=%@&strFolderName=%@&ProfileValue=%@&userID=%@",encoded,combineTest2,@"PPL",
                      FolderPath,combineStrIndex,@"admin"];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://192.168.2.28/DocufloSDK/docuflosdk.asmx/ExportToDMS"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded;  charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(conn) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }
    NSData *xmlFile;
    articles = [[NSMutableArray alloc] init];
    errorParsing=NO;
    rssParser = [[NSXMLParser alloc] initWithData:xmlFile];
    [rssParser setDelegate:self];
    [rssParser setShouldProcessNamespaces:NO];
    [rssParser setShouldReportNamespacePrefixes:NO];
    [rssParser setShouldResolveExternalEntities:NO];
    [rssParser parse];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    NSString *sData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSRange type_m = [sData rangeOfString:@">1</string>"];
    
    if (type_m.location != NSNotFound)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"DMS" message:@"Succesfully Upload"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        _imageView.image =nil;
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"DMS" message:@"Upload Failed"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
 
    }

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
    if ([elementName isEqualToString:@"string"])
    {
        item = [[NSMutableDictionary alloc] init];
    }
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    ElementValue = [[NSMutableString alloc]initWithString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    NSLog(@"%d-set into Item: elementName: %@ ElementValue: %@", count, elementName, ElementValue);
    
    if ([elementName isEqualToString:@"string"])
    {
        colID = ElementValue;
    }
    if ([elementName isEqualToString:@"string"])
    {
        NSDictionary *tempData = [[NSDictionary alloc] initWithObjectsAndKeys:colID, @"string",nil];
        [articles addObject:[tempData copy]];
    }
    
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    if (errorParsing == NO)
    {
        NSLog(@"%@", articles);
        
         NSString *Feedback =colID;
        
        if ([Feedback isEqualToString:@"1"])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"DMS" message:@"Succesfully Upload"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
            
            _imageView.image =nil;

        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"DMS" message:Feedback
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
        }
        
       
        temp = @"";
       
    } else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"DMS" message:@"Upload Failed"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
         [alertView show];
        
        NSLog(@"Error occurred during XML processing");
    }
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (IBAction)backbutton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    

}
@end
