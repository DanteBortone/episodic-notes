//
//  DBTopicObject.h
//  NoteTaker
//
//  Copyright 2012 Dante Bortone. All rights reserved.
//
//


#import <Cocoa/Cocoa.h>


@class DBWikiWord;
@class DBDetail;

@interface DBTopicObject: NSManagedObject


// Attributes -------------
@property (strong) NSDate * dateViewed;
@property (strong) NSDate * dateCreated;
@property (strong) NSDate * dateModified;
@property (strong) NSString * displayName;
//@property (strong) NSNumber * isGlobal;

// Relationships ----------
@property (strong) NSSet * details;
@property (strong) NSSet * headers;
@property (strong) NSSet * views;
//@property (strong) NSSet * wikiWords;

- (NSString *) wikiString; // for subtopic and main topics
- (BOOL) isGlobal;
- (BOOL) isLeaf;
- (NSSet *) rootSet;
//- (NSUInteger) rootCount;

// to hide/show buttons for detail view
-(BOOL) isWikiTopic;
-(BOOL) isFileTopic;
-(BOOL) isDateTopic;


- (NSString *) formattedName;
- (NSString *) tabbedName;  // just tabs over subtopics names for the topic editor comboBox
//- (void) addWikiWord:(DBWikiWord *) word;
//- (void) removeWikiWord:(DBWikiWord *) word;

@end
