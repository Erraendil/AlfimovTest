//
//  DetailedViewController.h
//  AlfimovTest
//
//  Created by Kostyantyn Bilyk on 21.03.15.
//  Copyright (c) 2015 Kostyantyn Bilyk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"

@interface DetailViewController : UIViewController <NSURLConnectionDelegate>
{
    NSMutableData *_responseData;
}

@property Item *displayItem;
@property NSInteger itemIndex;


@end


