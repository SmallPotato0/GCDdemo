//
//  ViewController.m
//  GCDdemo
//
//  Created by mac on 16/4/1.
//  Copyright © 2016年 com. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self test8];
}

/**
 *
 *  死锁
 *
 */
-(void)test8{
    dispatch_queue_t queue = dispatch_queue_create("test8", NULL);
    NSLog(@"1");
    dispatch_sync(queue, ^{
        NSLog(@"2");
//        dispatch_sync(queue, ^{
//            NSLog(@"2");
//        });
//        dispatch_async(queue, ^{
//            NSLog(@"4");
//        });
    });
    NSLog(@"3");
}
-(void)test9{
    NSLog(@"1");
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"2");
    });
    NSLog(@"3");
}
-(void)test10{
    dispatch_queue_t queue = dispatch_queue_create("test8", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSLog(@"1-----%@",[NSThread currentThread]);
    dispatch_async(queue, ^{
        dispatch_sync(queue, ^{
            NSLog(@"2-----%@",[NSThread currentThread]);
        });
        dispatch_async(queue, ^{
            NSLog(@"3----%@",[NSThread currentThread]);
        });
    });
    NSLog(@"4----%@",[NSThread currentThread]);
}

/**
 *
 *  重复执行
 *
 */
-(void)test7{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_apply(5, queue, ^(size_t index) {
        // 执行5次
    });
}

/**
 *
 *  执行完多个任务获得通知
 *
 */
-(void)test6{
    dispatch_queue_t queue = dispatch_queue_create("**test.rongfzh.yc", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"dispatch_async1");
    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:4];
        NSLog(@"dispatch_async2");
    });
    dispatch_barrier_async(queue, ^{
        NSLog(@"dispatch_barrier_async");
        [NSThread sleepForTimeInterval:4];
        
    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"dispatch_async3");
    });
}

/**
 *
 *  执行完多个任务获得通知
 *
 */
-(void)test5{
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"group1");
    });
    
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"group2");
    });
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"group3");
    });
    
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"updateUi");
    });
}

/**
 *
 *  串行队列同步执行
 *
 */
-(void)test4{
    //创建串行队列(DISPATCH_QUEUE_SERIAL是串行队列,宏值为NULL)
    dispatch_queue_t queue = dispatch_queue_create("isTest4", NULL);
    
    dispatch_async(queue, ^{
        NSLog(@"1------%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"2------%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"3------%@",[NSThread currentThread]);
    });
    
    NSLog(@"main-------%@",[NSThread mainThread]);
}

/**
 *
 *  串行队列同步执行
 *
 */
-(void)test3{
    
    //创建串行队列(DISPATCH_QUEUE_SERIAL是串行队列,宏值为NULL)
    dispatch_queue_t queue = dispatch_queue_create("isTest3", NULL);
    
    dispatch_sync(queue, ^{
        NSLog(@"1------%@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"2------%@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"3------%@",[NSThread currentThread]);
    });
    
    NSLog(@"main-------%@",[NSThread mainThread]);
}

/**
 *
 *  全局队列同步执行
 *
 */
-(void)test2{
    
    //获取全局并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_sync(queue, ^{
        NSLog(@"1------%@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"2------%@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"3------%@",[NSThread currentThread]);
    });
    
    NSLog(@"main-------%@",[NSThread mainThread]);
}

/**
 *
 *  全局队列异步执行
 *
 */
-(void)test1{
    
    //获取全局并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        NSLog(@"1------%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"2------%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"3------%@",[NSThread currentThread]);
    });
    
    NSLog(@"main-------%@",[NSThread mainThread]);
}

@end
