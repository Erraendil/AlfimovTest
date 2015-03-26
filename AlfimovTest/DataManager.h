//
//  DataManager.h
//  AlfimovTest
//
//  Created by Kostyantyn Bilyk on 26.03.15.
//  Copyright (c) 2015 Kostyantyn Bilyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"

@interface DataManager : NSObject

- (NSMutableArray *) loadData;
- (void) addItem: (Item *) item;
- (void) editItem: (Item *) item;
- (void) deleteItem: (Item *) item;

@end
