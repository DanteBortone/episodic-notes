//
//  DBPreferencesDetailOutline.m
//  NoteTaker
//
//  Created by Dante on 8/6/13.
//
//


//---------------------------------------------
#import "DBPreferencesDetailOutline.h"
//---------------------------------------------


@implementation DBPreferencesDetailOutline


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) awakeFromNib{

  
  NSTableColumn * noteColumn = [self tableColumnWithIdentifier:@"Note"];
  [[noteColumn headerCell] setImage:[NSImage imageNamed:@"TableHeaderNote"]];
  
  NSTableColumn * fileColumn = [self tableColumnWithIdentifier:@"File"];
  [[fileColumn headerCell] setImage:[NSImage imageNamed:@"TableHeaderFile"]];
  
  NSTableColumn * checkColumn = [self tableColumnWithIdentifier:@"Check"];
  [[checkColumn headerCell] setImage:[NSImage imageNamed:@"SmallCheck"]];

  NSTableColumn * imageColumn = [self tableColumnWithIdentifier:@"Image"];
  [[imageColumn headerCell] setImage:[NSImage imageNamed:@"TableHeaderImage"]];
  
  [self sizeToFit];
  
}

@end
