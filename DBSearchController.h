/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBObjectController.h"
//---------------------------------------------


@interface DBSearchController : DBObjectController <NSWindowDelegate>


@property (strong) NSPredicate *userSearchPredicate;
@property (nonatomic, strong) IBOutlet NSWindow * searchWindow;
@property (strong) IBOutlet NSArrayController *searchArrayController;
@property (strong) IBOutlet NSPredicateEditor * predicateEditor;
//@property (strong) IBOutlet NSTableView *myTable;


- (void) initializeSearchPredicate;
- (void) storeSearchPredicate;

- (IBAction)toggleSearchWindow:(id)sender;
//- (IBAction)closeSearchWindow:(id)sender;

-(IBAction)testButton:(id)sender;




@end
