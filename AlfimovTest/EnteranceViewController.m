//
//  EnteranceViewController.m
//  AlfimovTest
//
//  Created by Kostyantyn Bilyk on 27.03.15.
//  Copyright (c) 2015 Kostyantyn Bilyk. All rights reserved.
//

#import "EnteranceViewController.h"
#import "AppDelegate.h"

@interface EnteranceViewController ()
- (IBAction)enteraceAction:(id)sender;
@property AppDelegate *appDelegate;

@end

@implementation EnteranceViewController
@synthesize appDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = [[UIApplication sharedApplication] delegate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (IBAction)enteraceAction:(id)sender {
    UIAlertController *enterance = [UIAlertController alertControllerWithTitle:@"Вход в программу:"
                                                                       message:@"Представьтесь, пожалуйста."
                                                                preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *saveName = [UIAlertAction actionWithTitle:@"Все верно!"
                                                       style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action){
                                                         appDelegate.userName = ((UITextField *)[enterance.textFields objectAtIndex:0]).text;
                                                         [self performSegueWithIdentifier:@"TabView" sender:self];
                                                         [enterance dismissViewControllerAnimated:YES completion:nil];
    }];
    [enterance addAction:saveName];
    [enterance addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Имя";
    }];
    
    [self presentViewController:enterance animated:YES completion:nil];
}

@end
