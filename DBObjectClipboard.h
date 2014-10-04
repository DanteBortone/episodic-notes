//
//  DBClipboardObject.h
//  Episodic Notes
//
//  Created by Dante Bortone on 3/6/14.
//
//

#import <CoreData/CoreData.h>

@interface DBObjectClipboard : NSManagedObject

// Relationships ----------
@property (strong) NSSet * items;

- (NSArray *) flattenedContent;
- (NSArray *) orderedContent; //returns order array of clipboard items sorted by sortIndex
- (BOOL) containsDetailObjects;

@end
