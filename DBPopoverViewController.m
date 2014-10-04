//
//  DBPopoverViewController.m
//  Episodic Notes
//
//  Created by Dante Bortone on 4/1/14.
//
//

#import "DBPopoverViewController.h"

@implementation DBPopoverViewController

-(void)awakeFromNib
{
  
  [ toggleButton setAction:@selector(togglePopover:) ];
  [ toggleButton setTarget:self ];
  
  [ closeButton setAction:@selector(closePopover:) ];
  [ closeButton setTarget:self ];
  
}


- (IBAction)togglePopover:(id)sender
{
  
  if (toggleButton.intValue == 1) {
    
    [ myPopover showRelativeToRect:[ toggleButton bounds ]
                                       ofView:toggleButton
                                preferredEdge:NSMaxYEdge ];
  } else {
    
    [ myPopover close ];
    
  }
  
}

- (IBAction) closePopover:(id)sender{
  
  [toggleButton setIntValue:0];
  
  [ myPopover close];
  
}


@end
