//
//  AppDelegate.m
//  ScriptTaker
//
//  Created by Dante on 10/20/13.
//
//

#import "ScriptTaker_AppDelegate.h"
#import "DBService.h"

#define ACTIVE_STATUS_IMAGE @"StatusActive.pdf"
#define RUNNING_STATUS_IMAGE @"StatusRunning.pdf"

@implementation ScriptTaker_AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  DBService *service;
  service = [[DBService alloc] init];
  [NSApp setServicesProvider:service];
  
  [NSApp setActivationPolicy:NSApplicationActivationPolicyProhibited];

  [self activateStatusMenu];
  
  [[NSUserDefaults standardUserDefaults] registerDefaults:
   [NSDictionary dictionaryWithObjectsAndKeys:
    [NSNumber numberWithBool:YES], @"animateScriptActivation",nil]];
  
}


//http://stackoverflow.com/questions/843379/how-do-you-toggle-the-status-item-in-the-menubar-on-and-off-using-a-checkbox

- (void)activateStatusMenu
{
  NSLog(@"activateStatusMenu");
  NSStatusBar *bar = [NSStatusBar systemStatusBar];
  
  statusItem = [bar statusItemWithLength:NSVariableStatusItemLength];
  
  [statusItem setImage:[NSImage imageNamed:ACTIVE_STATUS_IMAGE]];
  
  NSMenu *theMenu = [[NSMenu alloc] initWithTitle:@""];
  [theMenu setAutoenablesItems:NO];
  
  
  //menu items
    // inactivate
    // enable/disable animation
  NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:@"Inactivate script monitor."
                                                    action:@selector(inactivate:)
                                             keyEquivalent:@""];
  menuItem.target = self;
  [theMenu addItem:menuItem];
  
  [statusItem setMenu:theMenu];
}

-(void)inactivate:(id)sender{
  //remove menu
  [NSApp terminate:NULL];
  //NSLog(@"disable status icon");
  
}

-(void) activateScriptAnimation{
  
  BOOL animateScriptActivation = [[NSUserDefaults standardUserDefaults] boolForKey:@"animateScriptActivation"];
  if (animateScriptActivation) {
    //change title
    //NSLog(@"activateScriptAnimation");
    [statusItem setImage:[NSImage imageNamed:RUNNING_STATUS_IMAGE]];
    
    NSTimer *timer;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(resetAnimation:) userInfo:nil repeats:NO]; // Fire every 4 seconds.
    
  }
  
}

-(void)resetAnimation:(id)sender{

  [statusItem setImage:[NSImage imageNamed:ACTIVE_STATUS_IMAGE]];

}



@end
