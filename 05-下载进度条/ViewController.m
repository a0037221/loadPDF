//
//  ViewController.m
//  05-下载进度条
//
//  Created by qingLiang on 15/4/17.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "ViewController.h"
#import <SSZipArchive.h>

@interface ViewController ()<NSURLSessionDownloadDelegate>

@property(nonatomic,strong) NSURLSession *session;

@property (weak, nonatomic) IBOutlet UIProgressView *myProgress;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self download];
}

- (void)download
{
    //1.url
    NSURL *url = [NSURL URLWithString:@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V4.0.2.dmg"];
    //2.开始下载
    NSLog(@"start");
    //使用块带啊回调无法跟进速度
//    [[self.session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
//        NSLog(@"%@",location);
//    }] resume];
    //直接开启下载任务,可以跟进
    [[self.session downloadTaskWithURL:url] resume];

}

#pragma mark - 代理方法
//提示:在iOS7中,以下三个方法都必须实现
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"%@,%@",location,[NSThread currentThread]);
}

/**
 *  下载进度
 *  bytesWritten                本次下载的字节数
 *  totalBytesWritten           已经下载的字节数
 *  totalBytesExpectedToWrite   总字节数
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.myProgress.progress = (float) totalBytesWritten / totalBytesExpectedToWrite;
        NSLog(@"%f",self.myProgress.progress);
    }];
}
//断点续传,可以什么都不写
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    NSLog(@"%s",__func__);
}

#pragma mark - 懒加载
- (NSURLSession *)session
{
    if (_session == nil) {
        //会话配置 - 可以开启全局会话共享
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        /*
         参数:
         1.配置
         2.代理
         3.调度代理工作的队列
         */
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    }
    return _session;
}
@end
