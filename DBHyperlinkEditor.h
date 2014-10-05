/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import <Cocoa/Cocoa.h>
//---------------------------------------------

@class DBControllerOfOutlineViews;
@class NoteTaker_AppDelegate;
@class DBGlobalWiki;
@class DBWikiWord;
@class DBTopicObject;

//---------------------------------------------


@interface DBHyperlinkEditor : NSObject {

  DBControllerOfOutlineViews * controllerOfOutlineViews;
  NoteTaker_AppDelegate * appDelegate;
  NSManagedObjectContext * managedObjectContext;
  NSCharacterSet * prohibitedWikiCharacters;
  NSDictionary * localHyperlinkAttributes;
  NSDictionary * globalHyperlinkAttributes;
  NSDictionary * plainTextAttributes;
  NSDictionary * modelHyperlinkAttributes;
  NSArray * globalWikiWordStrings;
}

//@property (strong) NSFetchRequest * wikiFetchRequest;

- (NSAttributedString *) addWikiWordsToEntire:(NSString *)text withRespectTo:(DBTopicObject *)topic;
- (void) addHyperlinksToEntireTextOf:(NSTextView *)textObject withRespectTo:(DBTopicObject *)topic;
- (void) addModelLinksTo:(NSTextView *)textObject;
- (DBGlobalWiki *) globalWikiFromString:(NSString *) string;
- (void) setUpHandlingURLEvents;
//- (void) openLink: (NSString *)link;
- (void) updateGlobalWikiWordStrings;
- (BOOL) globalWikiWordsIncludesString: (NSString *) string;
- (DBWikiWord *) wikiWordFromString:(NSString *) string;
- (void) openWikiLink:(NSString*)rawLink;

@end
