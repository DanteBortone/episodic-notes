//
//  DBApplescriptController.h
//  NoteTaker
//
//  Created by Dante on 10/7/13.
//
//

#import "DBObjectController.h"

@class DBOutputScript;
@class DBDetail;
@class DBOutputScriptPanelController;

@class DBUndoManager;

@interface DBApplescriptController : DBObjectController {

  NSManagedObjectContext * managedObjectContext;
  DBUndoManager * undoManager;
  
  
  id editingScript; // will be DBInputScript or DBOutputScript
  
  IBOutlet DBOutputScriptPanelController *outputScriptPanelController;
  IBOutlet NSArrayController * applicationArrayController;
  IBOutlet NSArrayController * inputScriptArrayController;

  IBOutlet NSWindow * myWindow;
  IBOutlet NSButton * addApplication;
  IBOutlet NSButton * removeApplication;
  IBOutlet NSTableView * applicationTable;
  IBOutlet NSTextView * errorLog;
  IBOutlet NSPopUpButton * assignOutputPopUp;
  IBOutlet NSBox * scriptEditingBox;

  IBOutlet NSTextView * fixedCodeOutputTextView;
  IBOutlet NSTextView * testOutputTextView;
  
  IBOutlet NSProgressIndicator * progressIndicator;

  IBOutlet NSTextView * applicationCommentTextView;
  
}
@property (weak) IBOutlet NSPathControl *pathControl;
@property (strong) IBOutlet NSArrayController * outputScriptArrayController;

@property (strong) DBOutputScript *scriptForIncommingDetail; // stores the outputscript for the next incomming detail.  this is requested by the detailcontroller:newDetailWithPath

@property (strong) IBOutlet NSTextView * textView;

- (NSArray *)descendingApplicationOutputDisplay;

- (id) getEditingScript;

- (IBAction) toggleMyWindow:(id)sender;
- (IBAction) addApplication:(id)sender;
- (IBAction) removeApplication:(id)sender;
- (IBAction) addInputScript:(id)sender;
- (IBAction) removeInputScript:(id)sender;
- (IBAction) testScript:(id)sender;
- (IBAction) compileScript:(id)sender;
- (IBAction) resestOutputScripTestPath:(id)sender;
- (IBAction) addOutputScript:(id)sender;
- (IBAction) removeOutputScript:(id)sender;
- (IBAction) pathControlClicked:(id)sender;
- (IBAction) testBundleID:(id)sender;
- (IBAction) copySelectedInputScript:(id)sender;
- (IBAction) copySelectedOutputScript:(id)sender;

- (void) updateFixedCodeTestScript;
- (void) runOutputScriptForDetail: (DBDetail *) detail;
- (void) selectionDidChangeForTable:(NSTableView *)tableView;
- (void) runInputScriptForApplicationNamed:(NSString*) applicationName;
- (void) createDefaultScripts;
- (IBAction)resetDefaultScripts:(id)sender;

- (BOOL) executeCompiledScript:(NSAppleScript *) appleScript fromScriptEditor:(BOOL) fromScriptEditor;

@end
