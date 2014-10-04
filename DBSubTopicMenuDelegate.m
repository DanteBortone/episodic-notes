//
//  DBSubTopicMenuDelegate.m
//  NoteTaker
//
//  Created by Dante on 11/28/13.
//
//
//---------------------------------------------
#import "DBSubTopicMenuDelegate.h"
//---------------------------------------------
#import "DBDetailViewController.h"
#import "DBViewObject.h"
#import "DBTopicObject.h"
#import "DBMainTopic.h"
#import "DBSubTopic.h"
#import "DBControllerOfOutlineViews.h"
#import "DBDetailOutlineViewController.h"
#import "DBOutlineView.h"
#import "NoteTaker_AppDelegate.h"
#import "DBSubTopicController.h"
#import "DBEditTopicController.h"
@implementation DBSubTopicMenuDelegate


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)awakeFromNib {
  
  appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];

  subTopicsMenu = [ [ NSMenu alloc ] initWithTitle:@"" ];
  [ subTopicsMenu setAutoenablesItems: NO ];
  [ subTopicsMenu setShowsStateColumn: NO ];
  subTopicsMenu.delegate = self;
  
  [subTopicButton setMenu:subTopicsMenu];
  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// this button and menu will only be unhidden if it's a local topic or if it's a mainTopic with subTopics

- (void)menuWillOpen:(NSMenu *)menu {
  
  [ detailViewController becomeActiveViewController ];

  [ subTopicsMenu removeAllItems ];

//for local topic and main topic show:
    // main topic
      // sub topic1...
  
  DBTopicObject * editingTopic = detailViewController.managedViewObject.viewTopic;
  
  DBMainTopic * mainTopic;
  
  if ([detailViewController.managedViewObject.viewTopic isKindOfClass:[DBMainTopic class]]) {
    
    mainTopic = (DBMainTopic *)editingTopic;

  } else {
    
    mainTopic = [(DBSubTopic *)editingTopic mainTopic];
    
  }
  

  
  NSArray * subTopics = [mainTopic.subTopics allObjects];
  NSSortDescriptor * sortByIndex  = [[NSSortDescriptor alloc] initWithKey:@"sortIndex" ascending:YES];
  subTopics = [subTopics sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByIndex]];
  
  NSMenuItem *menuItem;

  if (subTopics.count > 0) {
    
    NSImage *image;
    NSString * mainTopicImageName = @"global.pdf";
    NSSize imageSize;
    imageSize.width = 15;
    imageSize.height = 15;
    
    
    //first make item for mainTopic
    menuItem= [[NSMenuItem alloc] initWithTitle:mainTopic.displayName
                                         action:@selector(topicSelected:)
                                  keyEquivalent:@""];
    
    image = [NSImage imageNamed:mainTopicImageName];
    [image setSize:imageSize];
    
    [menuItem setImage:image];
    
    menuItem.target = self;
    [menuItem setState:NSOffState];
    [menuItem setRepresentedObject:mainTopic];
    
    [menuItem setIndentationLevel:0];
    
    [subTopicsMenu addItem:menuItem]; // global topic
    
    
    // ----- < make items for subTopics > -----
    
    NSString * subTopicImageName = @"local.pdf";

    for (DBSubTopic * subTopic in subTopics) {
      
      menuItem= [[NSMenuItem alloc] initWithTitle:subTopic.displayName
                                           action:@selector(topicSelected:)
                                    keyEquivalent:@""];
      
      image = [NSImage imageNamed:subTopicImageName];
      [image setSize:imageSize];
      
      [menuItem setImage:image];
      
      menuItem.target = self;
      [menuItem setState:NSOffState];
      [menuItem setRepresentedObject:subTopic];
      [menuItem setIndentationLevel:1];

      [subTopicsMenu addItem:menuItem];
      
    }
    
  } else {
    
    menuItem= [[NSMenuItem alloc] initWithTitle:@"No Subtopics" action:NULL keyEquivalent:@""];
    [menuItem setState:NSOffState];
    [menuItem setEnabled:NO];

    [subTopicsMenu addItem:menuItem];
    
  }
  
  // ----- < / make items for subTopics > -----


  
  // add divider
  [subTopicsMenu addItem:[NSMenuItem separatorItem]];

  // ----- < add option to add new local topic > -----
  
  menuItem = [[NSMenuItem alloc] initWithTitle:@"Add Subtopic..."
                                        action:@selector(addLocalWikiTopic:)
                                 keyEquivalent:@""];

  menuItem.representedObject = mainTopic;
  menuItem.target = self;
  [menuItem setState:NSOffState];
  [menuItem setIndentationLevel:0];

  [subTopicsMenu addItem:menuItem];
  
  // ----- < / add option to add new local topic > -----
  
  
  // ----- < add option to edit topic > -----
  
  
  NSString * itemTitle = [ NSString stringWithFormat: @"Edit %@...", editingTopic.formattedName ];
  menuItem = [[NSMenuItem alloc] initWithTitle: itemTitle
                                        action: @selector(editTopic:)
                                 keyEquivalent: @""];
  
  menuItem.representedObject = editingTopic;
  menuItem.target = self;
  [menuItem setState:NSOffState];
  [menuItem setIndentationLevel:0];
  
  [subTopicsMenu addItem:menuItem];
  
  // ----- < / add option to edit topic > -----
  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void)topicSelected:(id)sender
{
  
  NSMenuItem * menuItem = sender;
  DBTopicObject * topic = [menuItem representedObject];
  
  //DBDetailOutlineViewController * outlineViewController = [detailViewController.controllerOfOutlineViews targetViewControllerForLinks];
  
  //DBDetailViewController * viewController = detailViewController.controllerOfOutlineViews.activeDetailOutlineViewController.mainDetailViewController;
  
  [ detailViewController assignTopic:topic ];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void)editTopic:(id)sender
{
  NSMenuItem * menuItem = sender;
  DBMainTopic * topic = [menuItem representedObject];
  
  [ appDelegate.editTopicController beginEditingTopic:topic ];
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void)addLocalWikiTopic:(id)sender
{
  NSMenuItem * menuItem = sender;
  DBMainTopic * topic = [menuItem representedObject];
  
  [appDelegate.subTopicController openPanelWithTopic:topic];
  
}


@end
