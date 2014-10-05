/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBOutlineView.h"
//---------------------------------------------


@interface DBDetailOutlineView : DBOutlineView {
  
  //NSInteger rowNum;
  //NSInteger colNum;
  //NSTextView * textOverView;
  NSScrollView * scrollView;
  BOOL dragInProgress;

}




//this is important.  view-based outline/table views utilize this method:
//-(void)selectRowIndexes:(NSIndexSet *)indexes byExtendingSelection:(BOOL)extend{
// to systematically select rows as they are inserted.  This selection cannot be stopped by anything the tree controller does. I don't want my views selected when the views are initialized.  My solution to stop it is to inactivate "selectRowIndexes" during DBDetailViewController assignTopic.  I reactivate selectRowIndexesEnabled when needed: mouseDown on outlineView, add insert or remove, drag, others??? DBTextViewCell also looks to this value to see if it should become editable. It's an NSNumber so we can set value for the key in other places.

@property (strong) NSNumber *selectRowIndexesEnabled;

- (NSNumber *) selectedRowFromEvent:(NSEvent *)theEvent;
- (void) checkTextViewCellforEndEditing;


@end
