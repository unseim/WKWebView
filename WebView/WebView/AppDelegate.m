//  WebView
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "AppDelegate.h"
#import "WebViewController.h"
#import "WebViewController2.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    UITabBarController *tabBarController = [[UITabBarController alloc]init];
    
    UINavigationController *webVC1 = [[UINavigationController alloc]initWithRootViewController:[WebViewController new]];
    webVC1.tabBarItem.title = @"示例1";
    
    UINavigationController *webVC2 = [[UINavigationController alloc]initWithRootViewController:[WebViewController2 new]];
    webVC2.tabBarItem.title = @"示例2";
    
    [tabBarController addChildViewController:webVC1];
    [tabBarController addChildViewController:webVC2];
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen] .bounds];
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

@end
