//
//  Student.m
//  RunTime_运行时
//
//  Created by 韩占禀 on 15/5/21.
//  Copyright (c) 2015年 jiehang. All rights reserved.
//

#import "Student.h"

//敲 @interface 延展
@interface Student ()
{
    NSString *_name; //属性或者成员变量 全局
}
@end

@implementation Student

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.age = 18;
        _name = @"bruce";
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"name:%@,age:%d",_name, self.age];
}

- (void)sayHello {
    NSLog(@"hello");
}

- (void)sayGoodBye {
    NSLog(@"bye");
}

@end
