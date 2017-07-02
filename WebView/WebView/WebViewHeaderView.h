//  WebView
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <UIKit/UIKit.h>

@interface WebViewHeaderView : UIView

/** 获取网页高度回调 */
@property (nonatomic, copy) void (^WebViewHeightHandler) (CGFloat);

/** 获取网页图片数组回调 */
@property (nonatomic, copy) void (^WebViewimageArrayHandler) (NSArray *);

/** 获取网页点击图片回调 */
@property (nonatomic, copy) void (^WebViewimageURLHandler) (NSString *);


/** 网页加载 */
- (void)loadURL:(NSString *)html;



@end
