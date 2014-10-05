/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBTopicObject.h"
//---------------------------------------------

@class DBGlobalWiki;
@class DBLocalWiki;
@class DBSubTopic;

//---------------------------------------------


@interface DBMainTopic : DBTopicObject


// Relationships ----------
@property (strong) NSSet* subTopics;
@property (strong) NSSet * wikiWords;


- (NSString *) wikiString;

- (DBGlobalWiki *) primaryWikiWord;
- (NSArray *) allLocalWikiWords;
- (NSArray *) allLocalWikiStrings;
- (NSArray *) allGlobalWikiStrings;
- (DBLocalWiki *) localWikiFrom:(NSString *)string;
- (DBSubTopic *) subTopicFrom:(NSString *)string;

@end
