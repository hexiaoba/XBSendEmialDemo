//
//  HttpTool.h
//  MeiTuan
//
//  Created by 何凯楠 on 16/6/13.
//  Copyright © 2016年 HeXiaoBa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef NSURLSessionDataTask XBURLSessionDataTask;

typedef void(^XBResponseSuccess)(XBURLSessionDataTask * _Nullable task, id _Nullable responseObject);
typedef void(^XBResponseFailure)(XBURLSessionDataTask * _Nullable task, NSError * _Nullable error);

@interface XTHttpRequestUtils : NSObject

+ (nullable XBURLSessionDataTask *)GET:(nonnull NSString *)URLString
                               success:(nullable XBResponseSuccess)success
                               failure:(nullable XBResponseFailure)failure;


+ (nullable XBURLSessionDataTask *)POST:(nonnull NSString *)URLString
                             parameters:(nullable id)parameters
                                success:(nullable XBResponseSuccess)success
                                failure:(nullable XBResponseFailure)failure;

+ (nullable XBURLSessionDataTask *)POST:(nonnull NSString *)URLString
                             parameters:(nullable id)parameters
              constructingBodyWithBlock:(void (^ _Nullable)(id<AFMultipartFormData> _Nonnull formData))block
                                success:(nullable XBResponseSuccess)success
                                failure:(nullable XBResponseFailure)failure;

@end
