//
//  DMSViewController.m
//  HelloWorld
//
//  Created by Emi on 30/6/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import "DMSViewController.h"
#import "ModuleViewController.h"
#import "SearchViewController.h"

@interface DMSViewController ()

@end

@implementation DMSViewController
@synthesize PassWord,UserName, txtURL;

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
    UserName.textColor =[UIColor blackColor];
    UserName.font =[UIFont systemFontOfSize:12.0];
    UserName.placeholder =@"Username";
    UserName.backgroundColor =[UIColor whiteColor];
    UserName.keyboardType = UIKeyboardAppearanceDefault;
    UserName.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:UserName];
    UserName.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    
    PassWord.textColor =[UIColor blackColor];
    PassWord.secureTextEntry = YES;
    PassWord.placeholder =@"password";
    PassWord.backgroundColor =[UIColor whiteColor];
    PassWord.keyboardType = UIKeyboardAppearanceDefault;
    PassWord.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:PassWord];
    PassWord.clearButtonMode = UITextFieldViewModeWhileEditing;
	
	txtURL.textColor =[UIColor blackColor];
	txtURL.placeholder =@"URL";
	txtURL.font =[UIFont systemFontOfSize:12.0];
	txtURL.backgroundColor =[UIColor whiteColor];
	txtURL.keyboardType = UIKeyboardAppearanceDefault;
	txtURL.returnKeyType = UIReturnKeyDone;
	[self.view addSubview:txtURL];
	txtURL.clearButtonMode = UITextFieldViewModeWhileEditing;
	
	
	UserName.text = @"admin";
	PassWord.text = @"password";
	txtURL.text = @"http://192.168.2.28";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	[UserName resignFirstResponder];
	[PassWord resignFirstResponder];
	[txtURL resignFirstResponder];
	
	return NO;
}

- (IBAction)LoginBtn:(id)sender
{
    NSString *post = [NSString stringWithFormat:@"Username=%@&Password=%@",UserName.text,PassWord.text];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	
	NSString *url = [NSString stringWithFormat:@"%@/docufloSDK/docuflosdk.asmx/Login",txtURL.text];
    [request setURL:[NSURL URLWithString:url]];
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
	
	
	
    NSRange rangeValue = [aStr rangeOfString:@">3<" options:NSCaseInsensitiveSearch];
    NSRange rangeValue1 = [aStr rangeOfString:@"Incorrect User Name or Password" options:NSCaseInsensitiveSearch];
    NSRange rangeValue2 = [aStr rangeOfString:@"Invalid Parameter" options:NSCaseInsensitiveSearch];
    NSRange rangeValue3 = [aStr rangeOfString:@"suspended" options:NSCaseInsensitiveSearch];
    
    if (rangeValue.length > 0)
    {
        SearchViewController *controller = [[SearchViewController alloc]init];
        [self presentViewController:controller animated:YES completion:Nil];
    }
    else if (rangeValue1.length > 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"DMS" message:@"Incorrect User Name or Password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else if (rangeValue2.length > 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"DMS" message:@"Invalid Parameter" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else if (rangeValue3.length > 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"DMS" message:@"Your account has been suspended" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }

//    SearchViewController *controller = [[SearchViewController alloc]init];
//    [self presentViewController:controller animated:YES completion:Nil];

}
@end
