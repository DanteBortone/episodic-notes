//
//  DBAliasManagement.m
//  NoteTaker
//
//  Created by Dante Bortone with Copyright on 8/30/12.
//  Copyright 2012 UNC-Chapel Hill. All rights reserved.
//


//---------------------------------------------
#import "DBAliasController.h"
//---------------------------------------------
#import "DBDetail.h"
#import "DBDetailController.h"
#import "DBFileTopic.h"
#import "DBObjectController.h"
#import "DBOutlineViewDelegate.h"
#import "DBDetailOutlineViewDelegate.h"
#import "DBDetailOutlineViewController.h"
#import "DBControllerOfOutlineViews.h"
#import "NoteTaker_AppDelegate.h"
#import "NSArray_Extensions.h"
#import "NSURL_Extensions.h"
#import "NSString_Extensions.h"
#import "DBBrowserController.h"

@implementation DBAliasController

@synthesize currentFileSelection;
@synthesize aliasURLs;



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)awakeFromNib
{
  
  [super awakeFromNib];
  //appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  controllerOfOutlineViews = appDelegate.controllerOfOutlineViews;
  
  managedObjectContext = appDelegate.managedObjectContext;
  //aliasPath = [appDelegate.applicationSupportDirectory stringByAppendingPathComponent: @"Alias files"];
  fileManager = [NSFileManager defaultManager];
  
  aliasFileFolder = appDelegate.aliasFileFolder;
  aliasURLs = [NSMutableArray array];
  [self clearUnusedFileTopics];
  [self clearAliasFilesWithoutAliasLinks];
  [self updateAliasURLsArray];
  [super awakeFromNib];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// seems silly to keep a fileTopic around if they aren't being used
- (void)clearUnusedFileTopics
{
  
  NSFetchRequest *fetchAllFileTopics = [[NSFetchRequest alloc] init];
  [fetchAllFileTopics setEntity:[NSEntityDescription entityForName:@"FileTopic" inManagedObjectContext:appDelegate.managedObjectContext]];
  
  NSError *error = nil;
  NSArray *activeFileTopics = [appDelegate.managedObjectContext executeFetchRequest:fetchAllFileTopics error:&error];
  
  for (int index = 0; index < activeFileTopics.count; index += 1) {
    
    DBFileTopic * fileTopic = [activeFileTopics objectAtIndex:index];
    
    NSInteger itemCount = 0;

    itemCount = fileTopic.headers.count + fileTopic.views.count + fileTopic.details.count + fileTopic.referencers.count;
    
    if (itemCount == 0) {
      
      NSLog(@"Deleting file topic with no associated objects: %@", fileTopic.displayName);
      [appDelegate.managedObjectContext deleteObject:fileTopic];
      
    }
    
  }
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------


- (DBFileTopic *)fileTopicFromURL:(NSURL *)url
{
  
  NSArray * activeFileTopics = [ self fetchAliasLinksWithStatus:TRUE ];
  
  for (DBFileTopic * fileTopic in activeFileTopics) {

    if ([[self urlOfFileTopic:fileTopic] isEqual:url]) return fileTopic;
    
  }
  
  // make new link
  
  return NULL;
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------


- (void) updateAliasURLsArray
{
  
  // get the alias objects
  NSArray * aliasFiles = [NSArray array];
  
  aliasFiles = [ self fetchAliasLinksWithStatus:TRUE ];

  NSURL * url;
  for (DBFileTopic * fileTopic in aliasFiles){
    
    url = [self urlOfFileTopic:fileTopic];
    
    if (url) {
    
      [aliasURLs addObject:url];

    }
    
  }

  [ appDelegate.browserController reloadVisibleColumns ];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// takes file path and returns the file url
// handels mac address or posix path
// also gets the original file if the path it's given is an alias
- (NSURL *) fileURL:(NSString * )filePath
{
  
  NSURL *fileURL;
  
  if ([filePath isEqualToString:@"/"]) {
    filePath = @"//";
  }
  
  //NSLog(@"raw filePath: %@", filePath);
  
  if ([filePath containsString:@":"]){
    
    // this could be trouble, if an applescript returns a HFS path to a directory.
    fileURL = CFBridgingRelease(CFURLCreateWithFileSystemPath(NULL, (__bridge CFStringRef)(filePath), kCFURLHFSPathStyle, FALSE));
    
    filePath = [fileURL path];
    //NSLog(@"contained \":\". processed filePath: %@", [fileURL path]);
    
  } else {
    
    fileURL = [NSURL fileURLWithPath:filePath];
    
  }
  
  
  if ([fileURL isAlias]) {  // is the fileURL to an alias or an actual file location
    
    fileURL = [fileURL getAliasTargetURL];
    
  }
  
  if ([fileURL checkResourceIsReachableAndReturnError:NULL]) {
    //NSLog(@"valid file location");
    return fileURL;

  } else {
    //NSLog(@"invalid file location");
    return NULL;
  }

  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------


// searches existing alias files for link
// returns existing alias file if one is present
// if none exists it makes a new one

// if the file path doesn't point to a real file then this returns NULL
- (DBFileTopic *) linkForPath:(NSString *)filePath
{
  
  DBFileTopic * fileTopic;
  
  // --- < convert to posix path if it wasn't one > -----
  NSURL *fileURL = [self fileURL:filePath]; // this will be null if invalid path
  
  if (fileURL) {

    filePath = [fileURL path];
    // --- < / convert to posix path if it wasn't one > -----
    
    // search paths of existing alias files and see if there is a match
    
    NSArray *fileTopics = [self fetchAliasLinksWithStatus:TRUE];
    NSString * targetPath;
    Boolean aliasAlreadyExisted = NO;
    NSString * updatedPath =[self pathWithSlash:fileURL];
    
    for (int i = 0; i < fileTopics.count; i++) {
      
      fileTopic = [ fileTopics objectAtIndex:i ];
      targetPath = [self updateAliasObjectPath:fileTopic];
      
      if ([targetPath isEqualToString:updatedPath]) {
        aliasAlreadyExisted = YES;
        break;
      }
      
    }
    
    NSString * fileName = [fileURL lastPathComponent];
    
    if ([fileName isEqualToString:@"/"]) {
      fileName = @"Root";
    }
    
    if (!aliasAlreadyExisted){
      
      // very similar to DBBrowserController: _browserDoubleClick, but didn't see a smooth way to use one method
      
      NSString *aliasName = [self makeUniqueFileName:fileName forFolder:aliasFileFolder];
      [self createAliasFile:aliasName inFolder:aliasFileFolder toTargetFile:fileURL ];
      fileTopic = [self newFileTopic:(NSString *)aliasName entitled:(NSString *)fileName withPath:(NSString *)filePath];
      //fileTopic.fileIcon = [[NSWorkspace sharedWorkspace] iconForFile:filePath];
      
    }
    
    return fileTopic;
  } else {
    
    return NULL;
  
  }
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

//checks if suggestedName is unique to folder
//if it's not it appends a number and keeps incrementing it until the name is unique

- (NSString *) makeUniqueFileName:(NSString *)suggestedName forFolder:(NSString*)folderPath
{

  NSString * uniqueName;
  
  
  if ([fileManager fileExistsAtPath:[aliasFileFolder stringByAppendingPathComponent: suggestedName]]) {

    int i=0;
    do {
      i+=1;
      uniqueName = [suggestedName stringByAppendingString:[NSString stringWithFormat:@"%i",i]];
    } while ([fileManager fileExistsAtPath:[aliasFileFolder stringByAppendingPathComponent: uniqueName]]);

  } else {
    
    uniqueName = suggestedName;

  }
  
  return uniqueName;
}




// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// makes file alias shortcut and returns true if created successfully
- (BOOL) createAliasFile:(NSString *)aliasName inFolder:(NSString*)aliasFolder toTargetFile:(NSURL *)fileURL
{
  NSData * bookmark;
  NSURL * aliasFileLocation;
  NSError *error = nil;
  
  aliasFileLocation = [NSURL fileURLWithPath:[aliasFileFolder stringByAppendingPathComponent: aliasName]];

  bookmark = [fileURL bookmarkDataWithOptions: NSURLBookmarkCreationSuitableForBookmarkFile includingResourceValuesForKeys:nil relativeToURL:nil error:&error];
  if (error != nil){
    NSLog(@"createAliasFile bookmarkDataWithOptions error: %@",error);
    return NO;
  }
   
  [NSURL writeBookmarkData:bookmark toURL:aliasFileLocation options:NSURLBookmarkCreationSuitableForBookmarkFile error:&error];
  if (error != nil){
    NSLog(@"createAliasFile writeBookmarkData error: %@",error);
    return NO;
  }
  
  return YES;
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

//filepath here needs to be posix
- (DBFileTopic *) newFileTopic:(NSString *)aliasFileName entitled:(NSString *)originalFileName withPath:(NSString *)filePath{

  //NSLog(@"newFileTopic");
  
  DBFileTopic * fileTopic;

  
  fileTopic = [NSEntityDescription insertNewObjectForEntityForName:@"FileTopic"
                                            inManagedObjectContext:managedObjectContext];
  fileTopic.fileIcon = [[NSWorkspace sharedWorkspace] iconForFile:filePath];
  
  [fileTopic setValue:[NSNumber numberWithBool:TRUE] forKey:@"activeLink"];

  [fileTopic setValue:aliasFileName forKey:@"aliasFileName"];
  [fileTopic setValue:originalFileName forKey:@"fileName"];
  [fileTopic setValue:[NSDate date] forKey:@"lastUse"];
  [fileTopic setValue:filePath forKey:@"recentPath"];

  [fileTopic setValue:originalFileName forKey:@"displayName"];
  [fileTopic setValue:[NSDate date] forKey:@"dateCreated"];
  [fileTopic setValue:[NSDate date] forKey:@"dateModified"];
  
  [ self updateAliasURLsArray ];
  
  return fileTopic;
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

//checks alias file target location
//alias link path is updated
//path is returned
- (NSString *) updateAliasObjectPath:(DBFileTopic *)fileTopic{
  NSURL * aliasTargetURL;

  aliasTargetURL = [self urlOfFileTopic:fileTopic];
  NSString * targetPath;

  
  if (aliasTargetURL) {
    targetPath = [NSString stringWithString:[self pathWithSlash:aliasTargetURL]];
    
    fileTopic.recentPath = targetPath;

    fileTopic.fileName = [aliasTargetURL lastPathComponent];

    return targetPath;
    
  } else {
    
    return NULL;
    
  }

}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSURL *) urlOfFileTopic:(DBFileTopic *)fileTopic{
  
  NSURL * aliasFileLocation;
  NSURL * aliasTargetURL;
  NSError * error;
  
  error = nil;
  aliasFileLocation = [NSURL fileURLWithPath:[aliasFileFolder stringByAppendingPathComponent: [fileTopic valueForKey:@"aliasFileName"]]];
  
  //need to check for broken link
  aliasTargetURL = [aliasFileLocation getAliasTargetURL];

  if (aliasTargetURL == NULL) {
    
    [fileManager removeItemAtURL:aliasFileLocation error:&error];
    
    if(error != nil){
      
      NSLog(@"DBAliasController - urlOfFileTopic: %@", error);
      
    } else {
      
      NSLog(@"Cannot find target file.  Deleting corresponding alias file.");
      
    }
    
    NSLog(@"AliasLink marked as inactive: %@", [fileTopic valueForKey:@"fileName"]);
    
    [fileTopic setValue:[NSNumber numberWithBool:FALSE] forKey:@"activeLink"];
    
    return NULL;
    
  } else {

    return aliasTargetURL;
    
  }
  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSString *) pathWithSlash:(NSURL *)fileURL{
  
  NSMutableString * targetPath;
  targetPath = [NSMutableString stringWithString:[fileURL path]];
  
  if ([[fileURL absoluteString] hasSuffix:@"/"]){
    [targetPath appendString:@"/"];
  }
  return targetPath;
}


-(void) setCurrentFileSelection{
  NSArray * selectionArray;
  NSTreeNode * selectedNode;
  DBDetail * selectedObject;
  DBFileTopic * aliasLink;
  //NSURL * fileURL;

  selectionArray = [controllerOfOutlineViews.activeDetailOutlineViewController.tree selectedNodes];
  if (selectionArray.count>0){
    
    selectedNode = [selectionArray objectAtIndex:0];
    selectedObject = [selectedNode representedObject];
    
    aliasLink = [selectedObject valueForKey:@"sourceFile"];
    //if(aliasLink!=NULL){
      //fileURL = [self getFileUrl:aliasLink];
      //NSLog(@"file url is: %@", [fileURL absoluteString]);
    //}
  }
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(NSArray *)fetchAliasLinksWithStatus:(Boolean)status {
  NSSortDescriptor * aliasSorter;
  aliasSorter = [[NSSortDescriptor alloc] initWithKey:@"lastUse" ascending:NO];
  NSPredicate* aliasPredicate;
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  
  if(status==TRUE) {
    aliasPredicate = [NSPredicate predicateWithFormat:@"activeLink == TRUE" ];
  } else {
    aliasPredicate = [NSPredicate predicateWithFormat:@"activeLink == FALSE" ];
  }
  
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"FileTopic" 
                                            inManagedObjectContext:managedObjectContext];

  [fetchRequest setPredicate:aliasPredicate];
  [fetchRequest setEntity:entity];
  [fetchRequest setSortDescriptors:@[aliasSorter]];

  NSError *error;
  
  return [managedObjectContext executeFetchRequest:fetchRequest error:&error];
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void)clearAliasFilesWithoutAliasLinks{
  
  NSArray * fileList;
  NSURL *aliasURL = [NSURL fileURLWithPath: aliasFileFolder];
  //NSDate * startTime = [NSDate date];  //want to keep track of how ling this takes
  //get a list of the alias file urls
  NSError *error;
  fileList = [fileManager contentsOfDirectoryAtURL:aliasURL 
                        includingPropertiesForKeys:nil 
                                           options:NSDirectoryEnumerationSkipsHiddenFiles
                                              error:&error];
  
  
  //every file in the folder should be on the active file list, 
  //    if not then delete the alias
  NSArray * activeFiles = [self fetchAliasLinksWithStatus:TRUE];
  if(activeFiles.count>0){
    NSArray * activeFileNames = [activeFiles valueForKey:@"aliasFileName"];
    
    //NSLog(@"activeFileNames: %@", activeFileNames);
    
    NSURL * thisURL;
    NSString * fileName;

    for (int i=0; i < fileList.count;i++){
      thisURL = [fileList objectAtIndex:i];
      fileName = [[fileManager displayNameAtPath:[thisURL absoluteString]] 
                  stringByReplacingOccurrencesOfString:@"%20" withString:@" "];

      //searching array of strings for string
      NSUInteger index = [activeFileNames indexOfObjectWithOptions:NSEnumerationConcurrent 
      passingTest:^(id obj, NSUInteger idx, BOOL *stop) 
      {
        NSString *s = (NSString *)obj;
        if ([fileName rangeOfString:s].location != NSNotFound) {
          *stop = YES;
          return YES;
      }
        return NO;
      }];
      //Delete files if they don't match
      if (index == NSNotFound) {
        NSLog(@"Deleting alias file that does not have aliasLink: %@", fileName); 
        [fileManager removeItemAtURL:thisURL error:nil];
      }
    }
  } else if ( fileList.count > 0 ) {
    //need to clear all alias files
    
    NSLog(@"No aliasLinks found.  All alias files cleared.");
    for (int j=0; j < fileList.count;j++){
      [fileManager removeItemAtURL:[fileList objectAtIndex:j] error:nil];
    }
  }
  //NSLog(@"Seconds to complete clearAliasFilesWithoutAliasLinks: %f",[[NSDate date] timeIntervalSinceDate:startTime]);
  
}




#pragma mark -
#pragma mark For debugging


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void) listFiles {
  
  NSArray *activeAliasFiles = [self fetchAliasLinksWithStatus:TRUE];
  if (activeAliasFiles.count > 0){
    NSLog(@"\r---------Active files---------\r%@",[[activeAliasFiles valueForKey:@"fileName"] listStrings]);
  } else {
    NSLog(@"\r---------No active files found---------");
  }
  
  NSArray * inactiveAliasFiles = [self fetchAliasLinksWithStatus:FALSE];
  
  if (inactiveAliasFiles.count > 0){
    NSLog(@"\r---------Inactive files---------\r%@",[[inactiveAliasFiles valueForKey:@"fileName"] listStrings]);
  } else {
    NSLog(@"\r---------No inactive files found---------");
  }
  
}

@end
