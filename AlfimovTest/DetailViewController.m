//
//  DetailedViewController.m
//  AlfimovTest
//
//  Created by Kostyantyn Bilyk on 21.03.15.
//  Copyright (c) 2015 Kostyantyn Bilyk. All rights reserved.
//

#import "DetailViewController.h"
#import "Item.h"
#import "AppDelegate.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *itemTitle;
@property (weak, nonatomic) IBOutlet UILabel *itemPrice;
@property (weak, nonatomic) IBOutlet UILabel *itemQuantity;
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property NSNumber *quantityToBuy;
@property AppDelegate *appDelegate;

- (IBAction)PlusBuutonAction:(id)sender;
- (IBAction)MinusBuutonAction:(id)sender;

@end

@implementation DetailViewController
@synthesize displayItem, quantityToBuy, appDelegate, itemIndex;

- (id)init {
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    self.quantityToBuy=     @1;
    
    [self.itemTitle setText:displayItem.title];
    [self.itemPrice setText:[NSString stringWithFormat:@"%@ грн.",[displayItem.price stringValue]]];
    [self.itemQuantity setText:[NSString stringWithFormat:@"%@/%@", [self.quantityToBuy stringValue],[displayItem.quantity stringValue]]];
    
    if ([self.displayItem.quantity integerValue]<1){
        [self.buyButton setEnabled:NO];}
    else{
        [self.buyButton setEnabled:YES];}
}


- (void) viewWillAppear:(BOOL)animated{

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)PlusBuutonAction:(id)sender {
    if ([self.displayItem.quantity intValue] > [self.quantityToBuy intValue]) {
        if ([quantityToBuy intValue] == 0)
            [self.buyButton setEnabled:YES];
        quantityToBuy=[NSNumber numberWithInt:[quantityToBuy intValue]+1];
        [self.itemQuantity setText:[NSString stringWithFormat:@"%@/%@", [self.quantityToBuy stringValue],[displayItem.quantity stringValue]]];
    }
}

- (IBAction)MinusBuutonAction:(id)sender {
    if ([quantityToBuy intValue] != 0) {
        quantityToBuy=[NSNumber numberWithInt:[quantityToBuy intValue]-1];
        [self.itemQuantity setText:[NSString stringWithFormat:@"%@/%@", [self.quantityToBuy stringValue],[displayItem.quantity stringValue]]];
        if ([quantityToBuy intValue] == 0)
            [self.buyButton setEnabled:NO];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.displayItem.quantity = [ NSNumber numberWithInt:([self.displayItem.quantity intValue]-[self.quantityToBuy intValue])];
    
    NSURL *kBuyRequestUrl = [[NSURL alloc] initWithString:@"BuyRequest.com/buy.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:kBuyRequestUrl];
    request.HTTPMethod = @"POST";
    
    NSString *parameters= [NSString stringWithFormat:@"?id=%li&amount=%i&name=%@",
                               (long)self.itemIndex,
                               [self.quantityToBuy intValue],
                               self.appDelegate.userName];
    
    request.HTTPBody = [parameters dataUsingEncoding:NSUTF8StringEncoding];
        
    // Create url connection and fire request
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
 }

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    /*
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Ошибка!"
                                                                   message:[NSString stringWithFormat:@"%@", error]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action) {
                                                   [errorAlert dismissViewControllerAnimated:YES completion:nil];
                                               }];
    [errorAlert addAction:ok];
    [self presentViewController:errorAlert animated:YES completion:nil];
     */
    
}

@end
