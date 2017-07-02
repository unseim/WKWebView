//  WebView
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <WebKit/WebKit.h>
#import "WebViewHeaderView.h"

@interface WebViewHeaderView () <WKUIDelegate,WKNavigationDelegate>
@property (nonatomic, strong) WKUserScript *userScript;
@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) UIProgressView *progressView; // 进度条
@end

@implementation WebViewHeaderView
{
    CGFloat webContentHeight;
}



//  加载网页
- (void)loadURL:(NSString *)html
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:html]]];
}

//  释放监听网页高度
- (void)dealloc
{
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

//  监听网页加载进度
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGFloat WebHeight = self.webView.scrollView.contentSize.height;
        //  如果高度一样则不刷新
        if (WebHeight != webContentHeight) {
            webContentHeight = WebHeight;
            [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(WebHeight).priorityHigh();
            }];
            
            //  刷新 Cell高度
            !_WebViewHeightHandler ?: _WebViewHeightHandler(WebHeight);
        }
    }
    
    
    
    //  网页加载紧肤
    if ([keyPath isEqualToString:@"estimatedProgress"])
    {
        self.progressView.progress = self.webView.estimatedProgress;
        if (self.progressView.progress == 1) {
            
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                self.progressView.hidden = YES;
            }];
        }
    }
}



#pragma mark - WebDelegate
//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self bringSubviewToFront:self.progressView];
}


//  加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    //  加载失败同样需要隐藏progressView
    self.progressView.hidden = YES;
}



#pragma mark - 检查HTML元素
//页面加载完成后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    //获取图片数组
    [webView evaluateJavaScript:@"getImages()" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSMutableArray *imgSrcArray = [NSMutableArray arrayWithArray:[result componentsSeparatedByString:@"+"]];
        if (imgSrcArray.count >= 2) {
            [imgSrcArray removeLastObject];
        }
        !_WebViewimageArrayHandler ?: _WebViewimageArrayHandler(imgSrcArray);
    }];
    
    
    [webView evaluateJavaScript:@"registerImageClickAction();" completionHandler:^(id _Nullable result, NSError * _Nullable error) {}];
}


#pragma mark - 导航每次跳转调用跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    // 获取点击的图片
    if ([navigationAction.request.URL.scheme isEqualToString:@"image-preview"]) {
        NSString *URLpath = [navigationAction.request.URL.absoluteString substringFromIndex:[@"image-preview:" length]];
        !_WebViewimageURLHandler ?: _WebViewimageURLHandler(URLpath);
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}


#pragma mark - Lazy

- (WKWebView *)webView {
    if(_webView == nil) {
        //  初始化 webview 的设置
        WKWebViewConfiguration *configer = [[WKWebViewConfiguration alloc] init];
        configer.userContentController = [[WKUserContentController alloc] init];
        configer.preferences = [[WKPreferences alloc] init];
        configer.preferences.javaScriptEnabled = YES;
        configer.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        configer.allowsInlineMediaPlayback = YES;
        [configer.userContentController addUserScript:self.userScript];
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectNull configuration:configer];
        _webView.scrollView.scrollEnabled = NO;
        _webView.scrollView.bounces = NO;
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_webView];
        // 使用kvo为webView添加监听，监听webView的内容高度
        [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
        // 使用kvo为webView添加监听,监听webView的加载进度
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
    }
    return _webView;
}


- (WKUserScript *)userScript
{
    if (!_userScript) {
        static  NSString * const jsGetImages =
        @"function getImages(){\
        var objs = document.getElementsByTagName(\"img\");\
        var imgScr = '';\
        for(var i=0;i<objs.length;i++){\
        imgScr = imgScr + objs[i].src + '+';\
        };\
        return imgScr;\
        };function registerImageClickAction(){\
        var imgs=document.getElementsByTagName('img');\
        var length=imgs.length;\
        for(var i=0;i<length;i++){\
        img=imgs[i];\
        img.onclick=function(){\
        window.location.href='image-preview:'+this.src}\
        }\
        }";
        _userScript = [[WKUserScript alloc] initWithSource:jsGetImages injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    }
    return _userScript;
}




- (UIProgressView *)progressView {
    if(_progressView == nil) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 2)];
        _progressView.progressTintColor = [UIColor blueColor];
        _progressView.trackTintColor = [UIColor lightGrayColor];
        _progressView.backgroundColor = [UIColor clearColor];
        //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
        _progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
        [self addSubview:_progressView];
    }
    return _progressView;
}





@end
