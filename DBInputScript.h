//
//  DBOpenScript.h
//  NoteTaker
//
//  Created by Dante on 10/7/13.
//
//

#import <CoreData/CoreData.h>

@class DBApplication;
@class DBOutputScript;
@class DBUndoManager;

@interface DBInputScript : NSManagedObject

@property (strong, nonatomic) DBUndoManager * undoManager;


// Attributes -------------
@property (strong) NSString * displayName;
@property (strong) NSString * script;
@property (strong) NSNumber * isActiveScript;
@property (strong) NSNumber * isEditable; // don't want to allow editing of default scripts so I can edit them


// Relationships ----------
@property (strong) DBApplication * application;

@property (strong) DBOutputScript * outputScript;

@end
