//
//  BaseAPIManager.m
//  ArchitecturalPattern（架构）
//
//  Created by 何凯楠 on 2017/3/15.
//  Copyright © 2017年 HeXiaoBa. All rights reserved.
//

#import "XTSimpleHttpRequestUtils.h"
#import "XTHttpRequestUtils.h"

@interface XTSimpleHttpRequestUtils()

@end

@implementation XTSimpleHttpRequestUtils

static XTSimpleHttpRequestUtils *request = nil;
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        request = [[[self class] alloc] init];
    });
    return request;
}

+ (void)requestGetWithURL:(NSString *)url completionHandler:(NetworkCompletionHandler)completionHandler {
    
    XTSimpleHttpRequestUtils *utils = [XTSimpleHttpRequestUtils shareInstance];
    [utils requestType:XTRequestTypeGET url:url parm:nil completionHandler:completionHandler];
}

+ (void)requestPostWithURL:(NSString *)url parm:(id)parm completionHandler:(NetworkCompletionHandler)completionHandler {
    XTSimpleHttpRequestUtils *utils = [XTSimpleHttpRequestUtils shareInstance];
    [utils requestType:XTRequestTypePOST url:url parm:parm completionHandler:completionHandler];
}


- (void)requestType:(XTRequestType)requetType url:(NSString *)url parm:(id)parm completionHandler:(NetworkCompletionHandler)completionHandler {
    
    if (!url) {
        return;
    }
    
    NSURL *baseURL = [NSURL URLWithString:self.baseUrl];
    NSString *allUrl = [[NSURL URLWithString:url relativeToURL:baseURL] absoluteString];
    
    switch (requetType) {
        case XTRequestTypeGET:
        {
            [XTHttpRequestUtils GET:allUrl success:^(XBURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
                if (responseObject) {
                    completionHandler ? completionHandler(nil, responseObject) : nil;
                }
            } failure:^(XBURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
                if (error) {
                    completionHandler ? completionHandler(error, nil) : nil;
                }
            }];

        }
            break;
        case XTRequestTypePOST:
        {
            [XTHttpRequestUtils POST:allUrl parameters:parm success:^(XBURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
                if (responseObject) {
                    completionHandler ? completionHandler(nil, responseObject) : nil;
                }
            } failure:^(XBURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
                if (error) {
                    completionHandler ? completionHandler(error, nil) : nil;
                }
            }];
        }
            break;
        default:
            break;
    }
}

@end
