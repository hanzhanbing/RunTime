//
//  ViewController.m
//  RunTime_运行时
//
//  Created by 韩占禀 on 15/5/21.
//  Copyright (c) 2015年 jiehang. All rights reserved.
//

#import "ViewController.h"
#import "Student.h"
#import <objc/runtime.h>

/*
 C语言是静态语言
 OC是动态运行时语言（多态）
 运行时机制是多态的基础
 */
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self member];
    [self memberFunction];
    
}

#pragma mark - 用运行时输出一个类的所有属性和成员变量
- (void)member {
    Student *student = [[Student alloc] init];
    NSLog(@"student description : %@",student.description);
    
    unsigned int count = 0;
    //Ivar (instance variable 实例变量) runtime定义的一个结构体
    //class_copyIvarList 获取一个类的所有实例变量
    Ivar *members = class_copyIvarList([Student class], &count);
    for (int i = 0; i<count; i++) {
        Ivar ivar = members[i];
        
        //ivar_getNmae 获取Ivar的名字
        const char *memberName = ivar_getName(ivar);
        //ivar_getTypeEncoding 获取Ivar的类型
        const char *memberType = ivar_getTypeEncoding(ivar);
        NSLog(@"%s --- %s",memberName,memberType);
    }
    
    Ivar member_name = members[0];
    //object_setIvar：设置变量的值 修改私有成员变量
    object_setIvar(student, member_name, @"yujing");
    
    NSLog(@"after runtime : %@",[student description]);
}

#pragma mark - 用运行时输出一个类的所有方法
- (void)memberFunction {
    [self addFunction];
    unsigned int count = 0;
    Method *memberFunctions = class_copyMethodList([Student class], &count);
    for (int i = 0; i<count; i++) {
        Method method = memberFunctions[i];
        
        //SEL @selector(<#selector#>)
        SEL methodName = method_getName(method);
        const char *nameCString = sel_getName(methodName);
        NSString *nameString = [NSString stringWithCString:nameCString encoding:NSUTF8StringEncoding];
        NSLog(@"method name %@",nameString);
    }
}

#pragma mark - 用运行时给一个类添加方法
- (void)addFunction {
    //IMP 实现implementation||const char * C语言||v@:@ v:void @:@ 方法名:参数
    //1.被添加方法的类
    //2.添加的方法名
    //3. 方法的引用
    //4.返回值类型和参数类型
    class_addMethod([Student class], @selector(ocMethod:), (IMP)cMethod, "v@:@");
    
    Student *student = [[Student alloc] init];
    //[student ocMethod:@"韩占禀"]; //编译时校验
    //编译的时候不校验 RunTime 运行时执行
    [student performSelector:@selector(ocMethod:) withObject:@"韩占禀"];
}

void cMethod (id self, SEL _cmd, NSString *string) {
    NSLog(@"%@",string);
}

- (void)ocMethod:(NSString *)str {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
