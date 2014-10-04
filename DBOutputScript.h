//
//  DBOutputScript.h
//  NoteTaker
//
//  Created by Dante on 10/9/13.
//
//

#import <CoreData/CoreData.h>

@class DBApplication;

@interface DBOutputScript : NSManagedObject

// Attributes -------------
@property (strong) NSString * displayName;
@property (strong) NSString * script;
@property (strong) NSString * testValue;
@property (strong) NSString * testPath;
@property (strong) NSNumber * isEditable; // don't want to allow editing of default scripts so I can edit them

// Relationships ----------
@property (strong) DBApplication * application;
@property (strong) NSSet* details;
@property (strong) NSSet* inputScripts;

-(NSString *)applicationOutputDisplay;
-(NSInteger)detailNumber;

@end
