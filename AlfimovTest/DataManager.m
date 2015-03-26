//
//  DataManager.m
//  AlfimovTest
//
//  Created by Kostyantyn Bilyk on 26.03.15.
//  Copyright (c) 2015 Kostyantyn Bilyk. All rights reserved.
//

#import "DataManager.h"
#import "Item.h"

@interface DataManager()
@property NSString      *filePath;
- (NSData *) loadDataFromCSV;
@end

@implementation DataManager
@synthesize filePath;

- (id) init{

    self.filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"data.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.filePath])
        [[NSFileManager defaultManager] copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"data" ofType:@"csv"] toPath:self.filePath error:Nil];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[NSBundle mainBundle] pathForResource:@"data" ofType:@"csv"]]) {
        NSLog(@"%@", [[NSBundle mainBundle] pathForResource:@"data" ofType:@"csv"]);
    }
    
       return self;
}


- (NSMutableArray *) loadDataFromCSV{
    NSFileHandle *readHandler = [NSFileHandle fileHandleForReadingAtPath:[[NSBundle mainBundle] pathForResource:@"data" ofType:@"csv"]];
    NSString    *fileContent = [[NSString alloc] initWithData:[readHandler readDataToEndOfFile] encoding:NSUTF8StringEncoding];
    NSArray     *rows = [fileContent componentsSeparatedByString:@"\n"];
    Item        *item = [[Item alloc] init];
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    for (int i=0; i<[rows count]; i++) {
        NSString    *row = [rows objectAtIndex:i];
        NSArray     *colums = [row componentsSeparatedByString:@","];
        item.title = [[colums objectAtIndex:0] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        item.price =[NSNumber numberWithFloat:[[[colums objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\"" withString:@""] floatValue]];
        item.quantity =[NSNumber numberWithInt:[[[colums objectAtIndex:2] stringByReplacingOccurrencesOfString:@"\"" withString:@""]intValue]];
        [items addObject:item];
    }
    [readHandler closeFile];
    NSLog(@"%@", items);
    return items;
}


- (NSMutableArray *) loadData{
    NSFileHandle *readHandler = [NSFileHandle fileHandleForReadingAtPath:self.filePath];
    NSString    *fileContent = [[NSString alloc] initWithData:[readHandler readDataToEndOfFile] encoding:NSUTF8StringEncoding];
    NSArray     *rows = [fileContent componentsSeparatedByString:@"\n"];
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    for (int i=0; i<[rows count]; i++) {
        Item        *currentItem= [[Item alloc] init];
        NSString    *row = [rows objectAtIndex:i];
        NSArray     *colums = [row componentsSeparatedByString:@","];
        currentItem.title = [colums objectAtIndex:0];
        currentItem.price = [NSNumber numberWithFloat:[[colums objectAtIndex:1] floatValue]];
        currentItem.quantity = [NSNumber numberWithInt:[[colums objectAtIndex:2] intValue]];
        [items addObject:currentItem];
    }
    [readHandler closeFile];
    return items;
}

- (void) addItem: (Item *) item{
    NSFileHandle *addHandler = [NSFileHandle fileHandleForUpdatingAtPath:self.filePath];
    NSString *dataString = [NSString stringWithFormat:@"%@, %@, %@ \n",
                            item.title,
                            [item.price stringValue],
                            [item.quantity stringValue]];
    [addHandler seekToEndOfFile];
    [addHandler writeData:[dataString dataUsingEncoding:NSUTF8StringEncoding]];
    [addHandler closeFile];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.filePath]){
        NSLog(@"We have a file");
        NSFileHandle *readHandler = [NSFileHandle fileHandleForReadingAtPath:self.filePath];
        NSString *fileContent = [[NSString alloc] initWithData:[readHandler availableData] encoding:NSUTF8StringEncoding];
        NSLog(@"Content is:%@", fileContent);
        [readHandler closeFile];
    }
    
}


@end
