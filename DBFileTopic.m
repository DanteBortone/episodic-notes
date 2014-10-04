//
//  DBFileTopic.m
//  NoteTaker
//
//  Created by Dante on 6/16/13.
//
//


//---------------------------------------------
#import "DBFileTopic.h"
//---------------------------------------------


@implementation DBFileTopic

// Attributes -------------
@dynamic activeLink;
@dynamic aliasFileName;
@dynamic fileIcon;
@dynamic fileName;
@dynamic lastUse;
@dynamic recentPath;

// Relationships ----------
@dynamic referencers;



// -------------------------------------------------------------------------------

// isFileTopic

// -------------------------------------------------------------------------------

// sets whether detail view button is hidden

-(BOOL) isFileTopic
{
  return YES;
}


@end
