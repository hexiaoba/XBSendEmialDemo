//
//  AppDelegate.m
//  PodTest
//
//  Created by 何凯楠 on 2017/4/18.
//  Copyright © 2017年 HeXiaoBa. All rights reserved.
//

#import "AppDelegate.h"
#import "LogConst.h"
#import <skpsmtpmessage/SKPSMTPMessage.h>
#import <skpsmtpmessage/NSData+Base64Additions.h>


@interface AppDelegate ()<SKPSMTPMessageDelegate>
@property (nonatomic, nullable, strong) SKPSMTPMessage *mail;
@property (nonatomic, nullable, strong) DDFileLogger *fileLogger;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //配置DDLog
    [DDLog addLogger:[DDTTYLogger sharedInstance]]; // TTY = Xcode console
    [DDLog addLogger:[DDASLLogger sharedInstance]]; // ASL = Apple System Logs
    
    if (!_fileLogger) {
        _fileLogger = [[DDFileLogger alloc] init]; // File Logger
        _fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
        _fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
        [DDLog addLogger:_fileLogger];
    }
    
    //针对单个文件配置DDLog打印级别，尚未测试
    //    [DDLog setLevel:DDLogLevelAll forClass:nil];
    
    NSLog(@"NSLog");
    DDLogVerbose(@"Verbose");
    DDLogDebug(@"Debug");
    DDLogInfo(@"Info");
    DDLogWarn(@"Warn");
    DDLogError(@"Error");
    
    DDLogVerbose(@"%@", NSHomeDirectory());
    DDLogVerbose(@"%@", _fileLogger.currentLogFileInfo.filePath);
    
    [self sendLogToEmial];
    
    return YES;
}

- (void)sendLogToEmial {
    _mail = [[SKPSMTPMessage alloc] init];
    [_mail setSubject:@"Log"];  // 设置邮件主题
    [_mail setFromEmail:@"hkn35135@163.com"]; // 目标邮箱
    [_mail setToEmail:@"shxiangtaixxjs@163.com"]; // 发送者邮箱
    [_mail setRelayHost:@"smtp.163.com"]; // 发送邮件代理服务器
    [_mail setRequiresAuth:YES];
    [_mail setLogin:@"hkn35135@163.com"]; // 发送者邮箱账号
    [_mail setPass:@"947139054"]; // 发送者邮箱密码
    [_mail setWantsSecure:YES];  // 需要加密
    [_mail setDelegate:self];

    NSString *content = [NSString stringWithCString:"Log日志内容" encoding:NSUTF8StringEncoding];
    NSDictionary *plainPart = @{
                                kSKPSMTPPartContentTypeKey : @"text/plain",
                                kSKPSMTPPartMessageKey: content,
                                kSKPSMTPPartContentTransferEncodingKey : @"8bit"
                                };
    
    
    NSString *filePath = _fileLogger.currentLogFileInfo.filePath;
    NSString *executableFile = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey]; //获取项目名称
    NSString *fileName = [NSString stringWithFormat:@"%@.log", executableFile];
    
    NSData *vcfData = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *vcfPart = @{
                              kSKPSMTPPartContentTypeKey: [NSString stringWithFormat:@"text/directory;\r\n\tx-unix-mode=0644;\r\n\tname=%@", fileName],
                              kSKPSMTPPartContentDispositionKey: [NSString stringWithFormat:@"attachment;\r\n\tfilename=%@", fileName],
                              kSKPSMTPPartMessageKey: [vcfData encodeBase64ForData],
                              kSKPSMTPPartContentTransferEncodingKey: @"base64"
                              };
    
    [_mail setParts:@[plainPart, vcfPart]]; // 邮件首部字段、邮件内容格式和传输编码
    [_mail send];
}

-(void)messageSent:(SKPSMTPMessage *)message {
    DDLogVerbose(@"%@", message);
}

-(void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error {
    DDLogVerbose(@"message = %@, error = %@", message, error);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"applicationWillResignActive");
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"applicationDidEnterBackground");
    [self sendLogToEmial];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
     NSLog(@"applicationWillEnterForeground");
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"applicationDidBecomeActive");
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"applicationWillTerminate");
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
