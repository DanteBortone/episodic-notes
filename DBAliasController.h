//
//  DBAliasManagement.h
//  NoteTaker
//
//  Created by Dante Bortone with Copyright on 8/30/12.
//  Copyright 2012 Dante Bortone. All rights reserved.
//


#import <Cocoa/Cocoa.h>


#import "DBObjectController.h"

@class DBDetailController;
@class DBFileTopic;
@class DBControllerOfOutlineViews;

@interface DBAliasController : DBObjectController {

  //NoteTaker_AppDelegate * appDelegate;
  NSManagedObjectContext * managedObjectContext;
  NSFileManager * fileManager;
  NSString * aliasFileFolder;
  DBControllerOfOutlineViews *controllerOfOutlineViews;
}

@property (strong) DBFileTopic *currentFileSelection;
@property (strong) NSMutableArray *aliasURLs;

- (void) updateAliasURLsArray;
//- (void) makeLinkAndDetail:(NSString *)filePath withNote:(NSString *)text;

- (DBFileTopic *) linkForPath:(NSString *)filePath;

- (NSURL *) fileURL:(NSString * )filePath;
- (NSString *) makeUniqueFileName:(NSString *)suggestedName forFolder:(NSString*)folderPath;
- (BOOL) createAliasFile:(NSString *)aliasName inFolder:(NSString*)aliasFolder toTargetFile:(NSURL *)fileURL;
- (DBFileTopic *) newFileTopic:(NSString *) aliasFileName entitled:(NSString *)originalFileName withPath:(NSString *)filePath;
- (NSString *) updateAliasObjectPath:(DBFileTopic *)aliasObject;
- (NSString *) pathWithSlash:(NSURL *) fileURL;
- (void) setCurrentFileSelection;
- (NSArray *) fetchAliasLinksWithStatus:(Boolean)status;
- (void) clearAliasFilesWithoutAliasLinks;
- (void) listFiles;
- (DBFileTopic *)fileTopicFromURL:(NSURL *)url;

@end
