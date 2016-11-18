//
//  WebViewController.m
//  HNReaderObjC
//
//  Created by Gorceag Olga on 14/11/16.
//  Copyright © 2016 Gorceag Olga. All rights reserved.
//

#import "WebViewController.h"

NSString *const okButtonTitle = @"OK";

@interface WebViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) NSString *urlString;

@end

@implementation WebViewController

- (void)setUrlString:(NSString *)urlString {
    _urlString = urlString;
}

- (void)viewDidAppear:(BOOL)animated {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    [self.webView loadRequest:request];
}

#pragma mark - WebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.activityIndicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:okButtonTitle style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
