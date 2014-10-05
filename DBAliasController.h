/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import <Cocoa/Cocoa.h>
//---------------------------------------------

#import "DBObjectController.h"

@class DBDetailController;
@class DBFileTopic;
@class DBControllerOfOutlineViews;

//---------------------------------------------


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
