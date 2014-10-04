//
//  DBEnterEnabledButtonView.m
//  Episodic Notes
//
//  Created by Dante Bortone on 4/6/14.
//
//

#import "DBEnterEnabledButton.h"

// This is for buttons that should respond to <enter> and highlight when mad ethe first responder and dehilight and do not respond to <enter> when resigning first responder

@implementation DBEnterEnabledButton

-(void)awakeFromNib {
 
  [[self window] setDefaultButtonCell:self.cell];

}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (BOOL) becomeFirstResponder
{
  
  //NSLog(@"becomeFirstResponder");
  [[self window] enableKeyEquivalentForDefaultButtonCell];
  return [super becomeFirstResponder];
  
}


- (BOOL) resignFirstResponder {
  
  NSLog(@"resignFirstResponder");
  
  [[self window] disableKeyEquivalentForDefaultButtonCell];
  return [super resignFirstResponder];
  
}

@end
