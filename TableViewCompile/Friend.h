//
//  Friend.h
//  TableViewCompile
//
//  Created by liangzhen on 2017/1/14.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Friend : NSObject

@property(nonatomic,copy)NSString * friendName;

@property(nonatomic,getter=isStarFriend)BOOL starFriend;

@end
