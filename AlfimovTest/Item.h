//
//  Item.h
//  AlfimovTest
//
//  Created by Kostyantyn Bilyk on 21.03.15.
//  Copyright (c) 2015 Kostyantyn Bilyk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

@property   NSInteger   *iD;
@property   NSString    *title;
@property   NSNumber    *price;
@property   NSNumber    *quantity;
@property   NSURL       *imageURL;

@end
