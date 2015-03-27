//
//  AddNewItemViewController.m
//  AlfimovTest
//
//  Created by Kostyantyn Bilyk on 24.03.15.
//  Copyright (c) 2015 Kostyantyn Bilyk. All rights reserved.
//

#import "ItemViewController.h"

@interface ItemViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *quantityTextField;
@property (weak, nonatomic) IBOutlet UITextField *URLTextField;

- (void) prepareTextFields;

@end

@implementation ItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isItemEdited = NO;
    [self prepareTextFields];
    if (self.isItemEdited)
        self.deleteButton.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (sender == self.saveButton){
        if (![self.titleTextField.text isEqualToString:@""] & ![self.priceTextField.text isEqualToString:@""] & ![self.quantityTextField.text isEqualToString:@""]) {
            self.item = [[Item alloc] init];
            self.item.title = self.titleTextField.text;
            self.item.price = [NSNumber numberWithFloat:[self.priceTextField.text floatValue]];
            self.item.quantity = [NSNumber numberWithInt:[self.quantityTextField.text intValue]];
            self.item.imageURL = [NSURL URLWithString:self.URLTextField.text];
        }
        else{
            self.item = nil;
            return;
        }
    }
    else{
        self.item = nil;
        return;
    }
}
- (void) prepareTextFields{
    if (self.item !=nil) {
        self.titleTextField.text = self.item.title;
        self.priceTextField.text = [self.item.price stringValue];
        self.quantityTextField.text = [self.item.quantity stringValue];
        self.isItemEdited = YES;
    }
}

@end
