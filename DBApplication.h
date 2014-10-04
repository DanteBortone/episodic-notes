//
//  DBApplication.h
//  NoteTaker
//
//  Created by Dante on 10/7/13.
//
//

#import <CoreData/CoreData.h>

@interface DBApplication : NSManagedObject

// Attributes -------------
@property (strong) NSString * displayName;
@property (strong) NSString * comment;

// Relationships ----------
@property (strong) NSSet* inputScripts;
@property (strong) NSSet* outputScripts;

@end
