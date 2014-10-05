/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBObjectController.h"
//---------------------------------------------

@class DBControllerOfOutlineViews;
@class DBMainTopic;
@class DBHyperlinkEditor;
@class DBGlobalWiki;
@class DBLocalWiki;
@class DBSubTopic;
@class DBUndoManager;
@class DBUndoRedoPanel;

//---------------------------------------------


@interface DBWikiWordController : DBObjectController <NSTextFieldDelegate>{
  
  DBControllerOfOutlineViews * controllerOfOutlineViews;
  DBHyperlinkEditor * hyperlinkEditor;
  DBUndoManager * undoManager;

  
}

//@property (strong) DBMainTopic * topic;

//@property (strong) IBOutlet DBHyperlinkEditor * hyperlinkEditor;
@property (nonatomic, strong) IBOutlet DBUndoRedoPanel * wikiWordWindow;
@property (strong) IBOutlet NSArrayController * wikiWordArrayController;
@property (strong) IBOutlet NSTreeController * topicTreeController;
@property (strong) IBOutlet NSTextField * wikiWordField;
@property (strong) IBOutlet NSTextField * addWarningField;
@property (strong) IBOutlet NSTextField * removeWarningField;
@property (strong) IBOutlet NSButton * addButton;
@property (strong) IBOutlet NSSearchField * mySearchField;
@property (strong) IBOutlet NSOutlineView * myOutlineView;


- (IBAction)toggleWikiWordWindow:(id)sender;
- (IBAction)addWikiWord:(id)sender;
- (IBAction)removeWikiWord:(id)sender;
- (DBGlobalWiki *) newGlobalWikiWord:(NSString *)string withTopic:(DBMainTopic *)topicObject;
- (DBLocalWiki *) newLocalWikiWord:(NSString *)string withTopic:(DBSubTopic *)topicObject;

- (DBLocalWiki *) localWikiWordWithString:(NSString *)string inTopic: (DBMainTopic *) topic;
- (BOOL) validateWikiWordName: (NSString *)word;
@end
