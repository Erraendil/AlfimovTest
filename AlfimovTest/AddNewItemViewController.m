//
//  AddNewItemViewController.m
//  AlfimovTest
//
//  Created by Kostyantyn Bilyk on 24.03.15.
//  Copyright (c) 2015 Kostyantyn Bilyk. All rights reserved.
//

#import "AddNewItemViewController.h"

@interface AddNewItemViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *quantityTextField;
@property (weak, nonatomic) IBOutlet UITextField *URLTextField;

@end

@implementation AddNewItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    if (sender != self.saveButton) return;
    if (self.titleTextField>0 & self.priceTextField>0 & self.quantityTextField>0) {
        self.item = [[Item alloc] init];
        self.item.title = self.titleTextField.text;
        self.item.price = [NSNumber numberWithFloat:[self.priceTextField.text floatValue]];
        self.item.quantity = [NSNumber numberWithInt:[self.quantityTextField.text intValue]];
        self.item.imageURL = [NSURL URLWithString:self.URLTextField.text];
    }
}

@end
