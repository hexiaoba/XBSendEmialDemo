//
//  NetworkReachabilityTool.m
//  YueWuYou
//
//  Created by 何凯楠 on 2016/10/10.
//  Copyright © 2016年 HeXiaoBa. All rights reserved.
//

#import "XTNetworkReachabilityUtils.h"
#import "AFNetworking.h"

@implementation XTNetworkReachabilityUtils


+ (void)xt_networkReachability {
    
    //设置基准网址（用于ping）
    NSURL *baseURL = [NSURL URLWithString:@"https://www.baidu.com"];
    
    //初始化监听
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    
    NSOperationQueue *operationQueue = manager.operationQueue;
    
    //监听结果回调
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            case AFNetworkReachabilityStatusNotReachable:
            {
                NSLog(@"网络不可用");
                [operationQueue setSuspended:YES];
                
                //发送系统通知网络不可用
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                [operationQueue setSuspended:NO];
                NSLog(@"有wan网络");
                
                //发送系统通知有网络
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                [operationQueue setSuspended:NO];
                NSLog(@"有wifi网络");
                
                //发送系统通知有网络
            }
                break;
            default:
                break;
        }
    }];
    
    //开始监听
    [manager.reachabilityManager startMonitoring];
}


@end
