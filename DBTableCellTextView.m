//
//  DBTableCellView.m
//  NoteTaker
//
//  Created by Angela Bortone on 8/15/13.
//
//

#import "DBTableCellTextView.h"
#import "DBTextViewCell.h"

@implementation DBTableCellTextView

@synthesize textView;


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------


-(void) setFrame:(NSRect)frameRect{
  
  
  [textView setFrame:NSMakeRect(0,frameRect.origin.y-1,frameRect.size.width,frameRect.size.height)];

  [super setFrame:frameRect];

}

@end
