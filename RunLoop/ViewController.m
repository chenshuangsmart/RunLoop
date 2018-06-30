//
//  ViewController.m
//  RunLoop
//
//  Created by cs on 2018/6/30.
//  Copyright © 2018年 cs. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
/** 线程 */
@property(nonatomic, strong)NSThread *thread;
@end

@implementation ViewController {
    UIImageView *_imgView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self drawTextView];
//    [self drawImageView];
//    [self setupTimer];
//    [self drawButton];
//    [self addObserver];
    [self createThread];
}

- (void)getRunLoop {
    CFRunLoopGetCurrent();  // 获得当前线程的RunLoop对象
    CFRunLoopGetMain(); // 获得主线程的RunLoop对象
    
    [NSRunLoop currentRunLoop]; // 获得当前线程的RunLoop对象
    [NSRunLoop mainRunLoop];    // 获得主线程的RunLoop对象
}

- (void)drawTextView {
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    textView.text = @"Do any additional setup after loading the view, typically from a nib.Do any additional setup after loading the view, typically from a nib.Do any additional setup after loading the view, typically from a nib.Do any additional setup after loading the view, typically from a nib.Do any additional setup after loading the view, typically from a nib.Do any additional setup after loading the view, typically from a nib.Do any additional setup after loading the view, typically from a nib.Do any additional setup after loading the view, typically from a nib.Do any additional setup after loading the view, typically from a nib.Do any additional setup after loading the view, typically from a nib.Do any additional setup after loading the view, typically from a nib.Do any additional setup after loading the view, typically from a nib.Do any additional setup after loading the view, typically from a nib.Do any additional setup after loading the view, typically from a nib.Do any additional setup after loading the view, typically from a nib.Do any additional setup after loading the view, typically from a nib.Do any additional setup after loading the view, typically from a nib.Do any additional setup after loading the view, typically from a nib.Do any additional setup after loading the view, typically from a nib.Do any additional setup after loading the view, typically from a nib.Do any additional setup after loading the view, typically from a nib.Do any additional setup after loading the view, typically from a nib.Do any additional setup after loading the view, typically from a nib.Do any additional setup after loading the view, typically from a nib.Do any additional setup after loading the view, typically from a nib.Do any additional setup after loading the view, typically from a nib.Do any additional setup after loading the view, typically from a nib.Do any additional setup after loading the view, typically from a nib.Do any additional setup after loading the view, typically from a nib.Do any additional setup after loading the view, typically from a nib.";
    textView.center = self.view.center;
    [self.view addSubview:textView];
}

- (void)setupTimer {
    // 添加定时器
    NSTimer *timer1 = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
    
    // 定义一个定时器
    NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
    // 添加到 runloop
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)drawButton {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 200, 50);
    [btn setTitle:@"按钮" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.center = self.view.center;
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)btnClick {
    NSLog(@"btn click");
}

- (void)run {
    NSLog(@"---run---");
}

// 添加 RunLoop 监听
- (void)addObserver {
    // 创建观察者
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        NSLog(@"监听到RunLoop发生改变---%zd",activity);
    });
    // 添加观察者到当前的 RunLoop 中
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
    // 释放 observer, 最后添加完需要释放掉
    CFRelease(observer);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [_imgView performSelector:@selector(setImage:) withObject:[UIImage imageNamed:@"scenery"] afterDelay:4.0 inModes:@[NSDefaultRunLoopMode]];
    
    // 利用performSelector，在self.thread的线程中调用run2方法执行任务
    [self performSelector:@selector(run2) onThread:self.thread withObject:nil waitUntilDone:NO];
}

- (void)drawImageView {
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 50, 200, 200)];
    [self.view addSubview:_imgView];
}

- (void)run1 {
    // 执行任务
    NSLog(@"---run---");
    
    // 添加下边两句代码，就可以开启RunLoop，之后self.thread就变成了常驻线程，可随时添加任务，并交于RunLoop处理
    [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] run];
    
    // 测试是否开启了RunLoop，如果开启RunLoop，则来不了这里，因为RunLoop开启了循环。
    NSLog(@"未开启RunLoop");
}

- (void)createThread {
    // 创建线程
    self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(run1) object:nil];
    // 开启线程
    [self.thread start];
}

- (void)run2 {
    NSLog(@"---run2---");
}

@end
