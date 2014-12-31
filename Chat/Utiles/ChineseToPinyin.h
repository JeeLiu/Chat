//
//  ChineseToPinyin.h
//  Chat
//
//  Created by sky on 14/12/31.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChineseToPinyin : NSObject

+ (NSString *)pinyinFromChineseString:(NSString *)string;
+ (char)sortSectionTitle:(NSString *)string;

@end
