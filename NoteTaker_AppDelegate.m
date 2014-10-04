//
//  NoteTaker_AppDelegate.m
//  NoteTaker
//
//  Created by Dante Bortone with Copyright on 3/8/12.
//  Copyright 2012. All rights reserved.
//


//	Next steps
// do code signing procedure: https://developer.apple.com/library/mac/#documentation/security/Conceptual/CodeSigningGuide/Procedures/Procedures.html

// If you use sortedtree, acknowledgement in an About Page or other appropriate place would be nice.
// For example, "Contains "Sorted Tree" by Jonathan Dann" will do.

//---------------------------------------------
#import "NoteTaker_AppDelegate.h"
//---------------------------------------------
#import "DBCalendarController.h"
#import "DBHyperlinkEditor.h"
#import "DBControllerOfOutlineViews.h"
#import "DBSearchController.h"
#import "DBTextFormats.h"
#import "DBDetailController.h"
#import "DBDetailController.h"
#import "DBApplescriptController.h"
#import "DBWikiWordController.h"
#import "DBAliasController.h"
#import "DBViewObject.h"
#import "DBCalendarSplitview.h"
#import "DBMainSplitView.h"
#import "DBUndoManager.h"

#define STORAGE_PATH @"episodicdata"
#define DEMO_DATA_PATH @"episodicdata"
#define CURRENT_APPLESCRIPT_VERSION 0.3f
#define CURRENT_PROGRAM_VERSION 0.4f
#define PATH_DIRECTORY @"EpisodicNotes/Journal" // use "EpisodicNotes/Demo" or something else here if you just want to input test data



@implementation NoteTaker_AppDelegate

@synthesize textFormatter;
@synthesize aliasController;
@synthesize aliasFileFolder;
@synthesize appleScriptController;
@synthesize applicationSupportDirectory;
@synthesize calendarController;
@synthesize detailController;
@synthesize hyperlinkEditor;
@synthesize mainWindow;
@synthesize controllerOfOutlineViews;
@synthesize preferences;
@synthesize searchController;
@synthesize wikiWordController;
@synthesize firstTimeRunningApplication;
@synthesize subTopicController;
@synthesize browserController;
@synthesize calendarSplitview;
@synthesize editTopicController;
@synthesize addTopicController;
@synthesize mainSplitView;
@synthesize shouldResetViews;

#pragma mark -
#pragma mark Initialization

// -------------------------------------------------------------------------------

//  init

// -------------------------------------------------------------------------------

- (id) init
{
  //NSLog(@"appDelegate:init");
  
  if (self = [super init]){
    
    //[self resetDefaults];  // just for practicing a reset

    applicationSupportDirectory = [ self initializeApplicationSupportDirectory ];
    
    textFormatter = [[DBTextFormats alloc] init];
    
    debugMode = NO;

#ifdef DEBUG
    //NSLog(@"running in debug mode");
    debugMode = YES;
#endif
    
    shouldResetViews = NO; // this will change to yes if version change is detected through [self resetViews]
    
    NSURL *url = [NSURL fileURLWithPath: [applicationSupportDirectory stringByAppendingPathComponent: STORAGE_PATH]];
  
   if(![url checkResourceIsReachableAndReturnError:NULL]){
     NSLog(@"Core data file not detected.");
     
     firstTimeRunningApplication = YES;  //set to "NO" on 1st save

     if (debugMode) {
       
       [self resetDefaults];
       
     }
     
   }
    
  [ self checkForProgramVersionChange ];
    
  [ self specifyUserDefaultSettings ]; //a user wouldn't have anything to reset

    
  [ self updateAutosaveTime ]; // for the first application run this has to be after setting userdefaults

  }

  return self;

}


- (void) checkForProgramVersionChange
{
  
  //NSLog(@"checkForProgramVersionChange");
  NSNumber * updatedVersionNumber = [[NSUserDefaults standardUserDefaults] valueForKey:@"programVersion"];
  
  float updatedVersion = [updatedVersionNumber floatValue];
  //NSLog(@"loadedVersion: %f", updatedVersion);
  //NSLog(@"CURRENT_PROGRAM_VERSION: %f", CURRENT_PROGRAM_VERSION);
  if (CURRENT_PROGRAM_VERSION != updatedVersion){
    
    NSLog(@"Version change detected.");

    //[ self resetDefaults ];
    [ self resetViews ];
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithFloat:CURRENT_PROGRAM_VERSION] forKey:@"programVersion"];
    
  }
  
}


// -------------------------------------------------------------------------------

//  resetDetailViews

// -------------------------------------------------------------------------------
// when reseting version the view value should be reset
//   in case the old values will cause problems

-(void) resetViews
{
  // when we have version changes some views need to be reset
  // or the old user values could put in values that don't work with the new settings
  
  // ---------- < reset detail view panels > ------------
  // fetch all the views
  NSFetchRequest *fetchAllViewObjects = [[NSFetchRequest alloc] init];
  [fetchAllViewObjects setEntity:[NSEntityDescription entityForName:@"ViewObject" inManagedObjectContext:self.managedObjectContext]];
  
  NSError *error = nil;
  NSArray *viewObjects = [self.managedObjectContext executeFetchRequest:fetchAllViewObjects error:&error];

  for (DBViewObject * viewObject in viewObjects) {
    
    [viewObject resetView];
    
  }
  // ---------- < / reset detail view panels > ------------

  shouldResetViews = YES;
  
}


// -------------------------------------------------------------------------------

//  ensureAppleSriptsAreCurrent

// -------------------------------------------------------------------------------

-(void) ensureAppleSriptsAreCurrent
{
  
  // NSLog(@"ensureAppleSriptsAreCurrent");
  NSNumber * updatedVersionNumber = [[NSUserDefaults standardUserDefaults] valueForKey:@"applescriptVersion"];
  
  float updatedVersion = [updatedVersionNumber floatValue];
  
  // NSLog(@"presentVersion: %f", presentVersion);
  // NSLog(@"CURRENT_APPLESCRIPT_VERSION: %f", CURRENT_APPLESCRIPT_VERSION);

  
  if (CURRENT_APPLESCRIPT_VERSION > updatedVersion){
    
    NSLog(@"Updating scripts.");
    
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithFloat:CURRENT_APPLESCRIPT_VERSION] forKey:@"applescriptVersion"];

    [self.appleScriptController resetDefaultScripts:NULL];
 
  }
                       
  
}


// -------------------------------------------------------------------------------

// resetDefaults

// -------------------------------------------------------------------------------

- (void) resetDefaults
{
  
  // reset user default settings
  
  //  Doesn't work for 10.8
  //  NSString *domainName = [[NSBundle mainBundle] bundleIdentifier];
  //  [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:domainName];

  // from  http://stackoverflow.com/questions/15018796/removepersistentdomainforname-not-working-for-nsuserdefaults
  [[NSUserDefaults standardUserDefaults] setPersistentDomain:@{@"": @""} forName:[NSBundle mainBundle].bundleIdentifier];
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@""];
  
}


// -------------------------------------------------------------------------------

// updateAutosaveTime

// -------------------------------------------------------------------------------

- (void) updateAutosaveTime
{

  NSInteger seconds = 60* [[NSUserDefaults standardUserDefaults] integerForKey:@"minutesBetweenAutosaves"];
  
  autosaveTime = [[NSDate date] dateByAddingTimeInterval:seconds];
  
}


// -------------------------------------------------------------------------------

//  awakeFromNib

// -------------------------------------------------------------------------------

- (void)awakeFromNib
{
  
  [ searchController initializeSearchPredicate ];

}



// -------------------------------------------------------------------------------

//  applicationWillFinishLaunching :

// -------------------------------------------------------------------------------

- (void) applicationWillFinishLaunching : (NSNotification *) aNotification
{

  [hyperlinkEditor setUpHandlingURLEvents];

}



// -------------------------------------------------------------------------------

//  applicationDidFinishLaunching :

// -------------------------------------------------------------------------------

- (void)applicationDidFinishLaunching:(NSNotification *) aNotification {
 
  if (firstTimeRunningApplication){
  
    //[ detailController createDefaultItems ]; // loading these from 
    [ appleScriptController createDefaultScripts ];

  } else {
    
    [ self ensureAppleSriptsAreCurrent ];
  
  }

  [ controllerOfOutlineViews loadStoredTopicsIntoOutlines ];

  [calendarController updateAllCalendarElements];
  
  //sort topic list for wiki word panel
  NSOutlineView * wikiWordPanelTopicView = [self.wikiWordController myOutlineView];
  
  NSTableColumn *topicColumn = [[wikiWordPanelTopicView tableColumns] objectAtIndex:0];
  
  NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey: [[topicColumn sortDescriptorPrototype] key] ascending: YES];
  
  [wikiWordPanelTopicView setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
  
  
  //sort recent topic lists
  // have to find which column is visible
  
  NSTableView * recentTopicTable = [controllerOfOutlineViews recentTopicTable];
  NSArray * tableColumns = [recentTopicTable tableColumns];
  for (NSTableColumn * dateColumn in tableColumns) {
   
    if (![dateColumn isHidden]) {
      
      if(![dateColumn.identifier isEqualToString:@"Topic"]){
        
        NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey: [[dateColumn sortDescriptorPrototype] key] ascending: NO];
        [recentTopicTable setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
      }
      
    }
    
  }
  
  [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidFinishLaunching" object:nil ];
  
  //[managedObjectContext.undoManager enableUndoRegistration];

}


// -------------------------------------------------------------------------------

// applicationShouldHandleReopen : hasVisibleWindows :

// -------------------------------------------------------------------------------

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag{

  //NSLog(@"applicationShouldHandleReopen");
  
  return TRUE;

}


// -------------------------------------------------------------------------------

//  treeNodeSortDescriptors

// -------------------------------------------------------------------------------

- (NSArray *)treeNodeSortDescriptors;
{
	return [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"sortIndex" ascending:YES]];
}


// -------------------------------------------------------------------------------

//  createAliasFileFolder

// -------------------------------------------------------------------------------

-(void) createAliasFileFolder{

  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSError *error = nil;

  aliasFileFolder = [applicationSupportDirectory stringByAppendingPathComponent: @"Aliases"];
  if ( ![fileManager fileExistsAtPath:aliasFileFolder isDirectory:NULL] ) {
    if (![fileManager createDirectoryAtPath:aliasFileFolder withIntermediateDirectories:NO attributes:nil error:&error]) {
      NSAssert(NO, ([NSString stringWithFormat:@"Failed to create alias file folder %@ : %@", aliasFileFolder,error]));
      NSLog(@"Error creating alias file folder at %@ : %@",aliasFileFolder,error);
    }
  }
  
}

#pragma mark -
#pragma mark Model


// -------------------------------------------------------------------------------

//  initializeApplicationSupportDirectory

// -------------------------------------------------------------------------------

- (NSString *)initializeApplicationSupportDirectory {
  
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
  NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
  return [basePath stringByAppendingPathComponent:PATH_DIRECTORY];
  
  //return NSHomeDirectory();  //for sandboxing
  //with sandboxing have to give up resolving alias and opening files through scripting bridge
  //but might be albe to open through nsworkspace

}



	/**
	 Creates, retains, and returns the managed object model for the application 
	 by merging all of the models found in the application bundle.
	 */

// -------------------------------------------------------------------------------

//  managedObjectModel

// -------------------------------------------------------------------------------

	- (NSManagedObjectModel *)managedObjectModel {
		
		if (managedObjectModel) return managedObjectModel;
		
		managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];    
		return managedObjectModel;
	}




	/**
	 Returns the persistent store coordinator for the application.  This 
	 implementation will create and return a coordinator, having added the 
	 store for the application to it.  (The directory for the store is created, 
	 if necessary.)
	 */

// -------------------------------------------------------------------------------

//  persistentStoreCoordinator

// -------------------------------------------------------------------------------

- (NSPersistentStoreCoordinator *) persistentStoreCoordinator
{
  
  //NSLog(@"appDelegate:persistentStoreCoordinator");

  
  if (persistentStoreCoordinator) return persistentStoreCoordinator;
  
  NSManagedObjectModel *mom = [self managedObjectModel];
  if (!mom) {
    NSAssert(NO, @"Managed object model is nil");
    NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
    return nil;
  }
  
  NSFileManager *fileManager = [NSFileManager defaultManager];

  NSError *error = nil;
  
  if ( ![fileManager fileExistsAtPath:applicationSupportDirectory isDirectory:NULL] ) {
    //NSLog(@"No application directory: %@", applicationSupportDirectory);
    
    if (![fileManager createDirectoryAtPath:applicationSupportDirectory withIntermediateDirectories:YES attributes:nil error:&error]) {
      NSAssert(NO, ([NSString stringWithFormat:@"Failed to create App Support directory %@ : %@", applicationSupportDirectory,error]));
      NSLog(@"Error creating application support directory at %@ : %@",applicationSupportDirectory,error);
      return nil;
    }
    
  }
  
  [self createAliasFileFolder];

  NSURL *url = [NSURL fileURLWithPath: [applicationSupportDirectory stringByAppendingPathComponent: STORAGE_PATH]];
  
  persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: mom];

//updates old db to new
  NSDictionary *optionsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                     [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
  
  // Is core data file is absent.
  if(![url checkResourceIsReachableAndReturnError:NULL]){
    
    NSURL * bundleURL = [[NSBundle mainBundle] bundleURL];
    
    //NSString *pathToDemoData = [NSString stringWithFormat:DEMO_DATA_PATH];
    NSURL * defaultDataDirectory = [bundleURL URLByAppendingPathComponent:@"Contents/"];
    NSURL * defaultDataURL = [defaultDataDirectory URLByAppendingPathComponent:DEMO_DATA_PATH];
    
    //NSLog(@"No core data file found. Checking for demo data: %@", defaultDataURL.path);
    
    //Is demo data present?
    if([defaultDataURL checkResourceIsReachableAndReturnError:NULL]){
      
      //NSLog(@"Found demo data.");
      
      // copy demo data to correct location
      [fileManager copyItemAtURL:defaultDataURL toURL:url error:&error];
      
      // create a shortcut to safari that the default data will use
      // first find application directory
      
      NSURL * applicationDirectory = [[[NSFileManager defaultManager] URLsForDirectory: NSApplicationDirectory inDomains:NSLocalDomainMask] lastObject];
      
      NSURL * safariURL = [applicationDirectory URLByAppendingPathComponent:@"Safari.app"];
      
      //-------------Making safari alias---------------
      //There is a method in aliasController that would make this link for us but it hasn't awoken from nib at this point
      NSURL * aliasFileLocation = [NSURL fileURLWithPath:[aliasFileFolder stringByAppendingPathComponent: @"Safari.app"]];
      
      NSData * bookmark = [safariURL bookmarkDataWithOptions: NSURLBookmarkCreationSuitableForBookmarkFile includingResourceValuesForKeys:nil relativeToURL:nil error:&error];
      
      [NSURL writeBookmarkData:bookmark toURL:aliasFileLocation options:NSURLBookmarkCreationSuitableForBookmarkFile error:&error];
      //-----------------------------------------------
      
    } else {
      
      //NSLog(@"Could not find demo data.");
      
    }
    
  }
  
  // Core data file is made here
  if (![persistentStoreCoordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil
                                                          URL:url
                                                      options:optionsDictionary
                                                        error:&error]){
    
    [[NSApplication sharedApplication] presentError:error];
    persistentStoreCoordinator = nil;
    return nil;
  }    

  return persistentStoreCoordinator;
}

	/**
	 Returns the managed object context for the application (which is already
	 bound to the persistent store coordinator for the application.) 
	 */


// -------------------------------------------------------------------------------

//  managedObjectContext

// -------------------------------------------------------------------------------

- (NSManagedObjectContext *) managedObjectContext {
  
  if (managedObjectContext) return managedObjectContext;
  
  NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
  if (!coordinator) {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
    [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
    NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
    [[NSApplication sharedApplication] presentError:error];
    return nil;
  }
  
  managedObjectContext = [[NSManagedObjectContext alloc] init];
  [managedObjectContext setPersistentStoreCoordinator: coordinator];
  
  //setup undomanager
  DBUndoManager * undoManager = [[DBUndoManager alloc] init];
  [undoManager disableUndoRegistration];
  [undoManager setGroupsByEvent:NO]; // prevents beginUndoGroupings from being created with loops
  [managedObjectContext setUndoManager:undoManager];
  
  return managedObjectContext;
}

- (NSUndoManager *) undoManager

{
  //NSLog(@"app delegate getting undo manager");
  
  return [[self managedObjectContext] undoManager];
  
}


/**
 Returns the NSUndoManager for the application.  In this case, the manager
 returned is that of the managed object context for the application.
 */


// -------------------------------------------------------------------------------

// windowWillReturnUndoManager :

// -------------------------------------------------------------------------------

- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
  
  return [[self managedObjectContext] undoManager];

}


/**
 Performs the save action for the application, which is to send the save:
 message to the application's managed object context.  Any encountered errors
 are presented to the user.
 */

// -------------------------------------------------------------------------------

//  saveAction :

// -------------------------------------------------------------------------------

- (IBAction)saveAction:(id)sender
{

  [self save];

}


// -------------------------------------------------------------------------------

//  save

// -------------------------------------------------------------------------------

- (void) save
{
  
  //[controllerOfOutlineViews debugInfo];
  
  NSLog(@"saving...");
  NSError *error = nil;
  
  // error when it's loading new views but it still tries to save
  
  if (firstTimeRunningApplication) {

    firstTimeRunningApplication = NO;
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstTimeRunningApplication"];

  }
  
  if (![[self managedObjectContext] save:&error]) {
    [[NSApplication sharedApplication] presentError:error];
  }


  [self updateAutosaveTime];

}

// -------------------------------------------------------------------------------

//  saveWithDelay

// -------------------------------------------------------------------------------
// need a little delay on the save for when the save is triggered by a change in first responder
// the item clicked to make the trigger happen may need to finish
// eg. when the add view button is clicked, it will save before the required view topic is added to the view object.
- (void) saveWithDelay
{
 
  [ self performSelector:@selector(save) withObject:NULL afterDelay:(float) 0.005 ];
  
}


//called by mainWindows and applescripteditor window's makeFirstResponder


// -------------------------------------------------------------------------------

// timedSave

// -------------------------------------------------------------------------------

- (void) timedSave
{
  
  if ([autosaveTime compare:[NSDate date]] == NSOrderedAscending) {
    NSLog(@"time to save -----------------");

    //NSLog(@"autosave date: %@",autosaveTime);
    //NSLog(@"current date:  %@",[NSDate date]);
    
    [self updateAutosaveTime]; //needs to be here to prevent the save from being called twice

    [self saveWithDelay];
    
  } //else {
    
    //NSLog(@"not time to save yet----------");
  
    //NSLog(@"autosave date: %@",autosaveTime);
    //NSLog(@"current date:  %@",[NSDate date]);
  
  //}
  
}

#pragma mark -
#pragma mark Buttons

// -------------------------------------------------------------------------------

//  testButton:

// -------------------------------------------------------------------------------
// for debugging

- (IBAction)testButton:(id)sender
{

  //NSLog(@"%@",[[controllerOfOutlineViews.rightDetailViewDelegate.view itemAtRow:0] className]);

  
}


#pragma mark -
#pragma mark Termination

// -------------------------------------------------------------------------------

//  applicationShouldTerminateAfterLastWindowClosed:

// -------------------------------------------------------------------------------

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *) theApp; {
  return YES;
}

/**
 Implementation of the applicationShouldTerminate: method, used here to
 handle the saving of changes in the application managed object context
 before the application terminates.
 */


// -------------------------------------------------------------------------------

// applicationShouldTerminate

// -------------------------------------------------------------------------------

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {

  //store user search predicate values
  [ searchController storeSearchPredicate ];

  if (!managedObjectContext) return NSTerminateNow;
	
    if (![managedObjectContext commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }
	
    if (![managedObjectContext hasChanges]) return NSTerminateNow;
	
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
		
        // This error handling simply presents error information in a panel with an 
        // "Ok" button, which does not include any attempt at error recovery (meaning, 
        // attempting to fix the error.)  As a result, this implementation will 
        // present the information to the user and then follow up with a panel asking 
        // if the user wishes to "Quit Anyway", without saving the changes.
		
        // Typically, this process should be altered to include application-specific 
        // recovery steps.  
		
        BOOL result = [sender presentError:error];
        if (result) return NSTerminateCancel;
		
        NSString *question = NSLocalizedString(@"Could not save changes while quitting.  Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];
		
        NSInteger answer = [alert runModal];
        alert = nil;
        
        if (answer == NSAlertAlternateReturn) return NSTerminateCancel;
		
    }
	
  [self closeScriptTaker];
  
  return NSTerminateNow;
}


// -------------------------------------------------------------------------------

// closeScriptTaker

// -------------------------------------------------------------------------------

- (void) closeScriptTaker
{
  
  NSString *scriptString = @"tell application \"ScriptTaker\" to quit";
  
  
  NSAppleScript * appleScript = [[NSAppleScript alloc] initWithSource:scriptString];
  
  NSDictionary *errorDict;
  
  
  if ([appleScript compileAndReturnError:&errorDict]){
    
    [appleScript executeAndReturnError:&errorDict];
    
  }
  
}
/**
 Implementation of dealloc, to release the retained variables.
 */



// -------------------------------------------------------------------------------

// specifyUserDefaultSettings

// -------------------------------------------------------------------------------

-(void) specifyUserDefaultSettings
{
  //NSLog(@"appDelegate specifyUserDefaultSettings");
  
  NSData * linkColor = [NSArchiver archivedDataWithRootObject:[NSColor blueColor]];
  
  [[NSUserDefaults standardUserDefaults] registerDefaults:
   [NSDictionary dictionaryWithObjectsAndKeys:
    [NSNumber numberWithInt:15], @"minutesBetweenAutosaves",
    @"Folder", @"folderBaseName",
    @"Bullet", @"detailBaseName",
    
    @"Folder", @"activeTab", // for navigation view
    
    @"\"", @"appendBeforeQuote",  // text appended before a quote
    @"\"", @"appendAfterQuote",  // text appended before a quote

    [NSNumber numberWithInt:5], @"wordsOfNoteInTitle",

    //@"Details", @"activeDetailRelatedTab",  // XXXXX Get rid of XXXXXXX
    
    [ NSNumber numberWithFloat:0.0f ], @"applescriptVersion",
    [ NSNumber numberWithFloat:0.0f ], @"programVersion",

    
    @"/", @"navigationHomePath",
    [NSNumber numberWithBool:NO], @"showChecksOfAllSubGroups",
    
    [NSNumber numberWithBool:YES], @"topicsIgnoreCase",
    [NSNumber numberWithBool:YES], @"topicsIgnoreDiacritic",
    
    [NSNumber numberWithBool:NO], @"closeTopicPanelAfterAdd",
    [NSNumber numberWithBool:NO], @"openWikiPanelAfterTopicAdd",
    [NSNumber numberWithBool:NO], @"insertNewTopicAsWikiWord",
    [NSNumber numberWithBool:YES], @"insertNewTopicAfterAdd",
    [NSNumber numberWithBool:YES], @"loadNewTopicIntoActiveView",
    
    [NSNumber numberWithBool:YES], @"calendarDisclosure",
    
    [NSNumber numberWithBool:YES], @"topicViewRelatedDisclosure",
    [NSNumber numberWithBool:YES], @"topicViewDetailDisclosure",
    
    [NSNumber numberWithBool:YES], @"dateViewRelatedDisclosure",
    [NSNumber numberWithBool:YES], @"dateViewDetailDisclosure",
    
    [NSNumber numberWithBool:YES], @"firstTimeRunningApplication",
    
    
    [NSNumber numberWithInt:156], @"calendarUncollapseSize",
    [NSNumber numberWithInt:30], @"dateDetailUncollapseSize",
    [NSNumber numberWithInt:30], @"dateRelatedUncollapseSize",
    [NSNumber numberWithInt:30], @"topicDetailUncollapseSize",
    [NSNumber numberWithInt:30], @"topicRelatedUncollapseSize",

    
    
    [NSNumber numberWithInt:1], @"insertTopicOptions",

    @"-------------------", @"dividerStyle",
    
    @"Current", @"targetViewForTopic",
    //for NSSegmentedControllers
    [NSNumber numberWithInt:1], @"targetViewIndex",
    [NSNumber numberWithInt:0], @"dragTypeIndex",
    [NSNumber numberWithInt:156], @"calendarUncollapseSize",
    
    [NSNumber numberWithBool:YES], @"calendarIsHidden",
    [NSNumber numberWithBool:NO], @"showAddTopicOptions",
    //radio matrix buttons
    
    @"Move",@"selectedDragType",
    linkColor, @"linkColor",
    
    [NSNumber numberWithInt:0], @"topicViewRadioSelection",
    [NSNumber numberWithInt:0], @"dateViewRadioSelection",
    // ----------- < Help panels > --------------------------
    [NSNumber numberWithBool:NO], @"hideAllTipButtons",
    [NSNumber numberWithBool:NO], @"hideMainTopicWikiWordTip",
    [NSNumber numberWithBool:NO], @"hideTemplatesTip",
    [NSNumber numberWithBool:NO], @"hideInsertOptonsTip",
    [NSNumber numberWithBool:NO], @"hideLockedScriptTip",
    
    
    // ----------- < / Help panels > --------------------------

    
    
    nil]];
    
}


// -------------------------------------------------------------------------------

// testing

// -------------------------------------------------------------------------------

- (void) testing
{
  
  NSLog(@"appDelegate testing...");
  
}

@end

