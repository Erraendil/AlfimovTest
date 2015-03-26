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
#import "AddNewItemViewController.h"
#import "DataManager.h"


@interface ListTableViewController ()

@property NSMutableArray    *items;
@property DataManager       *manager;

@end

@implementation ListTableViewController

@synthesize items, manager;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [[DataManager alloc] init];
    self.items = [manager loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];
    Item *item = [self.items objectAtIndex:indexPath.row];
    
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

- (IBAction)unwindToList:(UIStoryboardSegue *)segue{
    AddNewItemViewController *source = [segue sourceViewController];
    Item *newItem = source.item;
    if (newItem != nil) {
        [self.items addObject:newItem];
        [self.manager addItem:newItem];
        [self.tableView reloadData];
    }
    
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"DetailView"]) {
        DetailViewController *detailedView = [segue destinationViewController];
        Item *itemToTransmit = [self.items objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        detailedView.displayItem = itemToTransmit;
    }

}

@end
