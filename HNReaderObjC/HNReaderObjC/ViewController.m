//
//  ViewController.m
//  HNReaderObjC
//
//  Created by Gorceag Olga on 11/11/16.
//  Copyright © 2016 Gorceag Olga. All rights reserved.
//

#import "ViewController.h"
#import "StoryTableViewCell.h"
#import "ReloadDataProtocol.h"
#import "ModelController.h"
#import "Story.h"
#import "DateTools.h"
#import "WebViewController.h"
#import "UIScrollView+ScrollToBottom.h"

NSString *const errorTitleString = @"Error!";
NSString *const cellIdentifier = @"Cell";
NSString *const scoreFormatString = @"Score: %@";
NSString *const commentsFormatString = @"Comments: %@";
NSString *const oneStorySegueIdentifier = @"OneStorySegueIdentifier";
NSString *const okActionTitle = @"OK";

@interface ViewController () <NSURLConnectionDelegate, UITableViewDelegate, UITableViewDataSource, ReloadDataProtocol>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) ModelController *modelController;

@property (nonatomic, strong) NSArray *storiesArray;

@end

@implementation ViewController

#pragma mark - Init

- (ModelController *)modelController {
    if (!_modelController) {
        _modelController = [[ModelController alloc] init];
    }
    return _modelController;
}

#pragma mark - Lifecycle

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    self.modelController.delegate = self;

    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - UITableView Delegate and Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.storiesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    Story *story = self.storiesArray[indexPath.row];
    cell.titleLabel.text = story.title;
    cell.userNameLabel.text = story.author;
    cell.scoreLabel.text = [NSString stringWithFormat:scoreFormatString,story.score];
    cell.commentsCountLabel.text = [NSString stringWithFormat:commentsFormatString, story.commentsCount];
    cell.timeLabel.text = [NSDate dateWithTimeIntervalSince1970:[(story.timeStamp) integerValue]].timeAgoSinceNow;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:oneStorySegueIdentifier sender:indexPath];
}

#pragma mark - Show Alert

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:okActionTitle style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView scrolledToBottomWithBuffer:scrollView.contentOffset :scrollView.contentSize :scrollView.contentInset :scrollView.bounds]) {
        [self.modelController fetchNextPage];
        if (self.modelController.isLoading) {
            self.tableView.tableFooterView.hidden = NO;
        } else {
            self.tableView.tableFooterView.hidden = YES;
        }
    }
}

#pragma mark - ReloadDataProcol

- (void)dataLoaded:(NSArray *)data {
    self.storiesArray = data;

    if (self.modelController.isLoading) {
        self.tableView.tableFooterView.hidden = NO;
    } else {
        self.tableView.tableFooterView.hidden =YES;
    }

    if ([self.tableView scrolledToBottomWithBuffer:self.tableView.contentOffset :self.tableView.contentSize :self.tableView.contentInset :self.tableView.bounds]) {
        [self.tableView reloadData];
    }
}

- (void)recievedError:(NSString *)errordescription {
    [self showAlertWithTitle:errorTitleString message:errordescription];
}

#pragma mark - Navigation 

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:oneStorySegueIdentifier]) {
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        Story *story = self.storiesArray[indexPath.row];
        WebViewController *viewController = (WebViewController *)segue.destinationViewController;
        [viewController setUrlString:story.link];
    }
}

@end
