/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBManagedTreeObject.h"
//---------------------------------------------

@class DBTopicObject;
@class DBTopicObject;
@class DBFileTopic;
@class DBOutputScript;

//---------------------------------------------


@interface DBDetail : DBManagedTreeObject

// Attributes -------------
@property (strong) NSDate * dateAssociated;
@property (strong) NSDate * dateCreated;
@property (strong) NSDate * dateModified;
@property (strong) NSNumber * isChecked;// 0 off, 1 on, -1 mixed
@property (strong) NSString * note;
@property (strong) NSString * outputValue;
@property (strong) NSData * image;
@property (strong) NSNumber *showSubGroupChecks;

// Relationships ----------
@property (strong) DBFileTopic * sourceFile;
@property (strong) DBTopicObject * topic;
@property (strong) DBOutputScript * outputScript;

//-(NSInteger) siblingCount;

-(void) updateCheckMark;

//- (Boolean)hasNote;

@end
