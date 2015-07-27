//
//  DMSViewController.h
//  HelloWorld
//
//  Created by Emi on 30/6/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMSViewController : UIViewController


- (IBAction)LoginBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *UserName;
@property (strong, nonatomic) IBOutlet UITextField *PassWord;
@property (strong, nonatomic) IBOutlet UITextField *txtURL;


@end
