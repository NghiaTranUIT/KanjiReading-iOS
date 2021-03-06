//
//  ATJoyoKanjiDao.h
//  KanjiReading
//
//  Created by Osamu Noguchi on 8/10/13.
//  Copyright (c) 2013 Osamu Noguchi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATBaseDao.h"
#import "ATCharacter.h"

@interface ATJoyoKanjiDao : ATBaseDao

- (ATCharacter *)getData:(NSString *)character;
- (NSString *)getReading:(NSString *)character;

@end
