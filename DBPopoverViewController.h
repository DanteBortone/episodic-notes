//
//  DBPopoverViewController.h
//  Episodic Notes
//
//  Created by Dante Bortone on 4/1/14.
//
//

#import <Cocoa/Cocoa.h>

@interface DBPopoverViewController : NSViewController {
  
  IBOutlet NSButton * toggleButton;
  IBOutlet NSButton * closeButton;
  IBOutlet NSPopover * myPopover;
  
}

@end
