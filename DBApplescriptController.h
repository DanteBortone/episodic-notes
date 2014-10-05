/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBObjectController.h"
//---------------------------------------------

@class DBOutputScript;
@class DBDetail;
@class DBOutputScriptPanelController;
@class DBUndoManager;

//---------------------------------------------


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
