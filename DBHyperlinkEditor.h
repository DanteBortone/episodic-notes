//
//  DBHyperlinkController.h
//  NoteTaker
//
//  Created by Dante on 2/27/13.
//
//


#import <Cocoa/Cocoa.h>

@class DBControllerOfOutlineViews;
@class NoteTaker_AppDelegate;
@class DBGlobalWiki;
@class DBWikiWord;
@class DBTopicObject;

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
