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
- (void) copyCSVToDocuments;
- (void) createCSVInDocuments;
- (void) removeCSVFromDocuments;
- (NSString *) getCSVPath;
@end

@implementation DataManager


- (id) init{
//    [self copyCSVToDocuments];
//    [self removeCSVFromDocuments];
    [self createCSVInDocuments];
    return self;
}

- (void) copyCSVToDocuments {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSString *csvPath = [self getCSVPath];
    BOOL success = [fileManager fileExistsAtPath:csvPath];
    
    if(!success) {
        
        NSString *defaultCSVPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"data.csv"];
        success = [fileManager copyItemAtPath:defaultCSVPath toPath:csvPath error:&error];
        
        if (!success)
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        
        success = [fileManager fileExistsAtPath:csvPath];
        
        if (success)
        {
            NSLog(@"file exists");
        }
    }
    else
    {
        NSLog(@"file is already there");
    }
}

- (void) createCSVInDocuments {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSString *dbPath = [self getCSVPath];
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    
    if(!success) {
        
        success = [fileManager createFileAtPath:dbPath contents:nil attributes:nil];
        
        if (!success)
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        
        success = [fileManager fileExistsAtPath:dbPath];
        
        if (success)
        {
            NSLog(@"file exists");
        }
    }
    else
    {
        NSLog(@"file is already there");
    }
}


- (void) removeCSVFromDocuments {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSString *dbPath = [self getCSVPath];
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    
    if(success) {
        
        success = [fileManager removeItemAtPath:dbPath error:&error];
        
        if (!success)
            NSAssert1(0, @"Failed to delete writable database file with message '%@'.", [error localizedDescription]);
        
        success = [fileManager fileExistsAtPath:dbPath];
        
        if (!success)
        {
            NSLog(@"file deleted");
        }
    }
    else
    {
        NSLog(@"file is already deleted");
    }
}


- (NSString *) getCSVPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:@"data.csv"];
}

- (NSMutableArray *) loadData{
    NSFileHandle *readHandler = [NSFileHandle fileHandleForReadingAtPath:[self getCSVPath]];
    NSString    *fileContent = [[NSString alloc] initWithData:[readHandler readDataToEndOfFile] encoding:NSUTF8StringEncoding];
    NSArray     *rows = [fileContent componentsSeparatedByString:@"\n"];
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    for (int i=0; i<[rows count]; i++) {
        NSString    *row = [rows objectAtIndex:i];
        NSArray     *colums = [row componentsSeparatedByString:@","];
        Item        *item= [[Item alloc] init];
        item.title = [[colums objectAtIndex:0] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        item.price = [NSNumber numberWithFloat:[[[colums objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\"" withString:@""] floatValue]];
        item.quantity = [NSNumber numberWithInt:[[[colums objectAtIndex:2] stringByReplacingOccurrencesOfString:@"\"" withString:@""]intValue]];
        [items addObject:item];
    }
    [readHandler closeFile];
    return items;
}

- (void) addItem: (Item *) item{
    NSFileHandle *addHandler = [NSFileHandle fileHandleForUpdatingAtPath:[self getCSVPath]];
    NSString *dataString = [NSString stringWithFormat:@"\n%@, %@, %@",
                            item.title,
                            [item.price stringValue],
                            [item.quantity stringValue]];
    [addHandler seekToEndOfFile];
    [addHandler writeData:[dataString dataUsingEncoding:NSUTF8StringEncoding]];
    [addHandler closeFile];
    
}

- (void) deleteItem: (Item *) item atIndex: (NSInteger *)index{
    NSMutableArray *items = [self loadData];
    NSFileHandle *deleteHandler = [NSFileHandle fileHandleForUpdatingAtPath:[self getCSVPath]];
    NSString *dataString = [NSString stringWithFormat:@"\n%@, %@, %@",
                            item.title,
                            [item.price stringValue],
                            [item.quantity stringValue]];
    [deleteHandler seekToEndOfFile];
    [deleteHandler writeData:[dataString dataUsingEncoding:NSUTF8StringEncoding]];
    [deleteHandler closeFile];
}

@end
