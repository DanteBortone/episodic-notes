//
//  DBManagedTreeObject.h
//  NoteTaker
//
//  Created by Dante Bortone with Copyright on 6/5/12.
//  Copyright 2012 Dante Bortone. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface DBManagedTreeObject : NSManagedObject

// Attributes -------------
@property (strong) NSString * displayName;
@property (strong) NSNumber * isExpanded;
@property (strong) NSNumber * isLeaf;//needed for dividers and local topic headers
@property (strong) NSNumber * sortIndex;

// Relationships ----------
@property (strong) DBManagedTreeObject * parent;
@property (strong) NSSet* subGroups;


@property (strong) NSNumber *initializingObject;


- (NSArray *) flattenedWithSubGroups;
//- (Boolean) booleanIsLeaf;
- (Boolean) isALeaf;
- (Boolean) isNotALeaf;
- (NSArray *)descendantObjects;

- (void) doneInitializing;


@end
