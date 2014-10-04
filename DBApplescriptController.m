//
//  DBApplescriptController.m
//  NoteTaker
//
//  Created by Dante on 10/7/13.
//
//

//---------------------------------------------
#import "DBApplescriptController.h"
//---------------------------------------------

#import "DBApplication.h"
#import "NoteTaker_AppDelegate.h"
#import "DBDetailController.h"
#import "DBInputScript.h"
#import "DBOutputScript.h"
#import "NSMutableAttributedString_Extensions.h"
#import "NSTextView_Extensions.h"
#import "DBDetail.h"
#import "DBAliasController.h"
#import "DBFileTopic.h"
#import "DBOutputScriptPanelController.h"
#import "DBUndoManager.h"

#define OUTPUT_VALUE @"OUTPUT_VALUE"
#define FILE_PATH @"FILE_PATH"

@implementation DBApplescriptController

@synthesize scriptForIncommingDetail;
@synthesize pathControl;
@synthesize outputScriptArrayController;

@synthesize textView;

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) awakeFromNib {
  
  [super awakeFromNib];
  
  [self formatTextViews];

  
  managedObjectContext = appDelegate.managedObjectContext;
  undoManager = (DBUndoManager*)managedObjectContext.undoManager;
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void) formatTextViews
{
  
  [textView enableHorizontalScrolling];
  [textView setFont:[NSFont systemFontOfSize:11.0]];
  
  [errorLog enableHorizontalScrolling];
  [errorLog setFont:[NSFont systemFontOfSize:11.0]];

  [testOutputTextView enableHorizontalScrolling];
  [testOutputTextView setFont:[NSFont systemFontOfSize:11.0]];

  [fixedCodeOutputTextView enableHorizontalScrolling];
  [fixedCodeOutputTextView setFont:[NSFont systemFontOfSize:11.0]];

  [applicationCommentTextView enableHorizontalScrolling];
  [applicationCommentTextView setFont:[NSFont systemFontOfSize:11.0]];
  
}


#pragma mark -
#pragma mark Script related methods

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) updateFixedCodeTestScript{
  
  NSString * fixedScript = @"";
  
  if ([editingScript isKindOfClass:[DBOutputScript class]]) {

    //NSLog(@"DBApplescriptController : updateFixedCodeTestScript");
  
    NSString * filePath = [editingScript valueForKey:@"testPath"];
    NSString * outputValue = [editingScript valueForKey:@"testValue"];
  
    fixedScript = [ self generateFixedScriptWithFilePath:filePath andOutputValue:outputValue];
  
  }
  
  [self resetFixedCodeOutputTextView];
  fixedCodeOutputTextView.string = fixedScript;

}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSString *) generateFixedScriptWithFilePath:(NSString *) filePath andOutputValue:(NSString *)outputValue{
  
  if (! filePath) {
    filePath = @"";
  }
  
  filePath = [NSString stringWithFormat:@"set filePath to \"%@\"", filePath];
  
  if (! outputValue) {
    outputValue = @"";
  }
  
  outputValue = [NSString stringWithFormat:@"set output to \"%@\"", outputValue];

  return [NSString stringWithFormat:@"%@\r%@", filePath, outputValue];
  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(id) getEditingScript{
  
  return editingScript;
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void) selectionDidChangeForTable:(NSTableView *)tableView
{
  id selectedScript;
  NSArrayController * arrayController;
  
// FYI: when the application table changes selection both tables will drop their selections activating this twice
  if ([tableView.identifier isEqualToString:@"inputScriptsTable"]) {
        
    arrayController = inputScriptArrayController;

  } else if ([tableView.identifier isEqualToString:@"outputScriptsTable"]){ // must be outputScriptsTable
    
    arrayController = outputScriptArrayController;
    
  }
  
  NSArray * selectedObjects = arrayController.selectedObjects;
  
  if (selectedObjects.count > 0) {
    
    selectedScript = [selectedObjects objectAtIndex:0];
    
  } else {
    
    selectedScript = NULL;
    
  }
  
  if (selectedScript != editingScript) {
    //NSLog(@"new script to edit.");
    [self setEditingScript:selectedScript];
  
  } else {
    
    //NSLog(@"same script reselected.");

  }

  [self resetFixedCodeOutputTextView];
  [self updateFixedCodeTestScript];

}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void) setEditingScript:(id)newScript{
  
  
  editingScript = newScript;
  
  [self resetTextView];
  
  NSString * editingBoxTitle;
  
  // enable/disable popup list for output scripts
  if ([editingScript isKindOfClass:[DBInputScript class]]) {
    
    [assignOutputPopUp setEnabled:YES];

    editingBoxTitle = [NSString stringWithFormat:@"Editing input script: %@", [editingScript valueForKey:@"displayName"]];
    
  } else if ([editingScript isKindOfClass:[DBOutputScript class]]) {
  
    editingBoxTitle = [NSString stringWithFormat:@"Editing output script: %@", [editingScript valueForKey:@"displayName"]];

    [assignOutputPopUp setEnabled:NO];
  
  } else { //NULL
    
    editingBoxTitle = @"";

    [assignOutputPopUp setEnabled:NO];
    
  }

  [scriptEditingBox setTitle:editingBoxTitle];

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void) resetTextView{
  
  [textView setFont:[NSFont systemFontOfSize:11.0]];

}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void) resetFixedCodeOutputTextView{

  //NSLog(@"resetFixedCodeOutputTextView");
  [fixedCodeOutputTextView setFont:[NSFont systemFontOfSize:11.0]];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void) runOutputScriptForDetail: (DBDetail *) detail
{
  
  //NSLog(@"runOutputScriptForDetail: %@", detail.displayName);
  
  // update file path of detail
  DBFileTopic * fileTopic = detail.sourceFile;
  
  [ appDelegate.aliasController updateAliasObjectPath:fileTopic ];

  
  NSString * filePath = fileTopic.recentPath;
  
  NSString * outputValue = detail.outputValue;
  DBOutputScript * outputScript = detail.outputScript;
  
  //NSLog(@"filePath: %@", filePath);
  //NSLog(@"outputValue: %@", outputValue);
  
  if(outputScript && filePath) {
    
    NSAppleScript* appleScript = [self compileScript:outputScript withOutputValue: outputValue andFilePath:filePath fromScriptEditor:NO];
  
    if ( appleScript ){
    
      [self executeCompiledScript:appleScript fromScriptEditor:NO];

    }
  
  } else if (filePath){
        
    [appDelegate.aliasController updateAliasObjectPath:fileTopic];
    
    NSString *path = [NSString stringWithString:fileTopic.recentPath];
    
    if (path!=NULL) {
      [[NSWorkspace sharedWorkspace] openFile:path];
    }
    
  }
  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void) runInputScriptForApplicationNamed:(NSString*) applicationName
{
  //NSLog(@"runInputScriptForApplicationNamed");
  
  DBApplication * application = [self getApplicationNamed:applicationName];
  
  if (application) {
    
    //NSLog(@"found application: %@", application.displayName);
    
    DBInputScript * activeScript = [self getActiveScriptOfApplication:application];
    
    if (activeScript) {
      
      //NSLog(@"found applescript");

      NSAppleScript* appleScript = [self compileScript:activeScript withOutputValue:NULL andFilePath:NULL fromScriptEditor:NO];
      
      if ( appleScript ){
        
        //NSLog(@"applescript compiled");

        scriptForIncommingDetail = [activeScript valueForKey:@"outputScript"];

        [self executeCompiledScript:appleScript fromScriptEditor:NO];
        
      }

      
    } else {
    
    NSLog(@"No scripts selected for %@.", applicationName);
    
    }
  
  } else {
  
    NSLog(@"Couldn't find application named: %@", applicationName);
  
  }
  
  
  
 /*
  DBApplication * application = [self getApplicationNamed:applicationName];
  
  if (application) {
  
    //NSLog(@"found application: %@", application.displayName);
  
    DBInputScript * activeScript = [self getActiveScriptOfApplication:application];
    
    
    
    //replace this with run script with output value...rest with
    
    if (activeScript) {
      
      NSAppleScript* appleScript = [[NSAppleScript alloc] initWithSource:activeScript.script];
      
      NSDictionary *errorDict;
      
      
      
      if ( ![appleScript compileAndReturnError:&errorDict] ) {
        
        NSLog(@"%@:%@ generated a compile error: %@", applicationName, activeScript.displayName, errorDict);
        
      } else if ( ![appleScript executeAndReturnError:&errorDict] ) {
        
        NSLog(@"%@:%@ generated an execute error: %@", applicationName, activeScript.displayName, errorDict);
        
      }
      
    } else {
      
      NSLog(@"No scripts selected for %@.", applicationName);
      
    }
    
  } else {
    
    NSLog(@"Couldn't find application named: %@", applicationName);
  
  }
  
  //NSLog(@"%@ has no scripts associated with it.", name);
*/
  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (DBInputScript *) getActiveScriptOfApplication:(DBApplication *) application {
  
  NSSet * scripts = application.inputScripts;
  
  for (DBInputScript * script in scripts){
    
    if ([script.isActiveScript boolValue]){
      
      return script;
      
    }
    
  }
  
  return NULL;
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (DBApplication *) getApplicationNamed: (NSString *)name {
  
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSPredicate *fetchedPredicate = [NSPredicate predicateWithFormat:@"displayName == %@",name];
  
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Application" inManagedObjectContext:[appDelegate managedObjectContext]];
  
  [fetchRequest setPredicate:fetchedPredicate];
  [fetchRequest setEntity:entity];
  
  NSError *error;
  NSArray *applications = [[appDelegate managedObjectContext] executeFetchRequest:fetchRequest error:&error];
  
  if (applications.count > 0) {
    
    return [applications objectAtIndex:0];
    
  } else {
        
    return NULL;

  }
  
}

#pragma mark -
#pragma mark New object methods


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (DBInputScript *) newInputScript
{
  
  DBInputScript * newInputScript;
  
  //make new object
  newInputScript = [NSEntityDescription insertNewObjectForEntityForName:@"InputScript"
                                                 inManagedObjectContext:managedObjectContext];
  
  newInputScript.displayName = [appDelegate.detailController makeUniqueName:@"InputScript" inEntity:@"InputScript"];
  
  return newInputScript;
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (DBOutputScript *) newOutputScript
{

  DBOutputScript * newOutputScript;
  
  //make new object
  newOutputScript = [NSEntityDescription insertNewObjectForEntityForName:@"OutputScript"
                                              inManagedObjectContext:managedObjectContext];
  
  newOutputScript.displayName = [appDelegate.detailController makeUniqueName:@"OutputScript" inEntity:@"OutputScript"];
    
  return newOutputScript;
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (DBApplication *) newApplicationWithName {

  DBApplication * application;
  
  //make new object
  application = [NSEntityDescription insertNewObjectForEntityForName:@"Application"
                                                       inManagedObjectContext:managedObjectContext];
  
  application.displayName = [appDelegate.detailController makeUniqueName:@"Application" inEntity:@"Application"];
  
  DBInputScript * inputScript = [self newInputScript];
  
  inputScript.application = application;
  
  inputScript.isActiveScript = [NSNumber numberWithBool:YES];

  return application;
    
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// from http://stackoverflow.com/questions/9408293/how-do-you-get-the-bundle-identifier-from-an-applications-name-in-cocoa

- (NSString *) bundleIdentifierForApplicationName:(NSString *)appName
{
  NSWorkspace * workspace = [NSWorkspace sharedWorkspace];
  NSString * appPath = [workspace fullPathForApplication:appName];
  if (appPath) {
    NSBundle * appBundle = [NSBundle bundleWithPath:appPath];
    return [appBundle bundleIdentifier];
  }
  return nil;
}


#pragma mark -
#pragma mark Button related methods


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) removeApplication{

  
  NSArray * selectedObjects = applicationArrayController.selectedObjects;
  
  for (DBApplication * application in selectedObjects){
    
    [managedObjectContext deleteObject:application];
    
  }
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) orderOutPanel
{
  
  [myWindow orderOut:myWindow];
  
}


#pragma mark -
#pragma mark IBActions

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(IBAction)addApplication:(id)sender
{
  
  [undoManager makeUndoable];
  
  [self newApplicationWithName];
  
  [undoManager stopMakingUndoable];

}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(IBAction)removeApplication:(id)sender
{
  [undoManager makeUndoable];

  [self removeApplication];
  
  [undoManager stopMakingUndoable];

}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(IBAction)addInputScript:(id)sender
{
  
  [undoManager makeUndoable];

  DBInputScript * inputScript = [self newInputScript];
  
  inputScript.application = [applicationArrayController.selectedObjects objectAtIndex:0];
  
  [undoManager stopMakingUndoable];
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(IBAction)removeInputScript:(id)sender
{

  [undoManager makeUndoable];

  NSArray * objects = [inputScriptArrayController arrangedObjects];
  
  // Don't allow deleting all scripts for an application.
  if (objects.count > 1) {
    
    NSArray * selectedObjects = inputScriptArrayController.selectedObjects;
    
    DBInputScript * inputScript = [selectedObjects objectAtIndex:0];
    
    BOOL activeScriptDeleted = [inputScript.isActiveScript boolValue];
    
    DBApplication * application = inputScript.application;
    
    [managedObjectContext deleteObject:inputScript];
    
    [managedObjectContext processPendingChanges];
    
    if (activeScriptDeleted) {
      
      // this just selects one at random
      // should select same one that is selected after deletion once that is set up
      [[application.inputScripts anyObject] setIsActiveScript:[NSNumber numberWithBool: YES]];
      
    }
    
  }
  
  [undoManager stopMakingUndoable];

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(IBAction)addOutputScript:(id)sender
{

  [undoManager makeUndoable];

  DBOutputScript * outputScript = [self newOutputScript];
  
  outputScript.application = [applicationArrayController.selectedObjects objectAtIndex:0];
  
  [undoManager stopMakingUndoable];

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(IBAction)removeOutputScript:(id)sender
{
  [undoManager makeUndoable];

  //warn if details have this output script associated with it
  
  NSArray * selectedObjects = outputScriptArrayController.selectedObjects;
  
  
  if (selectedObjects.count > 0) {
    
    DBOutputScript * outputScript = [selectedObjects objectAtIndex:0];

    NSSet * myDetails = outputScript.details;
    
    if (myDetails.count > 0) {
      
      NSLog(@"openWindow");
      
      [outputScriptPanelController openWindow:NULL];
      
    } else {
      
      [managedObjectContext deleteObject:outputScript];
      
    }

  }
  
  [undoManager stopMakingUndoable];

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSArray *)descendingApplicationOutputDisplay;
{
  
  NSSortDescriptor *sorter = [[NSSortDescriptor alloc]
                              initWithKey:@"applicationOutputDisplay"
                              ascending:YES
                              selector:@selector(localizedCaseInsensitiveCompare:)];
  
	return [NSArray arrayWithObject:sorter];
}




// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

//  Output value should be null for
//  probably not needed anymore

-(void)runScript:(id)script withOutputValue:(NSString *)outputValue {

  //if it's as a test the test output value is used
  // and the errorDict is display in the error log
  [self commitScriptEdits];
  
  NSString * scriptString = [script valueForKey:@"script"];
  
  // if there's an output value
  if (outputValue) {
    scriptString = [scriptString stringByReplacingOccurrencesOfString:@"OUTPUT_VALUE" withString:outputValue];
  }
  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) commitScriptEdits{
  
  [ appDelegate.mainWindow makeFirstResponder:appDelegate.mainWindow];
  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(NSAppleScript *) compileScript:(id)script withOutputValue:(NSString *)outputValue andFilePath:(NSString *) filePath fromScriptEditor:(BOOL) fromScriptEditor{
  

  //NSLog(@"compileScript: fixedCode: %@", fixedCode);
  
  NSString * scriptString = [script valueForKey:@"script"];
  NSString * fixedCode = [self generateFixedScriptWithFilePath:filePath andOutputValue:outputValue];

  //NSLog(@"editing script: %@", [script className]);

  
  if ([script isKindOfClass:[DBOutputScript class]]) {
    
    scriptString = [NSString stringWithFormat:@"%@\r%@", fixedCode, scriptString];
    
  }
  
  //NSLog(@"compileScript: scriptString: %@", scriptString);

  errorLog.string = @"";
  
  NSAppleScript * appleScript = [[NSAppleScript alloc] initWithSource:scriptString];
  
  NSDictionary *errorDict;

  NSString * feedBack;

  if ( ![appleScript compileAndReturnError:&errorDict] ) {
    
    feedBack = [NSString stringWithFormat:@"The script generated a compile error: %@", errorDict];
    
    if (fromScriptEditor) {
      
      errorLog.string = feedBack;
    
    } else {
      
      //NSLog(@"%@",feedBack);
      
    }
    
    return NULL;
    
  } else {
    
    feedBack = [NSString stringWithFormat:@"The script compiled successfully."];
    
    if (fromScriptEditor) {       
      errorLog.string = feedBack;
      
      // if it compiled let's format the text like an applescript
      
      NSMutableAttributedString * scriptOutput = [[NSMutableAttributedString alloc] initWithAttributedString:[appleScript richTextSource]];
      
      [scriptOutput changeFontSize:11.0];
      
      
      // need to take attributed string apart and put fixedCode in the top and the rest in the bottom
      
      if ([script isKindOfClass:[DBOutputScript class]]) {
        
        NSRange fixedScriptRange = NSMakeRange(0, fixedCode.length+1);//plus one to get rid of newline
        
        NSAttributedString * fixedOutput = [scriptOutput attributedSubstringFromRange:fixedScriptRange];

        [fixedCodeOutputTextView.textStorage setAttributedString: fixedOutput];
        
        [scriptOutput deleteCharactersInRange:fixedScriptRange];

      }

      [textView.textStorage setAttributedString: scriptOutput];
      
    } else {
      
      //NSLog(@"%@",feedBack);
      
    }
          
    return appleScript;
    
  }

}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(BOOL) executeCompiledScript:(NSAppleScript *) appleScript fromScriptEditor:(BOOL) fromScriptEditor
{
  
  if ([appleScript isCompiled]) {
    
    NSDictionary *errorDict;
    NSString * feedBack;
    
    if ([appleScript executeAndReturnError:&errorDict] ) {
      
      feedBack = @"Script excuted without errors.";
      
      return YES;

    } else {
      
      feedBack = [NSString stringWithFormat:@"Script generated an execute error: %@", errorDict];
      
      return NO;
    
    }
    
    if (fromScriptEditor) {
      
      errorLog.string = feedBack;
      
    } else {
      
      NSLog(@"%@",feedBack);
      
    }
    
    
  } else {
    
    NSLog(@"Uncompiled appleScript sent to DBAppleScriptController : executeCompiledScript.");

    return NO;
    
  }
  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------


-(IBAction)testScript:(id)sender
{
  //DBInputScript * inputScript = [inputScriptArrayController.selectedObjects objectAtIndex:0];
  
  [progressIndicator startAnimation:NULL];
  
  [self commitScriptEdits];

  if (editingScript) {
    
    NSString * outputValue;
    NSString *filePath;
    
    if ([editingScript isKindOfClass:[DBOutputScript class]]) {
      
      outputValue = [editingScript valueForKey:@"testValue"];
      filePath = [editingScript valueForKey:@"testPath"];
      
    } else {  // must be an input script
      
      // set outputScript so detailController can get it when the applescript comes in
      scriptForIncommingDetail = [editingScript valueForKey:@"outputScript"];
      
    }
    
    NSAppleScript* appleScript = [self compileScript:editingScript withOutputValue:outputValue andFilePath:filePath fromScriptEditor:YES];
    
    if (appleScript) {
      
      [self executeCompiledScript:appleScript fromScriptEditor:YES];
   
    }
    
  }
  
  [progressIndicator stopAnimation:NULL];

}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (IBAction)toggleMyWindow:(id)sender{
  
  if ([myWindow isVisible]){
    
    [self orderOutPanel];
    
  } else {
    
    [myWindow makeKeyAndOrderFront:myWindow];
    
  }
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(IBAction)compileScript:(id)sender{
  
  [progressIndicator startAnimation:NULL];

  [self commitScriptEdits];
  
  if (editingScript) {
  
    NSString * outputValue;
    NSString * filePath;
    
    if ([editingScript isKindOfClass:[DBOutputScript class]]) {
      
      outputValue = [editingScript valueForKey:@"testValue"];
      filePath = [editingScript valueForKey:@"testPath"];

    }
    
    [self compileScript:editingScript withOutputValue:outputValue andFilePath:filePath fromScriptEditor:YES];
    
  }

  [progressIndicator stopAnimation:NULL];

}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(IBAction)resestOutputScripTestPath:(id)sender
{
  
  NSArray * selectedObjects = outputScriptArrayController.selectedObjects;
  
  if (selectedObjects.count > 0) {
    
    DBOutputScript *selectedScript = [selectedObjects objectAtIndex:0];
    
    [selectedScript setTestPath:NULL];
    
  }
  
  [self updateFixedCodeTestScript];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------
// used for both the "choose..." option as well as selecting the path from the dropdown list

-(IBAction) pathControlClicked:(id)sender {
  
  //NSLog(@"pathControlClicked 2");
  
  NSPathControl* pathCntl = (NSPathControl *)sender;
  
  NSPathComponentCell *component = [pathCntl clickedPathComponentCell];   // find the path component selected
  [pathCntl setURL:[component URL]]; // set the url to the path control
  
  NSString * newPath = [[component URL] path];

  DBOutputScript * outputScript = [[outputScriptArrayController selectedObjects] objectAtIndex:0];

  // to prevent double selection for when selection is made through "choose..."
  if (outputScript.testPath != newPath){
    
    [outputScript setTestPath:newPath];

    [self updateFixedCodeTestScript];
  }
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (IBAction) testBundleID:(id)sender {
  
  DBApplication * application = [[applicationArrayController selectedObjects] objectAtIndex:0];
  
  NSString *bundleID = [self bundleIdentifierForApplicationName:application.displayName];
  
  NSLog(@"%@ bundleID: %@", application.displayName, bundleID);
  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) createDefaultScripts{
  
  NSNumber * versionNumber = [[NSUserDefaults standardUserDefaults] valueForKey:@"applescriptVersion"];
  
  float version = [versionNumber floatValue];
  
  NSLog(@"Loading script version: %f", version);
  
  [self setupExcelScripts];
  [self setupFinderScript];
  [self setupGoogleChromeScripts];
  [self setupIPhotoScripts];
  [self setupITunesScripts];
  [self setupMailScripts];
  [self setupPreviewScripts];
  [self setupPowerPointScripts];
  [self setupSafariScripts];
  [self setupSkimScripts];
  [self setupWordScripts];
  
  [appDelegate save];

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(IBAction)resetDefaultScripts:(id)sender{
  
  NSLog(@"resetting scripts");
  [inputScriptArrayController setSelectedObjects:NULL];
  [outputScriptArrayController setSelectedObjects:NULL];
  [self createDefaultScripts];

}




// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// looks for application with name.  If none exists, one is made.

-(DBApplication *)applicationWithName:(NSString *)name{
  
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:[NSEntityDescription entityForName:@"Application" inManagedObjectContext:appDelegate.managedObjectContext]];
  NSPredicate *fetchPredicate = [NSPredicate predicateWithFormat:@"displayName == %@",name];
  
  [fetchRequest setPredicate:fetchPredicate];
  [fetchRequest setFetchLimit:1];
  
  NSError *error = nil;
  NSArray *activeFileTopics = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
  
  if (activeFileTopics.count > 0) {
    //application already exists
    return [activeFileTopics objectAtIndex:0];
  
  } else {
  
    DBApplication *application = [NSEntityDescription insertNewObjectForEntityForName:@"Application"
                                                               inManagedObjectContext:managedObjectContext];;
    application.displayName = name;
    return application;
  
  }
  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// looks for input script with scriptName.  If none exists it makes one.

-(DBInputScript *) inputScriptNamed:(NSString * ) scriptName forApplication:(DBApplication *)application{
  
  
  for (DBInputScript * inputScript in application.inputScripts) {
    if ([inputScript.displayName isEqualToString:scriptName]) {
      return inputScript;
    }
  }
  
  DBInputScript * newScript = [NSEntityDescription insertNewObjectForEntityForName:@"InputScript"
                                                            inManagedObjectContext:managedObjectContext];
  newScript.displayName = scriptName;

  newScript.application = application;

  return newScript;

}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// looks for output script with scriptName.  If none exists it makes one.

-(DBOutputScript *) outputScriptNamed:(NSString * ) scriptName forApplication:(DBApplication *)application{
  
  
  for (DBOutputScript * outputScript in application.outputScripts) {
    if ([outputScript.displayName isEqualToString:scriptName]) {
      return outputScript;
    }
  }
  
  DBOutputScript * newScript = [NSEntityDescription insertNewObjectForEntityForName:@"OutputScript"
                                                            inManagedObjectContext:managedObjectContext];
  newScript.displayName = scriptName;
  
  newScript.application = application;

  return newScript;
  
}




// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------
// should only be enabled if a selection is made
- (IBAction) copySelectedInputScript:(id)sender
{
  
  [undoManager makeUndoable];

  DBInputScript * scriptToCopy = [inputScriptArrayController.selectedObjects objectAtIndex:0];
  DBInputScript * copyOfScript = [NSEntityDescription insertNewObjectForEntityForName:@"InputScript"
                                                 inManagedObjectContext:managedObjectContext];
  
  copyOfScript.displayName = [appDelegate.detailController makeUniqueName:scriptToCopy.displayName inEntity:@"InputScript"];
  
  copyOfScript.application = scriptToCopy.application;
  copyOfScript.script = scriptToCopy.script;
  copyOfScript.application = scriptToCopy.application;
  copyOfScript.outputScript = scriptToCopy.outputScript;
  
  [undoManager stopMakingUndoable];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------
// should only be enabled if a selection is made

- (IBAction) copySelectedOutputScript:(id)sender
{
  
  [undoManager makeUndoable];

  DBOutputScript * scriptToCopy = [outputScriptArrayController.selectedObjects objectAtIndex:0];
  DBOutputScript * copyOfScript = [NSEntityDescription insertNewObjectForEntityForName:@"OutputScript"
                                                               inManagedObjectContext:managedObjectContext];
  
  copyOfScript.displayName = [appDelegate.detailController makeUniqueName:scriptToCopy.displayName inEntity:@"OutputScript"];
  
  copyOfScript.application = scriptToCopy.application;
  copyOfScript.script = scriptToCopy.script;
  copyOfScript.application = scriptToCopy.application;
  copyOfScript.testValue = scriptToCopy.testValue;
  copyOfScript.testPath = scriptToCopy.testPath;

  [undoManager stopMakingUndoable];

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void) setupExcelScripts{
  DBApplication *application = [self applicationWithName:@"Excel"];
  
  DBInputScript * inputScript = [self inputScriptNamed:@"Default Input" forApplication:application];
  
  inputScript.isEditable = [NSNumber numberWithBool:NO];

  inputScript.isActiveScript = [NSNumber numberWithBool:YES];

  inputScript.script = [NSString stringWithFormat:
                        @"set filePath to \"\" -- POSIX or Mac HFS\n"
                        "set selText to \"\" -- value of active cell\n"
                        "set output to \"\" -- { sheetName, rowNum, colNum }\n"
                        "set wantImage to true -- \n"
                        "set detailName to \"\" -- let notetaker handle this\n"
                        "\n"
                        "set chartDescriptor to \"Graph\"\n"
                        "\n"
                        "set noChartName to true\n"
                        "\n"
                        "tell application \"Microsoft Excel\"\n"
                        "\n"
                        "set allWindows to every window\n"
                        "\n"
                        "set windowNum to count of allWindows\n"
                        "\n"
                        "set shouldContinue to (windowNum > 0)\n"
                        "if (shouldContinue) then\n"
                        "\n"
                        "-- long way to get workbook/worksheet but won't get confused if you switch workbooks/worksheets in middle of script\n"
                        "set theBook to workbook (get name of active workbook)\n"
                        "set activeSheet to worksheet (get name of active sheet) of theBook\n"
                        "\n"
                        "set activeCell to active cell\n"
                        "\n"
                        "set outputRow to first row index of activeCell\n"
                        "set outputCol to first column index of activeCell\n"
                        "set selText to string value of activeCell\n"
                        "\n"
                        "set chartShortName to \"\"\n"
                        "\n"
                        "--try getting a chart\n"
                        "if (wantImage) then\n"
                        "set chartPresent to false\n"
                        "set activeChart to null\n"
                        "try\n"
                        "set activeChart to active chart\n"
                        "-- chart object has the name format of chart x\n"
                        "-- chart has the name format of sheet x chart x\n"
                        "-- can't get from chart back to chart object\n"
                        "-- either store long name or trim it down\n"
                        "\n"
                        "set chartLongName to name of activeChart as string\n"
                        "set sheetName to name of activeSheet as string\n"
                        "set startChartName to (length of sheetName) + 2\n"
                        "\n"
                        "set chartShortName to (characters startChartName thru end of chartLongName) as string\n"
                        "\n"
                        "copy object chart area object of activeChart\n"
                        "-- could also try \"copy chart as picture\"\n"
                        "set chartPresent to true\n"
                        "on error errMsg\n"
                        "\n"
                        "set wantImage to false\n"
                        "--display dialog \"ERROR: \" & errMsg\n"
                        "end try\n"
                        "\n"
                        "if chartPresent then\n"
                        "try\n"
                        "-- this needs to go in its own 'try' so that 'copy' is done even if there is no title\n"
                        "set chartTitle to chart title of activeChart\n"
                        "set chartTitleText to caption of chartTitle as string\n"
                        "set detailName to chartDescriptor & \": \" & chartTitleText\n"
                        "on error errMsg\n"
                        "set detailName to chartDescriptor\n"
                        "--display dialog \"ERROR: \" & errMsg\n"
                        "end try\n"
                        "\n"
                        "end if\n"
                        "\n"
                        "end if\n"
                        "\n"
                        "set macPath to the full name of theBook\n"
                        "\n"
                        "set filePath to macPath\n"
                        "\n"
                        "if chartShortName is equal to \"\" then\n"
                        "set output to name of activeSheet & \", \" & outputRow & \", \" & outputCol\n"
                        "else\n"
                        "set output to name of activeSheet & \", \" & outputRow & \", \" & outputCol & \", \" & chartShortName\n"
                        "end if\n"
                        "\n"
                        "end if\n"
                        "\n"
                        "end tell\n"
                        "\n"
                        "tell application \"Episodic Notes\"\n"
                        "getFilePath filePath CopiedText selText OutputValue output Clipboard wantImage Title detailName with args\n"
                        "end tell\n"];
  
  DBOutputScript * outputScript =  [self outputScriptNamed:@"Default Output" forApplication:application];
  outputScript.isEditable = [NSNumber numberWithBool:NO];

  inputScript.outputScript = outputScript;
  
  outputScript.script = [NSString stringWithFormat:
                         @"set maxSlots to 4\n"
                         "\n"
                         "set myArray to my theSplit(output, \", \", maxSlots)\n"
                         "\n"
                         "set sheetName to item 1 of myArray as string\n"
                         "set rowNum to item 2 of myArray as integer\n"
                         "set colNum to item 3 of myArray as integer\n"
                         "set chartToSelect to item 4 of myArray as string\n"
                         "\n"
                         "tell application \"Microsoft Excel\"\n"
                         "\n"
                         "-- don't want to try to open a window that is already open \n"
                         "-- or it'll bug the user about reverting to saved version\n"
                         "-- so let's first check if our file is already open\n"
                         "-- and activate it\n"
                         "\n"
                         "set allWindows to every window\n"
                         "set windowNum to count of allWindows\n"
                         "set alreadyOpen to false\n"
                         "repeat with i from 1 to windowNum\n"
                         "set anOpenWindow to item i of allWindows\n"
                         "set anOpenWorkBook to workbook (name of anOpenWindow)\n"
                         "--set hfsPath to the full name of openWorkBook\n"
                         "set posixPath to the full name of anOpenWorkBook as POSIX file\n"
                         "if (posixPath as string) ends with filePath then\n"
                         "activate object anOpenWorkBook\n"
                         "set alreadyOpen to true\n"
                         "exit repeat\n"
                         "end if\n"
                         "end repeat\n"
                         "\n"
                         "if not alreadyOpen then\n"
                         "open filePath\n"
                         "end if\n"
                         "\n"
                         "set theWorksheet to worksheet sheetName\n"
                         "activate object theWorksheet\n"
                         "\n"
                         "-- to activate the chart that was selected the closest thing to a unique ID is the chart name\n"
                         "\n"
                         "set foundChart to false\n"
                         "\n"
                         "if chartToSelect is not equal to \"-1\" then\n"
                         "set allCharts to chart objects of theWorksheet\n"
                         "set chartNum to count of allCharts\n"
                         "\n"
                         "repeat with i from 1 to chartNum\n"
                         "set thisChart to item i of allCharts -- a chart object\n"
                         "--log class of thisChart as string\n"
                         "\n"
                         "set chartName to name of thisChart as string\n"
                         "if chartName is equal to chartToSelect then\n"
                         "\n"
                         "-- next tow lines make sure the entire chart is visible\n"
                         "select (top left cell of thisChart) -- this scrolls to the chart if it's not visible\n"
                         "select (bottom right cell of thisChart) -- this scrolls to the chart if it's not visible\n"
                         "\n"
                         "select (thisChart)\n"
                         "\n"
                         "-- next two lines are needed to visibly highlight the chart\n"
                         "set activeCell to active cell\n"
                         "set outputRow to first row index of active cell\n"
                         "\n"
                         "set foundChart to true\n"
                         "\n"
                         "exit repeat\n"
                         "\n"
                         "end if\n"
                         "\n"
                         "\n"
                         "end repeat\n"
                         "end if\n"
                         "\n"
                         "if not foundChart then\n"
                         "select (cell colNum of row rowNum of active sheet)\n"
                         "end if\n"
                         "\n"
                         "activate -- needed to make application active\n"
                         "\n"
                         "\n"
                         "end tell\n"
                         "\n"
                         "on theSplit(theString, theDelimiter, slotNum)\n"
                         "-- save delimiters to restore old settings\n"
                         "set oldDelimiters to AppleScript's text item delimiters\n"
                         "-- set delimiters to delimiter to be used\n"
                         "set AppleScript's text item delimiters to theDelimiter\n"
                         "-- create the array\n"
                         "set theArray to every text item of theString\n"
                         "-- restore the old setting\n"
                         "set AppleScript's text item delimiters to oldDelimiters\n"
                         "\n"
                         "-- Fill in array to slotNum\n"
                         "set listSize to count of theArray\n"
                         "repeat with i from (listSize + 1) to slotNum -- we need\n"
                         "set the end of theArray to -1\n"
                         "end repeat\n"
                         "\n"
                         "-- return the result\n"
                         "return theArray\n"
                         "end theSplit\n"];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void) setupFinderScript{

  
  DBApplication *application = [self applicationWithName:@"Finder"];
  
  DBInputScript * inputScript = [self inputScriptNamed:@"Default Input" forApplication:application];
  
  inputScript.isEditable = [NSNumber numberWithBool:NO];

  inputScript.isActiveScript = [NSNumber numberWithBool:YES];

  inputScript.script = [NSString stringWithFormat:
                        @"--init output variables--\n"
                        //"--TEST WORKED!!\n"
                        "set filePath to null -- POSIX or HFS path\n"
                        "set selText to \"\" -- not needed\n"
                        "set output to \"\" -- not needed\n"
                        "set wantImage to false -- not needed \n"
                        "set detailName to \"\" -- let notetaker handle this\n"
                        "\n"
                        "tell application \"Finder\"\n"
                        "   set sel to the selection as text\n"
                        "   set filePath to POSIX path of sel\n"
                        "end tell\n"
                        "\n"
                        "if (filePath is not null) then\n"
                        "   tell application \"Episodic Notes\"\n"
                        "       getFilePath filePath CopiedText selText OutputValue output Clipboard wantImage Title detailName with args\n"
                        "   end tell\n"
                        "end if\n"];

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void) setupGoogleChromeScripts{
  
  DBApplication *application = [self applicationWithName:@"Chrome"];
  
  DBInputScript * inputScript = [self inputScriptNamed:@"Default Input" forApplication:application];
  
  inputScript.isEditable = [NSNumber numberWithBool:NO];
  
  inputScript.isActiveScript = [NSNumber numberWithBool:YES];
  
  inputScript.script = [NSString stringWithFormat:
                        @"set wantImage to false \n"
                        @"set filePath to \"\"\n"
                        @"set selText to \"\"\n"
                        @"set outputURL to \"\"\n"
                        @"set detailName to \"\" \n"
                        @"\n"
                        @"-- chrome doesn't support much but we can get the url\n"
                        @"set filePath to POSIX path of (path to application \"Google Chrome\")\n"
                        @"\n"
                        @"tell application \"Google Chrome\"\n"
                        @"\n"
                        @"--set theTab to active tab of front window\n"
                        @"set outputURL to URL of active tab of front window\n"
                        @"\n"
                        @"end tell\n"
                        @"\n"
                        @"set detailName to outputURL\n"
                        @"\n"
                        @"tell application \"Episodic Notes\"\n"
                        @"getFilePath filePath CopiedText selText OutputValue outputURL Clipboard wantImage Title detailName with args\n"
                        @"end tell\n"];
  
  DBOutputScript * outputScript =  [self outputScriptNamed:@"Default Output" forApplication:application];
  outputScript.isEditable = [NSNumber numberWithBool:NO];
  
  inputScript.outputScript = outputScript;
  
  outputScript.script = [NSString stringWithFormat:
                         @"tell application \"Google Chrome\"\n"
                         "activate\n"
                         "if (count every window) = 0 then\n"
                         "make new window\n"
                         "end if\n"
                         "\n"
                         "tell window 1 to make new tab with properties {URL:output}\n"
                         "\n"
                         "end tell\n"];
  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) setupIPhotoScripts{
  DBApplication *application = [self applicationWithName:@"iPhoto"];
  
  DBInputScript * inputScript = [self inputScriptNamed:@"Default Input" forApplication:application];
  
  inputScript.isEditable = [NSNumber numberWithBool:NO];

  inputScript.isActiveScript = [NSNumber numberWithBool:YES];

  inputScript.script = [NSString stringWithFormat:
                        @"set wantImage to true -- our preference over whether to include the image\n"
                        //"--TEST WORKED!!\n"
                        "set filePath to \"\" --\n"
                        "set selText to \"\" --\n"
                        "set output to \"\" --\n"
                        "set detailName to \"\"\n"
                        "set clipboardImagePath to \"\"\n"
                        "\n"
                        "set filePath to POSIX path of (path to application \"iPhoto\")\n"
                        "\n"
                        "tell application \"iPhoto\"\n"
                        "   set selectedPhotos to the selection\n"
                        "   set theFirstPhoto to item 1 of selectedPhotos\n"
                        "   set detailName to the image filename of theFirstPhoto\n"
                        "   set output to the id of theFirstPhoto\n"
                        "   set selText to the comment of theFirstPhoto\n"
                        "\n"
                        "   set clipboardImagePath to the preview path of theFirstPhoto\n"
                        "\n"
                        "end tell\n"
                        "\n"
                        "if wantImage then\n"
                        "\n"
                        "   tell application \"Finder\"\n"
                        "\n"
                        "       set the clipboard to clipboardImagePath\n"
                        "       --Episodic will see this is text and try to interprete it as a path to get the image\n"
                        "\n"
                        "   end tell\n"
                        "end if\n"
                        "\n"
                        "\n"
                        "tell application \"Episodic Notes\"\n"
                        "   getFilePath filePath CopiedText selText OutputValue output Clipboard wantImage Title detailName with args\n"
                        "end   tell\n"];
  
  DBOutputScript * outputScript =  [self outputScriptNamed:@"Default Output" forApplication:application];
  
  inputScript.outputScript = outputScript;
  
  outputScript.isEditable = [NSNumber numberWithBool:NO];

  outputScript.script = [NSString stringWithFormat:
                         @"set photoID to output as integer\n"
                         "\n"
                         "tell application \"iPhoto\"\n"
                         "   activate\n"
                         "   select photo id photoID\n"
                         "\n"
                         "end tell\n"];
  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) setupITunesScripts{
  
  DBApplication *application = [self applicationWithName:@"iTunes"];
  
  DBInputScript * inputScript = [self inputScriptNamed:@"Default Input" forApplication:application];
  
  inputScript.isEditable = [NSNumber numberWithBool:NO];

  inputScript.isActiveScript = [NSNumber numberWithBool:YES];

  inputScript.script = [NSString stringWithFormat:
                        @"set wantImage to false -- not setup to get artwork at this time\n"
                        "set filePath to \"\" --\n"
                        "set selText to \"\" --\n"
                        "set output to \"\" -- {database ID, time}\n"
                        "set detailName to \"\"\n"
                        "set clipboardImagePath to \"\"\n"
                        "\n"
                        "set dataBaseID to \"\"\n"
                        "set trackTime to \"\"\n"
                        "\n"
                        "\n"
                        "set filePath to POSIX path of (path to application \"iTunes\")\n"
                        "\n"
                        "tell application \"iTunes\"\n"
                        "\n"
                        "   pause\n"
                        "\n"
                        "   set currentTrack to current track\n"
                        "\n"
                        "\n"
                        "   set albumName to album of currentTrack\n"
                        "   set trackName to name of currentTrack\n"
                        "\n"
                        "   if albumName is equal to \"\" then\n"
                        "       set detailName to trackName\n"
                        "   else\n"
                        "       set detailName to (albumName & \" : \" & trackName)\n"
                        "   end if\n"
                        "\n"
                        "   set selText to lyrics of currentTrack\n"
                        "\n"
                        "   -- put together output value\n"
                        "   set persistentID to persistent ID of current track\n"
                        "   set trackTime to player position\n"
                        "\n"
                        "   set output to ((persistentID as string) & \", \" & trackTime)\n"
                        "\n"
                        "end tell\n"
                        "\n"
                        "tell application \"Episodic Notes\"\n"
                        "   getFilePath filePath CopiedText selText OutputValue output Clipboard wantImage Title detailName with args\n"
                        "   activate\n"
                        "end tell\n"];
  
  DBOutputScript * outputScript =  [self outputScriptNamed:@"Default Output" forApplication:application];

  outputScript.isEditable = [NSNumber numberWithBool:NO];

  inputScript.outputScript = outputScript;

  outputScript.script = [NSString stringWithFormat:
                         @"set startAheadBy to 1 -- starts the selection ahead of marked point by X seconds\n"
                         "\n"
                         "-- break apart output data into databaseID and start time\n"
                         "set validOutput to false\n"
                         "set aBlankString to \"\"\n"
                         "if output = aBlankString then\n"
                         "    -- so it won't choke on a blank string\n"
                         "    set output to \"-1, -1\"\n"
                         "end if\n"
                         "set validOutput to true\n"
                         "set myArray to my theSplit(output, \", \")\n"
                         "on theSplit(theString, theDelimiter)\n"
                         "    -- save delimiters to restore old settings\n"
                         "    set oldDelimiters to AppleScript's text item delimiters\n"
                         "    -- set delimiters to delimiter to be used\n"
                         "    set AppleScript's text item delimiters to theDelimiter\n"
                         "    -- create the array\n"
                         "    set theArray to every text item of theString\n"
                         "    -- restore the old setting\n"
                         "    set AppleScript's text item delimiters to oldDelimiters\n"
                         "    -- return the result\n"
                         "    return theArray\n"
                         "end theSplit\n"
                         "\n"
                         "set persistentID to item 1 of myArray as string\n"
                         "set trackTime to item 2 of myArray as integer\n"
                         "\n"
                         "\n"
                         "tell application \"iTunes\"\n"
                         "\n"
                         "    --if databaseID > -1 then\n"
                         "    set myTrack to first track whose persistent ID is persistentID\n"
                         "    play myTrack\n"
                         "    set player position to (trackTime - startAheadBy)\n"
                         "    --end if\n"
                         "\n"
                         "    activate\n"
                         "\n"
                         "end tell\n"
                         "tell application \"Episodic Notes\"\n"
                         "    getFilePath filePath CopiedText selText OutputValue output Clipboard wantImage Title detailName with args\n"
                         "    activate\n"
                         "end tell\n"];
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) setupMailScripts{
  
  DBApplication *application = [self applicationWithName:@"Mail"];
  
  DBInputScript * inputScript = [self inputScriptNamed:@"Default Input" forApplication:application];
  
  inputScript.isEditable = [NSNumber numberWithBool:NO];
  
  inputScript.isActiveScript = [NSNumber numberWithBool:YES];
  
  inputScript.script = [NSString stringWithFormat:
                        
                        @"--init output variables--\n"
                        "set wantImage to false -- can't get image at this time\n"
                        "set filePath to \"\"\n"
                        "set selText to \"\"\n"
                        "set output to \"\"\n"
                        "set detailName to \"\"\n"
                        "\n"
                        "set filePath to POSIX path of (path to application \"Mail\")\n"
                        "\n"
                        "tell application \"Mail\"\n"
                        "\n"
                        "set proceed to false\n"
                        "\n"
                        "if (count of message viewers) > 0 then\n"
                        "set proceed to true\n"

                        "\n"
                        "-- this gets the first message selected in the main window\n"
                        "set theMessageViewer to first message viewer\n"
                        "set selMessages to selected messages of theMessageViewer\n"
                        "set theMessage to item 1 of selMessages\n"
                        "set output to the message id of theMessage\n"
                        "set detailName to sender of theMessage & \": \" & subject of theMessage\n"
                        "\n"
                        "else\n"
                        "display dialog \" Please select message in viewer.  This script cannot access emails in individual windows.\"\n"
                        "\n"
                        "end if\n"
                        "end tell\n"
                        "\n"
                        "if proceed then\n"
                        "tell application \"Episodic Notes\"\n"
                        "getFilePath filePath CopiedText selText OutputValue output Clipboard wantImage Title detailName with args\n"
                        "end tell\n"
                        "end if\n"];
  
  DBOutputScript * outputScript =  [self outputScriptNamed:@"Default Output" forApplication:application];
  
  outputScript.isEditable = [NSNumber numberWithBool:NO];
  
  inputScript.outputScript = outputScript;
  
  outputScript.script = [NSString stringWithFormat:
                         @"set openMessage to \"message:%%3c\" & output & \"%%3e\"\n"
                         "\n"
                         "tell application \"Mail\"\n"
                         "open location openMessage\n"
                         "activate\n"
                         "end tell\n"];
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) setupPreviewScripts{
  
  DBApplication *application = [self applicationWithName:@"Preview"];
  
  DBInputScript * inputScript = [self inputScriptNamed:@"Default Input" forApplication:application];
  
  inputScript.isEditable = [NSNumber numberWithBool:NO];
  
  inputScript.isActiveScript = [NSNumber numberWithBool:YES];
  
  inputScript.script = [NSString stringWithFormat:
                        
                        @"set wantImage to false -- can't get image at this time\n"
                        "set filePath to \"\"\n"
                        "set selText to \"\"\n"
                        "set output to \"\"\n"
                        "set detailName to \"\"\n"
                        "\n"
                        "tell application \"System Events\"\n"
                        "tell process \"Preview\"\n"
                        "set rawPath to value of attribute \"AXDocument\" of window 1\n"
                        "\n"
                        "-- need to get rid of file:// in front of the path which we don't want \n"
                        "set filePath to text 8 thru end of rawPath\n"
                        "\n"
                        "end tell\n"
                        "end tell\n"
                        "\n"
                        "tell application \"Episodic Notes\"\n"
                        "getFilePath filePath CopiedText selText OutputValue output Clipboard wantImage Title detailName with arg\n"
                        "end tell\n"];
  
  
  // no output script.  Preview doesn't support much so let's just let finder open it.
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) setupPowerPointScripts{
  
  DBApplication *application = [self applicationWithName:@"PowerPoint"];
  
  DBInputScript * inputScript = [self inputScriptNamed:@"Default Input" forApplication:application];

  inputScript.isEditable = [NSNumber numberWithBool:NO];

  inputScript.isActiveScript = [NSNumber numberWithBool:YES];

  inputScript.script = [NSString stringWithFormat:
                        @"set wantImage to true -- \n"
                        //"--TEST WORKED!!\n"

                        "set filePath to \"\" --\n"
                        "set selText to \"\" --\n"
                        "set output to \"\" -- { page number }\n"
                        "set detailName to \"\"\n"
                        "--set clipboardImagePath to \"\"\n"
                        "\n"
                        "tell application \"Microsoft PowerPoint\"\n"
                        "\n"
                        "   set theActiveDoc to the active presentation\n"
                        "   set filePath to the full name of theActiveDoc\n"
                        "   set detailName to the name of theActiveDoc\n"
                        "\n"
                        "   set thePageNumber to slide index of slide range of selection of document window 1\n"
                        "   set output to thePageNumber as string\n"
                        "\n"
                        "   set theSlides to the slides of theActiveDoc\n"
                        "   copy object item thePageNumber of theSlides\n"
                        "\n"
                        "end tell\n"
                        "\n"
                        "tell application \"Episodic Notes\"\n"
                        "   getFilePath filePath CopiedText selText OutputValue output Clipboard wantImage Title detailName with args\n"
                        "end tell\n"];
  
  DBOutputScript * outputScript =  [self outputScriptNamed:@"Default Output" forApplication:application];
  
  outputScript.isEditable = [NSNumber numberWithBool:NO];

  inputScript.outputScript = outputScript;
  
  outputScript.script = [NSString stringWithFormat:
                         @"set pageNum to output as integer\n"
                         "\n"
                         "tell application \"Microsoft PowerPoint\"\n"
                         "\n"
                         "-- don't want to try to open if it's already open\n"
                         "set allWindows to document windows\n"
                         "set windowNum to count of allWindows\n"
                         "--log windowNum\n"
                         "set alreadyOpen to false\n"
                         "repeat with i from 1 to windowNum\n"
                         "set anOpenWindow to item i of allWindows\n"
                         "set anOpenPresentation to presentation of anOpenWindow\n"
                         "set posixPath to the full name of anOpenPresentation as POSIX file\n"
                         "if (posixPath as string) ends with filePath then\n"
                         "select (anOpenWindow)\n"
                         "set alreadyOpen to true\n"
                         "exit repeat\n"
                         "end if\n"
                         "end repeat\n"
                         "\n"
                         "if not alreadyOpen then\n"
                         "open filePath\n"
                         "end if\n"
                         "\n"
                         "set theView to view of document window 1\n"
                         "go to slide theView number pageNum\n"
                         "\n"
                         "activate\n"
                         "\n"
                         "end tell\n"];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void) setupSafariScripts{
  
  DBApplication *application = [self applicationWithName:@"Safari"];
  
  DBInputScript * inputScript = [self inputScriptNamed:@"Default Input" forApplication:application];
  
  inputScript.isEditable = [NSNumber numberWithBool:NO];

  inputScript.isActiveScript = [NSNumber numberWithBool:YES];

  inputScript.script = [NSString stringWithFormat:
                        @"--init variables--\n"
                        //"--TEST WORKED!!\n"

                        "set wantImage to false -- will have to set up gui to make this happen\n"
                        "set filePath to \"\"\n"
                        "set selText to \"\"\n"
                        "set outputURL to \"\"\n"
                        "set detailName to \"\" -- let notetaker handle this\n"
                        
                        "set filePath to POSIX path of (path to application \"Safari\")\n"
                        
                        "tell application \"Safari\"\n"
                        "  set outputURL to URL of front document\n"
                        "  set selText to (do JavaScript \"(''+getSelection())\" in document 1)\n"
                        "end tell\n"
                        
                        "-- notetaker default is to use the selected text if no title\n"
                        "-- if there is no selected text the file name is used\n"
                        "-- since a browser won't have a helpful file name,\n"
                        "-- we'll want the title to be the url\n"
                        
                        "if selText as string is equal to \"\" then\n"
                        "  set detailName to outputURL\n"
                        "end if\n"
                        
                        
                        "tell application \"Episodic Notes\"\n"
                        "  getFilePath filePath CopiedText selText OutputValue outputURL Clipboard wantImage Title detailName with args\n"
                        "end tell"];
  
  DBOutputScript * outputScript =  [self outputScriptNamed:@"Default Output" forApplication:application];
  
  outputScript.isEditable = [NSNumber numberWithBool:NO];

  inputScript.outputScript = outputScript;
  
  outputScript.script = [NSString stringWithFormat:
                         
                         @"tell application \"Safari\"\n"
                         //"--TEST WORKED!!\n"

                         "  activate\n"
                         "  open location output\n"
                         "end tell"];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) setupSkimScripts{
  
  DBApplication *application = [self applicationWithName:@"Skim"];
  
  DBInputScript * inputScript = [self inputScriptNamed:@"Default Input" forApplication:application];
  
  inputScript.isEditable = [NSNumber numberWithBool:NO];

  inputScript.isActiveScript = [NSNumber numberWithBool:YES];

  inputScript.script = [NSString stringWithFormat:
                        
                        @"-- output will have 3 formats:\n"
                        "--   if output has one item  \"thePage\"\n"
                        "--   if output has three items \"thePage, startSelection, stopSelection\"\n"
                        "--   if output has five items  \"thePage, left bound, top bound, right bound, bottom boun\"\n"
                        "\n"
                        "-- Background:\n"
                        "-- there can be three basic types of selections that should cover everything the user would want to copy\n"
                        "--   a bounds selection for an image\n"
                        "--   a note: text note, ‌anchored note, ‌circle note, box note, ‌highlight note,\n"
                        "-- ‌  underline note, ‌strike out note, ‌line note, ‌freehand note a text selection\n"
                        "\n"
                        "--init output variables--\n"
                        "set wantImage to true -- our preference over whether to include the image\n"
                        "set filePath to \"\" --\n"
                        "set selText to \"\" --\n"
                        "set output to \"\" --\n"
                        "set detailName to \"\" -- let notetaker handle this\n"
                        "\n"
                        "set highlightText to true\n"
                        "set unknownSelectionType to true\n"
                        "set startSelection to 0\n"
                        "set stopSelection to 0\n"
                        "set thePage to 0\n"
                        "\n"
                        "set imageSelected to false -- script's determination of an existing image\n"
                        "tell application \"Skim\"\n"
                        "if the front document exists then\n"
                        "tell the front document\n"
                        "\n"
                        "-- \"bounds select tool\" for selection of an image will deselect a text selection or a highlight selection\n"
                        "--   so if the bounds select tool is selected it can't be a text select or note\n"
                        "\n"
                        "set activeTool to tool\n"
                        
                        "-- check for select tool first as this tool selection deselects the other types\n"
                        "if activeTool is select tool then\n"
                        
                        "-- image tool is selected\n"
                        "-- does it have a selection\n"
                        "set selBounds to selection bounds -- (left, top, right, bottom)\n"
                        "\n"
                        "if item 2 of selBounds > 0 then -- the select tool has an image selection\n"
                        "\n"
                        "set unknownSelectionType to false\n"
                        "\n"
                        "set thePage to index of the selection page -- selection page is only for the image selection tool\n"
                        "\n"
                        "if wantImage then\n"
                        "\n"
                        "try\n"
                        "\n"
                        "set the clipboard to (grab selection page for selBounds)\n"
                        "\n"
                        "set imageSelected to true\n"
                        "\n"
                        "on error\n"
                        "\n"
                        "set imageSelected to false\n"
                        "\n"
                        "end try\n"
                        "\n"
                        "end if\n"
                        "\n"
                        "-- get the bounds\n"
                        "set leftBound to item 1 of selBounds\n"
                        "set topBound to item 2 of selBounds\n"
                        "set rightBound to item 3 of selBounds\n"
                        "set bottomBound to item 4 of selBounds\n"
                        "\n"
                        "set output to (thePage & \", \" & leftBound & \", \" & topBound & \", \" & rightBound & \", \" & bottomBound as string)\n"
                        "\n"
                        "end if\n"
                        "\n"
                        "end if\n"
                        "\n"
                        "\n"
                        "if unknownSelectionType is equal to true then -- let's check for a text selection now\n"
                        "\n"
                        "-- a note selection can be active even though a text tool is selected and visa versa,\n"
                        "--  so we have to check the selection itself to check this\n"
                        "-- check for text selection first\n"
                        "\n"
                        "set theSel to the selection\n"
                        "set startSelection to get index for theSel\n"
                        "if startSelection > 0 then\n"
                        "\n"
                        "set unknownSelectionType to false\n"
                        "\n"
                        "set thePages to get pages for theSel\n"
                        "set thePage to index of item 1 of thePages as integer\n"
                        "\n"
                        "set stopSelection to get index for theSel with last\n"
                        "\n"
                        "copy (get text for theSel) to selText\n"
                        "set selText to selText as text\n"
                        "\n"
                        "set output to (thePage & \", \" & (startSelection as string) & \", \" & stopSelection as string)\n"
                        "\n"
                        "if highlightText then\n"
                        "make note with properties {type:highlight note, selection:theSel}\n"
                        "end if\n"
                        "\n"
                        "end if\n"
                        "\n"
                        "end if -- done checking for a text selection\n"
                        "\n"
                        
                        "if unknownSelectionType is equal to true then -- let's check for a note now\n"
                        "\n"
                        "set theNote to active note\n"
                        "if theNote is not equal to missing value then\n"
                        "\n"
                        "set unknownSelectionType to false\n"
                        "\n"
                        "set theSel to the selection of theNote\n"
                        "copy (get text for theSel) to selText\n"
                        "set selText to selText as text\n"
                        "\n"
                        "-- a note is present but what type?\n"
                        "\n"
                        "-- 	could be: 	text note, ‌anchored note, ‌circle note, box note, ‌highlight note,\n"
                        "-- 	‌			underline note, ‌strike out note, ‌line note, ‌freehand note\n"
                        "\n"
                        "-- selection note types are: highlight note, underline note, ‌strike out note\n"
                        "-- bounded notes are: circle note, box note, ‌line note, ‌anchored note, ‌freehand note\n"
                        "\n"
                        "if type of theNote is in {highlight note, underline note, strike out note} then\n"
                        "\n"
                        "--log \"It's a selection note\"\n"
                        "\n"
                        "set startSelection to get index for theSel\n"
                        "set thePages to get pages for theSel\n"
                        "set thePage to index of item 1 of thePages as integer\n"
                        "\n"
                        "set stopSelection to get index for theSel with last\n"
                        "\n"
                        "copy (get text for theSel) to selText\n"
                        "set selText to selText as text\n"
                        "\n"
                        "set output to (thePage & \", \" & (startSelection as string) & \", \" & stopSelection as string)\n"
                        "\n"
                        "else --if type of theNote is in {circle note, box note, line note, text note, freehand note, anchored note} then\n"
                        "\n"
                        "--log \"It's a bounded note\"\n"
                        "set thePage to the index of the page of theNote\n"
                        "set selBounds to get bounds for theNote\n"
                        "\n"
                        "set selText to the text of theNote\n"
                        "set leftBound to item 1 of selBounds\n"
                        "set topBound to item 2 of selBounds\n"
                        "set rightBound to item 3 of selBounds\n"
                        "set bottomBound to item 4 of selBounds\n"
                        "\n"
                        "set output to (thePage & \", \" & leftBound & \", \" & topBound & \", \" & rightBound & \", \" & bottomBound as string)\n"
                        "end if\n"
                        "\n"
                        "end if\n"
                        "\n"
                        "end if -- done checking for note\n"
                        "\n"
                        "if unknownSelectionType is equal to true then -- still don't know what could be selected\n"
                        "\n"
                        "-- just put the page number and that's it\n"
                        "set thePage to index of the current page\n"
                        "\n"
                        "set output to thePage as string\n"
                        "\n"
                        "end if\n"
                        "\n"
                        "set filePath to path\n"
                        "\n"
                        "end tell\n"
                        "\n"
                        "end if\n"
                        "\n"
                        "end tell\n"
                        "\n"
                        "if wantImage and imageSelected then\n"
                        "set wantImage to true -- it's already set to 'true', but just for clarity…\n"
                        "else\n"
                        "set wantImage to false\n"
                        "end if\n"
                        "\n"
                        "tell application \"Episodic Notes\"\n"
                        "getFilePath filePath CopiedText selText OutputValue output Clipboard wantImage Title detailName with args\n"
                        "end tell\n"];
                         DBOutputScript * outputScript =  [self outputScriptNamed:@"Default Output" forApplication:application];
  
  outputScript.isEditable = [NSNumber numberWithBool:NO];

  inputScript.outputScript = outputScript;
  
  outputScript.script = [NSString stringWithFormat:
                         @"set maxPossible to 5\n"
                         "\n"
                         "set myArray to my theSplit(output, \", \", maxPossible)\n"
                         "\n"
                         "--these array values will be set to -1 if no value is present\n"
                         "set pageNum to item 1 of myArray as integer\n"
                         "set item2 to item 2 of myArray as integer --  startSel or left\n"
                         "set item3 to item 3 of myArray as integer --  stopSel or top\n"
                         "set item4 to item 4 of myArray as integer --  right\n"
                         "set item5 to item 5 of myArray as integer --  bottom\n"
                         "\n"
                         "tell application \"Skim\"\n"
                         "activate\n"
                         "open filePath\n"
                         "-- validate output\n"
                         "if pageNum > -1 then -- page number was provided\n"
                         "tell the front document\n"
                         "go to page pageNum\n"
                         "\n"
                         "if (item2 > -1) and (item3 > -1) then\n"
                         "\n"
                         "if (item3 > -1) and (item4 > -1) then\n"
                         "-- we need to make a bounding box\n"
                         "-- item2 is the left of the selection\n"
                         "-- item3 is the top of the selection\n"
                         "-- item2 is the right of the selection\n"
                         "-- item3 is the bottom of the selection\n"
                         "set tool to select tool\n"
                         "set selection bounds to {item2, item3, item4, item5}\n"
                         "\n"
                         "else\n"
                         "-- we need to make a text selection\n"
                         "-- item2 is the start of the selection\n"
                         "-- item3 is the end of the selection\n"
                         "set tool to text tool\n"
                         "set selection to {a reference to characters item2 thru item3 of page pageNum}\n"
                         "\n"
                         "end if\n"
                         "\n"
                         "end if\n"
                         "\n"
                         "end tell\n"
                         "\n"
                         "end if\n"
                         "\n"
                         "end tell\n"
                         "\n"
                         "on theSplit(theString, theDelimiter, slotNum)\n"
                         "-- save delimiters to restore old settings\n"
                         "set oldDelimiters to AppleScript's text item delimiters\n"
                         "-- set delimiters to delimiter to be used\n"
                         "set AppleScript's text item delimiters to theDelimiter\n"
                         "-- create the array\n"
                         "set theArray to every text item of theString\n"
                         "-- restore the old setting\n"
                         "set AppleScript's text item delimiters to oldDelimiters\n"
                         "\n"
                         "-- Fill in array to slotNum\n"
                         "set listSize to count of theArray\n"
                         "repeat with i from (listSize + 1) to slotNum -- we need\n"
                         "set the end of theArray to -1\n"
                         "end repeat\n"
                         "\n"
                         "-- return the result\n"
                         "return theArray\n"
                         "end theSplit\n"];
  
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) setupWordScripts{
  
  DBApplication *application = [self applicationWithName:@"Word"];
  
  DBInputScript * inputScript = [self inputScriptNamed:@"Default Input" forApplication:application];
  
  inputScript.isEditable = [NSNumber numberWithBool:NO];
  
  inputScript.isActiveScript = [NSNumber numberWithBool:YES];
  
  inputScript.script = [NSString stringWithFormat:
                        
                        @"set wantImage to true -- \n"
                        "set filePath to \"\" --\n"
                        "set selText to \"\" --\n"
                        "set output to \"\" -- { firstCharacter, lastCharacter, bookMark}\n"
                        "set detailName to \"\"\n"
                        "\n"
                        "set highlightText to true\n"
                        "set bookmarkBaseName to \"bookmark\"\n"
                        "\n"
                        "set useBookmarks to true -- this will make links more reliable but will save the document to preserve the bookmark\n"
                        "\n"
                        "-- there are two ways to link back to the text: with or without bookmarks\n"
                        "--   without bookmarks - the text will link back to the first and last character of the selection.  Obviously if you move the text around or add/remove text before the selection the link will be off.\n"
                        "--   with bookmarks - you can add and remove text but you need to save the document so the bookmark is preserved.  this will be done automatically if useBookmarks is set to true\n"
                        "--   if a bookmark can't be found the script reverts to finding the text by the character indices\n"
                        "\n"
                        "-- a needed improvement is to get images from inside text boxes\n"
                        "--   haven't been able to detect images inside of text boxes\n"
                        "--   the selection object doesn't report having any text boxes\n"
                        "--   the anchor points of the text boxes reported by the document aren't within the selection range\n"
                        "\n"
                        "tell application \"Microsoft Word\"\n"
                        "set theActiveDoc to the active document\n"
                        "set filePath to the full name of theActiveDoc\n"
                        "\n"
                        "set theSelection to the selection of the active window\n"
                        "set textRange to text object of theSelection\n"
                        "\n"
                        "set selectionStart to selection start of theSelection\n"
                        "set selectionEnd to selection end of theSelection\n"
                        "\n"
                        "set output to selectionStart & \", \" & selectionEnd as string\n"
                        "\n"
                        "if highlightText then\n"
                        "\n"
                        "set highlightColor to default highlight color index of settings\n"
                        "set highlight color index of textRange to highlightColor\n"
                        "\n"
                        "end if\n"
                        "\n"
                        "\n"
                        "if useBookmarks then\n"
                        "\n"
                        "-- need to make a unique bookmark name\n"
                        "-- we'll look through all the bookmark names and\n"
                        "--  and make sure our new bookmark name is one higher than any other\n"
                        "--  bookmark with the same bookmarkBaseName\n"
                        "\n"
                        "set allBookmarks to bookmarks of theActiveDoc\n"
                        "set numBookmarks to count of allBookmarks\n"
                        "set bookmarkIndex to 1\n"
                        "set baseNameLength to length of bookmarkBaseName\n"
                        "repeat with i from 1 to numBookmarks\n"
                        "set bookmarkName to name of item i of allBookmarks\n"
                        "\n"
                        "if bookmarkName contains bookmarkBaseName then\n"
                        "-- get the text following the bookmark and try to read it as a number\n"
                        "set startIndex to baseNameLength + 1\n"
                        "\n"
                        "try -- need this for the first bookmark of bookmarkBaseName\n"
                        "set thisIndex to (characters startIndex thru end of bookmarkName) as string\n"
                        "if thisIndex as integer ≥ bookmarkIndex then\n"
                        "\n"
                        "set bookmarkIndex to (thisIndex + 1)\n"
                        "\n"
                        "end if\n"
                        "end try\n"
                        "end if\n"
                        "end repeat\n"
                        "\n"
                        "-- make a unique bookmark name\n"
                        "set newBookmarkName to bookmarkBaseName & (bookmarkIndex as string)\n"
                        "set output to output & \", \" & newBookmarkName\n"
                        "\n"
                        "-- let's make a new book mark to the selection with our new bookmark name\n"
                        "\n"
                        "make new bookmark at theActiveDoc with properties {name:newBookmarkName, start of bookmark:selectionStart, end of bookmark:selectionEnd}\n"
                        "\n"
                        "log \"output: \" & output\n"
                        "save theActiveDoc\n"
                        "-- saving kills the selection, so we need to remake it\n"
                        "-- create range theActiveDoc start (selectionStart) end (selectionEnd)\n"
                        "\n"
                        "end if -- use bookmarks\n"
                        "\n"
                        "if wantImage then\n"
                        "set wantImage to false\n"
                        "\n"
                        "set tableNum to count of tables of theSelection\n"
                        "set picNum to count of inline shapes of theSelection\n"
                        "if tableNum + picNum > 0 then\n"
                        "copy as picture textRange\n"
                        "set wantImage to true\n"
                        "set selText to \"\"\n"
                        "end if\n"
                        "end if\n"
                        "if not wantImage then\n"
                        "set selText to content of theSelection\n"
                        "end if\n"
                        "end tell\n"
                        "tell application \"Episodic Notes\"\n"
                        "getFilePath filePath CopiedText selText OutputValue output Clipboard wantImage Title detailName with args\n"
                        "end tell\n"];
  
  DBOutputScript * outputScript =  [self outputScriptNamed:@"Default Output" forApplication:application];
  
  outputScript.isEditable = [NSNumber numberWithBool:NO];
  
  inputScript.outputScript = outputScript;
  
  outputScript.script = [NSString stringWithFormat:
                         @"set maxSlots to 3\n"
                         "\n"
                         "set myArray to my theSplit(output, \", \", maxSlots)\n"
                         "set selectionStart to item 1 of myArray as integer\n"
                         "set selectionEnd to item 2 of myArray as integer\n"
                         "set selectedBookmark to item 3 of myArray as string\n"
                         "\n"
                         "tell application \"Microsoft Word\"\n"
                         "\n"
                         "-- don't want to try to open if it's already open\n"
                         "set allDocs to documents\n"
                         "set docNum to count of allDocs\n"
                         "log docNum\n"
                         "\n"
                         "set alreadyOpen to false\n"
                         "repeat with i from 1 to docNum\n"
                         "set anOpenDoc to item i of allDocs\n"
                         "set posixPath to the full name of anOpenDoc as POSIX file\n"
                         "if (posixPath as string) ends with filePath then\n"
                         "--log \"found doc\"\n"
                         "activate object anOpenDoc\n"
                         "set alreadyOpen to true\n"
                         "exit repeat\n"
                         "end if\n"
                         "end repeat\n"
                         "\n"
                         "if not alreadyOpen then\n"
                         "open filePath\n"
                         "end if\n"
                         "\n"
                         "if bookmark is not equal to \"-1\" then\n"
                         "-- select bookmark\n"
                         "set allBookmarks to bookmarks of the active document\n"
                         "set numBookmarks to count of allBookmarks\n"
                         "repeat with i from 1 to numBookmarks\n"
                         "set thisBookmark to item i of allBookmarks\n"
                         "set bookmarkName to name of thisBookmark\n"
                         "\n"
                         "if bookmarkName is equal to selectedBookmark then\n"
                         "set selectionStart to start of bookmark of thisBookmark\n"
                         "set selectionEnd to end of bookmark of thisBookmark\n"
                         "--log \"found bookmark\"\n"
                         "exit repeat\n"
                         "end if\n"
                         "end repeat\n"
                         "end if\n"
                         "\n"
                         "\n"
                         "set theRange to create range of the active document start (selectionStart) end (selectionEnd)\n"
                         "select theRange\n"
                         "\n"
                         "end tell\n"
                         "\n"
                         "on theSplit(theString, theDelimiter, slotNum)\n"
                         "-- save delimiters to restore old settings\n"
                         "set oldDelimiters to AppleScript's text item delimiters\n"
                         "-- set delimiters to delimiter to be used\n"
                         "set AppleScript's text item delimiters to theDelimiter\n"
                         "-- create the array\n"
                         "set theArray to every text item of theString\n"
                         "-- restore the old setting\n"
                         "set AppleScript's text item delimiters to oldDelimiters\n"
                         "\n"
                         "-- Fill in array to slotNum\n"
                         "set listSize to count of theArray\n"
                         "repeat with i from (listSize + 1) to slotNum -- we need\n"
                         "set the end of theArray to -1\n"
                         "end repeat\n"
                         "\n"
                         "-- return the result\n"
                         "return theArray\n"
                         "end theSplit\n"];
  
  
}
@end
