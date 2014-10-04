//
//  DBTableCellFileView.h
//  NoteTaker
//
//  Created by Dante on 9/8/13.
//
//

#import <Cocoa/Cocoa.h>

//this was subclassed to ID the class of view that was clicked on in DBDetailOutlineView: mouseDown
@interface DBTableCellFileView : NSTableCellView

@property (strong) IBOutlet NSButton *myButton;

@end
