//
//  ListTableViewController.h
//  AlfimovTest
//
//  Created by Kostyantyn Bilyk on 21.03.15.
//  Copyright (c) 2015 Kostyantyn Bilyk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

- (IBAction)unwindToListFromItem:(UIStoryboardSegue *)segue;
- (IBAction)unwindToListFromDetail:(UIStoryboardSegue *)segue;

@end
