/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import <Cocoa/Cocoa.h>
//---------------------------------------------

@class DBWikiWord;
@class DBDetail;

//---------------------------------------------


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
