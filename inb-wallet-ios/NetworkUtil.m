//
//  NetworkUtil.m
//  test
//
//  Created by insightChain_iOS开发 on 2019/6/11.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "NetworkUtil.h"
#import "AFNetworking.h"

@implementation NetworkUtil
+ (AFHTTPSessionManager*)sharedManager{
    static AFHTTPSessionManager *_singleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleton = [AFHTTPSessionManager manager]; //[[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[FAGlobal getHostUrl]]];
        //        NSLog(@"请求根路径：%@", [FAGlobal getHostUrl]);
        _singleton.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/json", @"text/javascript", @"text/html", @"image/jpeg", nil];
        //        AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
        //        [securityPolicy setAllowInvalidCertificates:YES];
        //        _singleton.securityPolicy = securityPolicy;
        
    });
    return _singleton;
}
+(void)getRequest:(NSString *)urlStr params:(NSDictionary *)params success:(void(^)(id resonseObject))successBlock failed:(void(^)(NSError *error))failedBlock{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //添加一种支持的类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    [manager GET:urlStr
      parameters:params?params:@{}
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@---%@",[responseObject  class], responseObject);
            successBlock(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"请求失败--%@",error);
            failedBlock(error);
        }];
}
// POST请求
+(void)postRequest:(NSString *)urlStr params:(NSDictionary *)params success:(void(^)(id resonseObject))successBlock failed:(void(^)(NSError *error))failedBlock{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    

    
    NSData *da = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    NSString *json = [[NSString alloc]initWithData:da encoding:NSUTF8StringEncoding];
    
    //添加一种支持的类型
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json", @"text/plain", nil];
    [manager POST:urlStr
       parameters:params
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               NSLog(@"%@---%@",[responseObject  class],responseObject);
             successBlock(responseObject);
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               NSLog(@"请求失败--%@",error);
             failedBlock(error);
         }];
}
-(void)download:(NSString *)urlStr {
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:0];
    //2.下载文件
    /* 第一个参数:请求对象
     * 第二个参数:progress  进度回调 downloadProgress
     * 第三个参数:destination  回调(目标位置)                有返回值                targetPath:临时文件路径                response:响应头信息     第四个参数:completionHandler  下载完成之后的回调                filePath:最终的文件路径     */
    NSURLSessionDownloadTask *download = [manager downloadTaskWithRequest:request
                                                                 progress:^(NSProgress * _Nonnull downloadProgress) {
                                                                     //监听下载进度
                                                                     //completedUnitCount  已经下载的数据大小
                                                                     //totalUnitCount      文件数据的中大小
                                                                     NSLog(@"%f", 1.0 * downloadProgress.completedUnitCount /  downloadProgress.totalUnitCount);
                                                                 } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                                                                      NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,  YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];         NSLog(@"targetPath:%@",targetPath);        NSLog(@"fullPath:%@",fullPath);
                                                                     return  [NSURL fileURLWithPath:fullPath];
                                                                 } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                                                                     NSLog(@"%@",filePath);
                                                                 }];
    //3.执行Task
    [download  resume];
}

// AFN文件/图片上传
-(void)upload2:(NSString *)urlStr{
    //1.创建会话管理者
    AFHTTPSessionManager  *manager = [AFHTTPSessionManager manager];
    //NSDictionary *dictM =  @{}
    //2.发送post请求上传文件
    /**第一个参数:请求路径
     * 第二个参数:字典(非文件参数)
     * 第三个参数:constructingBodyWithBlock  处理要上传的文件数据
     * 第四个参数:进度回调
     * 第五个参数:成功回调  responseObject:响应体信息
     * 第六个参数:失败回调
     */
    [manager  POST:urlStr
        parameters:nil
constructingBodyWithBlock:^(id  _Nonnull formData)  {
                UIImage *image =  [UIImage  imageNamed:@"Snip20160227_128"];
                NSData  *imageData =  UIImagePNGRepresentation(image);
                //使用formData来拼接数据
                /*    第一个参数:二进制数据  要上传的文件参数
                 *    第二个参数:服务器规定的
                 *    第三个参数:该文件上传到服务器以什么名称保存
                 */
                //[formData  appendPartWithFileData:imageData name:@"file"  fileName:@"xxxx.png" mimeType:@"image/png"];
                //[formData  appendPartWithFileURL:[NSURL  fileURLWithPath:@"/Users/Cehae/Desktop/Snip20160227_128.png"]  name:@"file" fileName:@"123.png"  mimeType:@"image/png" error:nil];
                [formData  appendPartWithFileURL:[NSURL  fileURLWithPath:@"/Users/Cehae/Desktop/Snip20160227_128.png"]  name:@"file" error:nil];
    }
          progress:^(NSProgress * _Nonnull uploadProgress)  {
              
              NSLog(@"%f",1.0  *  uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
        
    }  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable  responseObject)  {
             NSLog(@"上传成功---%@",responseObject);
        
    }  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)  {
            NSLog(@"上传失败---%@",error);
        
    }];
}

//网络状态监听
-(void)afn{
    //1.获得一个网络状态检测管理者
    AFNetworkReachabilityManager  *manager = [AFNetworkReachabilityManager  sharedManager];
    //2.监听状态的改变
    /* AFNetworkReachabilityStatusUnknown           = -1,  未知
       AFNetworkReachabilityStatusNotReachable      = 0,  没有网络
       AFNetworkReachabilityStatusReachableViaWWAN  = 1,   蜂窝网络
       AFNetworkReachabilityStatusReachableViaWiFi  = 2    Wifi
     */
    [manager  setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)  {
        switch (status)  {
            case  AFNetworkReachabilityStatusReachableViaWWAN:{
                  NSLog(@"蜂窝网络");
                  break;
            }
            case  AFNetworkReachabilityStatusReachableViaWiFi:{
                NSLog(@"WIFI");
                break;
            }
            case  AFNetworkReachabilityStatusNotReachable:{
                NSLog(@"没有网络");
                break;
            }
            case  AFNetworkReachabilityStatusUnknown:{
                NSLog(@"未知");
                break;
            }
            default:
            break;
                
        }
        
    }];
    //3.开始监听
    [manager  startMonitoring];
}

//返回的是JSON数据
-(void)json{
    //1.创建会话管理者
    AFHTTPSessionManager  *manager = [AFHTTPSessionManager  manager];
    //https://120.25.226.186:32812/login?username=123&pwd=122&type=JSON
    NSDictionary  *paramDict =  @{ @"username":@"Cehae",  @"pwd":@"Cehae", @"type":@"JSON"};
     //2.发送GET请求
    /*     第一个参数:请求路径(不包含参数).NSString
     第二个参数:字典(发送给服务器的数据~参数)
     第三个参数:progress  进度回调
     第四个参数:success  成功回调 task:请求任务     responseObject:响应体信息(JSON--->OC对象)
     第五个参数:failure  失败回调
     error:错误信息     响应头:task.response
     */
    [manager  GET:@"https://120.25.226.186:32812/login"
       parameters:paramDict
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id   _Nullable responseObject)  {
              NSLog(@"%@---%@",[responseObject  class],responseObject);
              
          }  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)  {
              NSLog(@"请求失败--%@",error);
              
          }];
}

 //返回的是XML
-(void)xml{
    //1.创建会话管理者
    AFHTTPSessionManager  *manager = [AFHTTPSessionManager  manager];
    //https://120.25.226.186:32812/login?username=123&pwd=122&type=JSON
    //     //注意:如果返回的是xml数据,那么应该修改AFN的解析方案
    manager.responseSerializer  = [AFXMLParserResponseSerializer  serializer];
    NSDictionary *paramDict =  @{@"type":@"XML" };
    //2.发送GET请求
    /*     第一个参数:请求路径(不包含参数).NSString
     第二个参数:字典(发送给服务器的数据~参数)
     第三个参数:progress  进度回调
     第四个参数:success  成功回调        task:请求任务 responseObject:响应体信息(JSON--->OC对象)
     第五个参数:failure  失败回调        error:错误信息     响应头:task.response
     */
    [manager  GET:@"https://120.25.226.186:32812/video"
       parameters:paramDict
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task,NSXMLParser  *parser)  {
              //NSLog(@"%@---%@",[responseObject  class],responseObject);
              //NSXMLParser  *parser =(NSXMLParser  *)responseObject;
              //设置代理
              parser.delegate  = self;
              //开始解析
              [parser  parse];
              
          } failure:^(NSURLSessionDataTask *  _Nullable task, NSError * _Nonnull error) {
              NSLog(@"请求失败--%@",error);
              
          }];
    
}

//返回的二进制数据
-(void)httpData{
    //1.创建会话管理者
    AFHTTPSessionManager  *manager = [AFHTTPSessionManager manager];
    //注意:如果返回的是xml数据,那么应该修改AFN的解析方案AFXMLParserResponseSerializer
    //注意:如果返回的数据既不是xml也不是json那么应该修改解析方案为:
    //manager.responseSerializer  = [AFXMLParserResponseSerializer serializer];
    manager.responseSerializer  = [AFHTTPResponseSerializer  serializer];
    //2.发送GET请求
    [manager  GET:@"https://120.25.226.186:32812/resources/images/minion_01.png"
       parameters:nil
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull  task,id  _Nullable responseObject)  {
              NSLog(@"%@-",[responseObject  class]);
              //UIImage  *image = [UIImage imageWithData:responseObject];
              
          }  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)  {
              NSLog(@"请求失败--%@",error);
              
          }];
    
}
-(void)httpData2{
    //1.创建会话管理者
    AFHTTPSessionManager  *manager = [AFHTTPSessionManager  manager];
    //注意:如果返回的是xml数据,那么应该修改AFN的解析方案AFXMLParserResponseSerializer
    //注意:如果返回的数据既不是xml也不是json那么应该修改解析方案为:
    //manager.responseSerializer  = [AFXMLParserResponseSerializer  serializer];
    //告诉AFN能够接受text/html类型的数据
    manager.responseSerializer.acceptableContentTypes  = [NSSet  setWithObject:@"text/html"];
    manager.responseSerializer  = [AFHTTPResponseSerializer  serializer];
    //2.发送GET请求
    [manager  GET:@"https://www.baidu.com"
       parameters:nil
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task,id  _Nullable  responseObject)  {
              NSLog(@"%@-%@",[responseObject  class],
                    [[NSString alloc]initWithData:responseObject  encoding:NSUTF8StringEncoding]);
              //UIImage  *image = [UIImage imageWithData:responseObject];
              
          }  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)  {
              NSLog(@"请求失败--%@",error);
              
          }];
    
}

+(void)rpc_requetWithURL:(NSString *)url params:(NSDictionary *)params completion:(void(^)(id  _Nullable responseObject, NSError * _Nullable error))completion{
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    AFJSONRequestSerializer *reqie = [AFJSONRequestSerializer serializer];
    [reqie setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSMutableURLRequest *mutRequ = [reqie requestWithMethod:@"POST" URLString:url parameters:params error:nil];
    //设置超时时长
    mutRequ.timeoutInterval = 30;
    [mutRequ setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    //将对象设置到requestbody中 ,主要是这不操作
//    [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:mutRequ
                  uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
                      
                  } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
                      
                  } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//                      NSLog(@"%@-%@",[responseObject  class],
//                            [[NSString alloc]initWithData:responseObject  encoding:NSUTF8StringEncoding]);
                      completion(responseObject, error);
                  }];
    [task resume];
}
#pragma  mark ----------------------
#pragma markNSXMLParserDelegate
-(void)parser:(NSXMLParser *)parser  didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI  qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    NSLog(@"%@--%@",elementName,attributeDict);
    
}

@end
