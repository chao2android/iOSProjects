#import "DWUploadViewController.h"
#import "DWUploadTableViewCell.h"
#import "DWUploadItem.h"
#import "DWTools.h"
#import "AutoAlertView.h"

#import <MobileCoreServices/MobileCoreServices.h>
#include<AssetsLibrary/AssetsLibrary.h>
#import "VideoUploadManager.h"

@interface DWUploadViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation DWUploadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"发布";
    [self AddLeftImageBtn:[UIImage imageNamed:@"f_btnback"] target:self action:@selector(GoBack)];
    

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 96;
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [kVideoUpload.uploadItems.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"DWUploadViewCorollerCellId";
    
    DWUploadTableViewCell *cell = (DWUploadTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil){
        cell = [[DWUploadTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [cell.statusButton addTarget:self action:@selector(videoUploadStatusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.statusButton.tag = indexPath.row;
    }
    
    DWUploadItem *item = kVideoUpload.uploadItems.items[indexPath.row];
    [cell setupCell:item];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSLog(@"deleted item: %@", kVideoUpload.uploadItems.items[indexPath.row]);
        [kVideoUpload.uploadItems removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - UITableViewDelegate

#pragma mark - upload

- (void)videoUploadStatusButtonAction:(UIButton *)button
{
    DWUploadTableViewCell* cell = nil;
    
    NSInteger indexPath = button.tag;
    NSIndexPath *index = [NSIndexPath indexPathForRow:indexPath inSection:0];
    cell = (DWUploadTableViewCell *)[self.tableView cellForRowAtIndexPath:index];
    
    DWUploadItem *item = [kVideoUpload.uploadItems.items objectAtIndex:indexPath];
    
    switch (item.videoUploadStatus) {
        case DWUploadStatusWait:
            // 状态转为 开始上传
            if (kVideoUpload.uploadItems.isBusy) {
                break;
            }
            kVideoUpload.uploadItems.isBusy = YES;
            
            [kVideoUpload videoUploadStartWithItem:item];
            break;
            
        case DWUploadStatusStart:
            // 状态转为 暂停上传
            kVideoUpload.uploadItems.isBusy = NO;
            [kVideoUpload videoUploadPauseWithItem:item];
            break;
            
        case DWUploadStatusUploading:
            // 状态转为 暂停上传
            kVideoUpload.uploadItems.isBusy = NO;
            [kVideoUpload videoUploadPauseWithItem:item];
            break;
            
        case DWUploadStatusPause:
            // 状态转为 开始上传
            if (kVideoUpload.uploadItems.isBusy) {
                break;
            }
            kVideoUpload.uploadItems.isBusy = YES;
            
            [kVideoUpload videoUploadResumeWithItem:item];
            break;
            
        case DWUploadStatusResume:
            // 状态转为 暂停上传
            kVideoUpload.uploadItems.isBusy = NO;
            [kVideoUpload videoUploadPauseWithItem:item];
            break;
            
        case DWUploadStatusLoadLocalFileInvalid:
            // 报警 告知用户 "本地文件不存在，删除任务重新添加文件"
            kVideoUpload.uploadItems.isBusy = NO;
            [AutoAlertView ShowAlert:@"提示" message:@"本地文件不存在，删除任务重新添加文件"];
            break;
            
        case DWUploadStatusFail:
            // 状态转为 继续上传
            if (kVideoUpload.uploadItems.isBusy) {
                break;
            }
            kVideoUpload.uploadItems.isBusy = YES;
            [kVideoUpload videoUploadResumeWithItem:item];
            break;
            
        case DWUploadStatusFinish:
            // 在 DWUploadStatusStart 和 DWUploadStatusResume 状态中
            // 如果上传完成，则至 cell.statusButton.userInteractionEnabled = NO 不在接收交互事件。
            // 所以这里不需要做处理。
            break;
            
        default:
            break;
    }
}

@end
