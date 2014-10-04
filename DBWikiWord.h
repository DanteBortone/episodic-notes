//
//  DBWikiWord.h
//  NoteTaker
//
//  Created by Dante on 2/27/13.
//
//

#import <CoreData/CoreData.h>

//@class DBTopicObject;


@interface DBWikiWord : NSManagedObject

// Attributes -------------
@property (strong) NSString * word;
@property (strong) NSNumber * isPrimary;

// Relationships ----------
//@property (strong) DBTopicObject * topic;

-(BOOL) isGlobal;

@end
