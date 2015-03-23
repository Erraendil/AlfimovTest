//
//  DetailedViewController.m
//  AlfimovTest
//
//  Created by Kostyantyn Bilyk on 21.03.15.
//  Copyright (c) 2015 Kostyantyn Bilyk. All rights reserved.
//

#import "DetailViewController.h"
#import "Item.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *itemTitle;
@property (weak, nonatomic) IBOutlet UILabel *itemPrice;
@property (weak, nonatomic) IBOutlet UILabel *itemQuantity;
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property NSNumber *quantityToBuy;

- (IBAction)PlusBuutonAction:(id)sender;
- (IBAction)MinusBuutonAction:(id)sender;
- (IBAction)BuyButtonAction:(id)sender;

@end

@implementation DetailViewController
@synthesize displayItem, quantityToBuy;

- (id)init {
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void) viewWillAppear:(BOOL)animated{

    self.quantityToBuy=     [[NSNumber alloc] init];
    self.quantityToBuy=     @1;

    /*
    self.displayItem=       [[Item alloc] init];
    displayItem.title=      @"Apple iPod touch 32Gb";
    displayItem.price=      @5000.20;
    displayItem.quantity=   @20;
     */
    
    [self.itemTitle setText:displayItem.title];
    [self.itemPrice setText:[NSString stringWithFormat:@"%@ грн.",[displayItem.price stringValue]]];
    [self.itemQuantity setText:[NSString stringWithFormat:@"%@/%@", [self.quantityToBuy stringValue],[displayItem.quantity stringValue]]];
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

- (IBAction)BuyButtonAction:(id)sender {
    //Set URL
    NSURL *kBuyRequestUrl = [[NSURL alloc] initWithString:@""];
    
    // Create the request.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:kBuyRequestUrl];
    
    // Specify that it will be a POST request
    request.HTTPMethod = @"POST";
    
    // This is how we set header fields
    [request setValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    // Convert your data and set your request's HTTPBody property
    NSString *stringData = @"some data";
    NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = requestBodyData;
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
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
}

@end
