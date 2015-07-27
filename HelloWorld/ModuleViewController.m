//
//  ModuleViewController.m
//  HelloWorld
//
//  Created by Emi on 30/6/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import "ModuleViewController.h"
#import "SearchViewController.h"
#import "DMSViewController.h"

@interface ModuleViewController ()

@end

@implementation ModuleViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ModuleAClick:(id)sender {
	
	SearchViewController *controller = [[SearchViewController alloc]init];
	[self presentViewController:controller animated:YES completion:Nil];
	
}

- (IBAction)ModuleBClick:(id)sender {
	
	SearchViewController *controller = [[SearchViewController alloc]init];
	[self presentViewController:controller animated:YES completion:Nil];
}

- (IBAction)ModuleCClick:(id)sender {
	
	SearchViewController *controller = [[SearchViewController alloc]init];
	[self presentViewController:controller animated:YES completion:Nil];
}

- (IBAction)ModuleDClick:(id)sender {
	
	SearchViewController *controller = [[SearchViewController alloc]init];
	[self presentViewController:controller animated:YES completion:Nil];
}

- (IBAction)ModuleEClick:(id)sender {
	
	SearchViewController *controller = [[SearchViewController alloc]init];
	[self presentViewController:controller animated:YES completion:Nil];
}

- (IBAction)ModuleFClick:(id)sender {
	
	SearchViewController *controller = [[SearchViewController alloc]init];
	[self presentViewController:controller animated:YES completion:Nil];
}

- (IBAction)BackBtn:(id)sender {
	
	DMSViewController *controller = [[DMSViewController alloc]init];
	[self presentViewController:controller animated:YES completion:Nil];
	
}





@end
