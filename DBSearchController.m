//
//  DBSearchController.m
//  NoteTaker
//
//  Created by Dante on 3/16/13.
//
//


//---------------------------------------------
#import "DBSearchController.h"
//---------------------------------------------
#import "NSString_Extensions.h"

#define DEFAULT_PREDICATE @"displayName CONTAINS[cd] 'Detail'"
#define STORED_PREDICATE_KEY @"storedPredicateFormat"

@implementation DBSearchController

@synthesize userSearchPredicate;
@synthesize searchWindow;
@synthesize searchArrayController;
@synthesize predicateEditor;



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) awakeFromNib {

  [ super awakeFromNib ];
  
  [searchWindow setDelegate:self];
  

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) initializeSearchPredicate
{

  NSString *predicateFormat = [[NSUserDefaults standardUserDefaults] objectForKey:STORED_PREDICATE_KEY];
  
  if (predicateFormat){
    //NSLog(@"predicateFormat exists");
    //[self setPredicate:predicateFormat];
    
    userSearchPredicate = [NSCompoundPredicate predicateWithFormat:predicateFormat];
  
  } else {
    
    //NSLog(@"predicateFormat does not exist");
    
    //[self setPredicate: DEFAULT_PREDICATE];

    userSearchPredicate = [NSCompoundPredicate predicateWithFormat: DEFAULT_PREDICATE];
    
    
  }
  
  //NSLog(@"userSearchPredicate: %@", [userSearchPredicate predicateFormat]);

// from http://stackoverflow.com/questions/5642681/nspredicateeditor-in-xcode-4
  
  NSArray *keyPaths = @[[NSExpression expressionForKeyPath:@"displayName"],
                        [NSExpression expressionForKeyPath:@"note"]];
  NSArray *operators = @[@(NSEqualToPredicateOperatorType),
                         @(NSNotEqualToPredicateOperatorType),
                         @(NSBeginsWithPredicateOperatorType),
                         @(NSEndsWithPredicateOperatorType),
                         @(NSContainsPredicateOperatorType)];
  
  NSPredicateEditorRowTemplate *template = [[NSPredicateEditorRowTemplate alloc] initWithLeftExpressions:keyPaths
                                                                            rightExpressionAttributeType:NSStringAttributeType
                                                                                                modifier:NSDirectPredicateModifier
                                                                                               operators:operators
                                                                                                 options:(NSCaseInsensitivePredicateOption | NSDiacriticInsensitivePredicateOption)];
  
  // chage display of titles
  NSPopUpButton * popUpButton = [[template templateViews] objectAtIndex:0];
  NSArray * itemArray = [popUpButton itemArray];
  [[itemArray objectAtIndex:0] setTitle:@"Title"];
  [[itemArray objectAtIndex:1] setTitle:@"Note"];
  
  NSArray *compoundTypes = @[@(NSNotPredicateType),
                             @(NSAndPredicateType),
                             @(NSOrPredicateType)];
  NSPredicateEditorRowTemplate *compound = [[NSPredicateEditorRowTemplate alloc] initWithCompoundTypes:compoundTypes];
  
  [predicateEditor setRowTemplates:@[template, compound]];
  
  // need to force display of compound row
  // http://stackoverflow.com/questions/5976244/forcing-the-display-of-a-compound-row-with-nspredicateeditor
  if ([userSearchPredicate isKindOfClass:[NSComparisonPredicate class]]) {
    userSearchPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObject:userSearchPredicate]];
  }
  
  [predicateEditor setObjectValue:userSearchPredicate];

}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) setPredicate:(NSString *)value {

  //NSLog(@"set predicate");
  
  NSPredicate *p = [NSPredicate predicateWithFormat:value];
  
  if ([p isKindOfClass:[NSComparisonPredicate class]]) {
          
      userSearchPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObject:p]];
    
  } else {
    
      userSearchPredicate = p;

  }


  [searchArrayController setFetchPredicate:userSearchPredicate];

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void)storeSearchPredicate
{
  //store last entered search predicate
  NSString *format = [userSearchPredicate predicateFormat];
  
 // NSLog(@"storeSearchPredicate: %@", format);
  
  [[NSUserDefaults standardUserDefaults] setObject:format forKey:STORED_PREDICATE_KEY];

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (IBAction)toggleSearchWindow:(id)sender{
  
  if ([searchWindow isVisible]){
    
    [self orderOutPanel];
    
  } else {
    
    //[warningField setStringValue:@""];
    
    [searchWindow makeKeyAndOrderFront:searchWindow];
    [searchWindow makeFirstResponder:searchWindow]; //without this initial loads didn't accept the input search predicate
        // 20131111 - tried lots of other ways with no success:
            // reload data on table, rearrange object on controller array,  validatepredicate

  }
  
}
/*
- (IBAction)closeSearchWindow:(id)sender{
  
  [self orderOutPanel];
  
}
*/


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) orderOutPanel{
  
  [searchWindow orderOut:searchWindow];
  //[self clearPanel];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(IBAction)testButton:(id)sender;
{
  //[predicateEditor setObjectValue:userSearchPredicate];
  NSLog(@"predicateEditor predicate value: %@", [[predicateEditor objectValue] predicateFormat]);
  
}

@end
