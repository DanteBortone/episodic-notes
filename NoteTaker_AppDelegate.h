
//  Created by Dante Bortone with Copyright on 3/8/12.
//  Copyright 2012 Dante Bortone. All rights reserved.
//


#import <Cocoa/Cocoa.h>

@class DBAliasController;
@class DBCalendarController;
@class DBDetailController;
@class DBHyperlinkEditor;
@class DBControllerOfOutlineViews;
@class DBPreferencesController;
@class DBSearchController;
@class DBWikiWordController;
@class DBWindow;
@class DBTextFormats;
@class DBApplescriptController;
@class DBSubTopicController;
@class DBBrowserController;
@class DBCalendarSplitview;
@class DBEditTopicController;
@class DBAddTopicController;
@class DBMainSplitView;
@class DBUndoManager;

@interface NoteTaker_AppDelegate : NSObject <NSApplicationDelegate>
{
//Model
  NSPersistentStoreCoordinator *persistentStoreCoordinator;
  NSManagedObjectModel *managedObjectModel;
  NSManagedObjectContext *managedObjectContext;
  NSDate * autosaveTime;
  BOOL debugMode;
}

@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (strong) NSString *applicationSupportDirectory;
@property (strong) NSString *aliasFileFolder;
@property (strong) DBTextFormats *textFormatter;

@property BOOL firstTimeRunningApplication;
@property BOOL shouldResetViews;

@property (nonatomic, strong) IBOutlet NSWindow *mainWindow;

@property (strong) IBOutlet DBApplescriptController * appleScriptController;

@property (strong) IBOutlet DBHyperlinkEditor * hyperlinkEditor;

// controllers
@property (strong) IBOutlet DBControllerOfOutlineViews * controllerOfOutlineViews;
@property (strong) IBOutlet DBAliasController *aliasController;
@property (strong) IBOutlet DBDetailController *detailController;
@property (strong) IBOutlet DBCalendarController * calendarController;
@property (strong) IBOutlet DBWikiWordController * wikiWordController;
@property (strong) DBPreferencesController * preferences;
@property (strong) IBOutlet DBSearchController * searchController;
@property (strong) IBOutlet DBSubTopicController *subTopicController;
@property (strong) IBOutlet DBBrowserController * browserController;
@property (strong) IBOutlet DBCalendarSplitview * calendarSplitview;
@property (strong) IBOutlet DBEditTopicController * editTopicController;
@property (strong) IBOutlet DBAddTopicController * addTopicController;
@property (strong) IBOutlet DBMainSplitView * mainSplitView;

- (IBAction) saveAction:sender;
- (IBAction) testButton:(id)sender;

- (DBUndoManager *) undoManager;

- (void) save;
- (void) timedSave;
- (void) testing;

@end

#define INTERVAL 10 //sort index mulitple
