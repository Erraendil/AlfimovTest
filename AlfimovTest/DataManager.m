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
- (void) copyCSVToDocumentsIfNeeded;
- (void) createCSVInDocuments;
- (void) removeCSVFromDocuments;
- (NSString *) getCSVPath;
- (void) saveDataFromString: (NSString *)string;
- (NSMutableArray *) stringToArrayOfItems: (NSString *)string;
- (NSString *) arrayOfItemsToString: (NSMutableArray *) array;
- (NSMutableArray *) addToItemsArray: (NSMutableArray *)array item: (Item *)item;
- (NSMutableArray *) updateItemsArray: (NSMutableArray *)array byItem: (Item *)item withIndex: (NSInteger)index;
- (NSMutableArray *) deleteFromItemsArray: (NSMutableArray *)array item: (Item *)item withIndex: (NSInteger)index;
@end

@implementation DataManager


- (id) init{
    [self copyCSVToDocumentsIfNeeded];
    return self;
}

#pragma mark - Public methods

- (NSMutableArray *) loadData{
    NSFileHandle *readHandler = [NSFileHandle fileHandleForReadingAtPath:[self getCSVPath]];
    NSString    *fileContent = [[NSString alloc] initWithData:[readHandler readDataToEndOfFile] encoding:NSUTF8StringEncoding];
    [readHandler closeFile];
    return [self stringToArrayOfItems:fileContent];
}

- (NSMutableArray *) reloadData{
    [self removeCSVFromDocuments];
    [self copyCSVToDocumentsIfNeeded];
    NSFileHandle *readHandler = [NSFileHandle fileHandleForReadingAtPath:[self getCSVPath]];
    NSString    *fileContent = [[NSString alloc] initWithData:[readHandler readDataToEndOfFile] encoding:NSUTF8StringEncoding];
    [readHandler closeFile];
    return [self stringToArrayOfItems:fileContent];
}

- (void) addItem: (Item *) item{
    [self saveDataFromString:[self arrayOfItemsToString:[self addToItemsArray:[self loadData] item:item]]];
}
- (void) updateItem: (Item *) item withIndex: (NSInteger)index{
    [self saveDataFromString:[self arrayOfItemsToString:[self updateItemsArray:[self loadData] byItem:item withIndex:index]]];
}
- (void) deleteItem: (Item *) item withIndex: (NSInteger)index{
     [self saveDataFromString:[self arrayOfItemsToString:[self deleteFromItemsArray:[self loadData] item:item withIndex:index]]];
}

#pragma mark - Documtns methods

- (void) copyCSVToDocumentsIfNeeded {
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


- (void) saveDataFromString: (NSString *)string{
    [self removeCSVFromDocuments];
    [self createCSVInDocuments];
    NSFileHandle *addHandler = [NSFileHandle fileHandleForUpdatingAtPath:[self getCSVPath]];
    [addHandler seekToEndOfFile];
    [addHandler writeData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    [addHandler closeFile];
}

#pragma mark - Convertation

- (NSMutableArray *) stringToArrayOfItems: (NSString *)string{
    NSArray     *rows = [string componentsSeparatedByString:@"\n"];
    NSMutableArray *arrayOfItems = [[NSMutableArray alloc] init];
    
    for (int i=0; i<[rows count]; i++) {
        NSString    *row = [rows objectAtIndex:i];
        NSArray     *colums = [row componentsSeparatedByString:@","];
        Item        *item= [[Item alloc] init];
        item.title = [[colums objectAtIndex:0] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        item.price = [NSNumber numberWithFloat:[[[colums objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\"" withString:@""] floatValue]];
        item.quantity = [NSNumber numberWithInt:[[[colums objectAtIndex:2] stringByReplacingOccurrencesOfString:@"\"" withString:@""]intValue]];
        [arrayOfItems addObject:item];
    }
    return arrayOfItems;
}

- (NSString *) arrayOfItemsToString: (NSMutableArray *) array{
    NSString *string = @"";
    
    for (int i=0; i<[array count]; i++) {
        if (i==[array count]-1)
            string = [string stringByAppendingString:[NSString stringWithFormat:@"%@, %@, %@",
                                                      [[array objectAtIndex:i] title],
                                                      [[[array objectAtIndex:i] price] stringValue],
                                                      [[[array objectAtIndex:i] quantity] stringValue]]];
        else
            string = [string stringByAppendingString:[NSString stringWithFormat:@"%@, %@, %@\n",
                                                      [[array objectAtIndex:i] title],
                                                      [[[array objectAtIndex:i] price] stringValue],
                                                      [[[array objectAtIndex:i] quantity] stringValue]]];
    }
    return string;
}

#pragma mark - Array and string manager

- (NSMutableArray *) addToItemsArray: (NSMutableArray *)array item: (Item *)item{
    [array addObject:item];
    return array;
}

- (NSMutableArray *) updateItemsArray: (NSMutableArray *)array byItem: (Item *)item withIndex: (NSInteger)index{
    [array replaceObjectAtIndex:index withObject:item];
    return array;
}

- (NSMutableArray *) deleteFromItemsArray: (NSMutableArray *)array item: (Item *)item withIndex: (NSInteger)index{
    [array removeObjectAtIndex:index];
    return array;
}
@end
