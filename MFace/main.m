//
//  main.m
//  MFace
//
//  Created by 赵明明 on 2020/11/11.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    // UIApplicationMain主要负责了：从给定的类名初始化应用程序对象、从给定的应用程序委托类，初始化一个应用程序委托、启动主事件循环，并开始接收事件
    // 第三个参数 principalClassName -- UIApplication 或 UIApplication 子类，nil 默认为 UIApplication
    // 第四个参数 delegateClassName -- AppDelagate 类名
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
