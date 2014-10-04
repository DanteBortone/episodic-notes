//
//  getPathTextOutputClipboardForTitle.m
//  NoteTaker
//
//  Created by Dante on 10/10/13.
//
//


//---------------------------------------------
#import "DBGetPathTextOutputClipboardForTitle.h"
//---------------------------------------------
#import "DBDetailController.h"
#import "NoteTaker_AppDelegate.h"


@implementation DBGetPathTextOutputClipboardForTitle


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(id)performDefaultImplementation {
  
  //NSLog(@"running DBGetPathTextOutputClipboardForTitle");
  
  NoteTaker_AppDelegate *appDelegate;
  appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  //Get values from applescript
  NSDictionary *args = [self evaluatedArguments];
  
  NSString *filePath = @"";
  NSString *copiedText = @"";
  NSString *outputValue = @"";
  BOOL hasImageOnClipBoard = NO;
  NSString *detailTitle = @"";

  //NSLog(@"args: %@",[args description]);
  
  if(args.count) {
    
    filePath = [args valueForKey:@""];    // get the direct argument
    if([args valueForKey:@"CopiedText"]) copiedText = [args valueForKey:@"CopiedText"];
    if([args valueForKey:@"OutputValue"]) outputValue = [args valueForKey:@"OutputValue"];
    if([args valueForKey:@"Clipboard"]) hasImageOnClipBoard = [[args objectForKey:@"Clipboard"] boolValue];//__NSCFBoolean private NSNumber class
    if([args valueForKey:@"Title"]) detailTitle = [args valueForKey:@"Title"];
    
    

    
    //NSLog(@"raw filePath: %@", filePath);
    //NSLog(@"copiedText: %@", copiedText);
    //NSLog(@"outputValue: %@", outputValue);
    //NSLog(@"clipboard: %@", clipboard ? @"YES" : @"NO");
    //NSLog(@"title: %@", detailTitle);

  }

  



  //pass on info to detail controller
  [appDelegate.detailController newDetailWithPath: filePath
                                             note: copiedText
                                      outputValue: outputValue
                                 imageOnClipboard: hasImageOnClipBoard
                                         entitled: detailTitle ];
  
  return nil;
  
}

@end
