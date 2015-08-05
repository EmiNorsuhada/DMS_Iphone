//
//  APPViewController.m
//  CameraApp
//
//  Created by Rafael Garcia Leiva on 10/04/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "APPViewController.h"
#import "FolderViewController.h"
#import "Base64.h"

@interface APPViewController ()

@end

@implementation APPViewController
@synthesize encoded;


- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
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
    
    NSData* data = UIImageJPEGRepresentation(chosenImage, 0.3f);
    encoded = [Base64 encode:data];
    
//    CGDataProviderRef provider = CGImageGetDataProvider(chosenImage.CGImage);
//    NSData* data = (id)CFBridgingRelease(CGDataProviderCopyData(provider));
//    
//    const uint8_t* bytes = [data bytes];
//    data= UIImageJPEGRepresentation(chosenImage,1.0);
    
   
    
 //   NSData *imageData = UIImageJPEGRepresentation(self.imgHeaderPhoto.image, 0.1);
    
  //  encoded = [Base64 encode:data];
    
   // NSLog(@"bytes %s",bytes);
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)parseXMLFileAtURL
{
    
    
    NSString *FolderPath = [[NSUserDefaults standardUserDefaults]
                           stringForKey:@"FolderPath"];
    
    NSString *combineStrIndex = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"combineStrIndex"];
    
    
    
    NSLog(@"encoded%@",FolderPath);
    
    //NSString *post = @"Profile_Name=PPL&Column_Desc=Name|ID%20No&Column_Data=Jacob%20Chin|1";
    NSString *post = [NSString stringWithFormat:
                      @"FileContent=%@&strFileName=%@&strProfile=%@&strFolderName=%@&ProfileValue=%@&userID=%@",encoded,@"Image.png",@"PPL",
                      FolderPath,combineStrIndex,@"admin"];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    
    [request setURL:[NSURL URLWithString:@"http://192.168.2.28/DocufloSDK/docuflosdk.asmx/ExportToDMS"]];
    
    
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

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (IBAction)backbutton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
//    FolderViewController *controller = [[FolderViewController alloc]init];
//    [self presentViewController:controller animated:YES completion:Nil];
}
@end
