//
//  ListTableViewController.m
//  AlfimovTest
//
//  Created by Kostyantyn Bilyk on 21.03.15.
//  Copyright (c) 2015 Kostyantyn Bilyk. All rights reserved.
//

#import "ListTableViewController.h"
#import "Item.h"
#import "DetailViewController.h"


@interface ListTableViewController ()

@property NSMutableArray *itemsArray;

- (void) loadDataFromCSV: (NSURL *) sourceURL;

@end

@implementation ListTableViewController

@synthesize itemsArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewWillAppear:(BOOL)animated {
    //Setting URL to source file
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"data" ofType:@"csv"]];
    //Loading data from source file
    [self loadDataFromCSV:fileURL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Load data from csv

- (void) loadDataFromCSV: (NSURL *) sourceURL {
    // Var initalization
    NSError     *error=nil;
    NSString    *fileContent = [NSString stringWithContentsOfURL:sourceURL encoding:NSUTF8StringEncoding error:&error];
    NSArray     *rows = [fileContent componentsSeparatedByString:@"\n"];
    self.itemsArray = [[NSMutableArray alloc] init];
    //Content array filling
    for (int i=0; i<[rows count]; i++) {
        Item        *currentItem= [[Item alloc] init];
        NSString    *row = [rows objectAtIndex:i];
        NSArray     *colums = [row componentsSeparatedByString:@","];
        currentItem.title = [[colums objectAtIndex:0] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        currentItem.price = [NSNumber numberWithFloat:[[[colums objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\"" withString:@""] floatValue]];
        currentItem.quantity = [NSNumber numberWithInt:[[[colums objectAtIndex:2] stringByReplacingOccurrencesOfString:@"\"" withString:@""] intValue]];
        [self.itemsArray addObject:currentItem];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.itemsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];

    Item *item = [self.itemsArray objectAtIndex:indexPath.row];
    
    UILabel *cellItemTitle = (UILabel *)[cell viewWithTag:101];
    cellItemTitle.text = item.title;
    
    UILabel *cellItemPrice = (UILabel *)[cell viewWithTag:102];
    cellItemPrice.text = [NSString stringWithFormat:@"%@ грн.", [item.price stringValue]];
    
    UILabel *cellItemQuantity = (UILabel *)[cell viewWithTag:103];
    cellItemQuantity.text = [item.quantity stringValue];
    
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"DetilView"]) {
        DetailViewController *detailedView = [segue destinationViewController];
        Item *itemToTransmit = [self.itemsArray objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        detailedView.displayItem = itemToTransmit;
    }

}

@end
