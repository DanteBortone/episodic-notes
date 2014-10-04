//
//  DBTopicimageTransformer.m
//  Episodic Notes
//
//  Created by Dante Bortone on 4/3/14.
//
//

#import "DBTopicImageTransformer.h"

#import "DBNamedTopic.h"
#import "DBSubTopic.h"


@implementation DBTopicImageTransformer

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------


- (void)awakeFromNib
{
  //appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (id)init
{
  self = [super init];
  if (self) {
    // Initialization code here.
  }
  
  return self;
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------


+ (Class)transformedValueClass
{
  return [NSImage class];
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

+ (BOOL)allowsReverseTransformation
{
  return NO;
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (id)transformedValue:(id)value
{
  
  NSImage * returnImage;
  
  if ( [ value isKindOfClass:[DBNamedTopic class] ] ) {
    
    returnImage = [ NSImage imageNamed: @"global" ];
    
  } else if ( [ value isKindOfClass:[DBSubTopic class] ] ) {
    
    returnImage = [ NSImage imageNamed: @"local" ];
    
  }
  
  return returnImage;
  
}

@end
