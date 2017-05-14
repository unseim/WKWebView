//  WebView
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "WebViewController.h"
#import "WebTableViewCell.h"

@interface WebViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

static NSString *const cellIdentifier = @"cell";
@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        WebTableViewCell *cell = [WebTableViewCell initWithTableView:tableView];
        [cell loadURL:@"http://jydl.s1.natapp.cc/public/moblie/Index/getxdesc/8"];
        
        //  计算网页高度 刷新cell
        __weak typeof(self) weakSelf = self;
        [cell setWebViewHeightHandler:^(CGFloat height) {
            NSLog(@"WebHeight  =  %lg", height);
            [weakSelf.tableView reloadData];
        }];
        
        //  获取网页图片数组
        [cell setWebViewimageArrayHandler:^(NSArray *images) {
            NSLog(@"图片数组 = %@", images);
            
        }];
        
        //  获取点击的图片链接
        [cell setWebViewimageURLHandler:^(NSString *url) {
            NSLog(@"imageURL = %@", url);
            
        }];
        
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld行数据",indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.preservesSuperviewLayoutMargins = NO;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.separatorInset = UIEdgeInsetsZero;
}

#pragma mark - Lazy
- (UITableView *)tableView {
    if(_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 44.0f;
        _tableView.tableFooterView = [UIView new];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
    }
    return _tableView;
}

@end
