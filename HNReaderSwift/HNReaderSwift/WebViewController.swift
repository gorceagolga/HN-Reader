//
//  WebViewController.swift
//  HNReaderSwift
//
//  Created by Gorceag Olga on 16/11/16.
//  Copyright © 2016 Gorceag Olga. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    let loadRequesedPageErrorMessageString = "Error loading the requested page."
    let okActionTitleString = "OK"

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var urlString: String?

    override func viewDidAppear(_ animated: Bool) {
        if urlString != nil {
            let request = URLRequest.init(url: URL.init(string: urlString!)!)
            webView.loadRequest(request)
        } else {
            showAlert()
        }
    }

    // MARK: Show alert
    func showAlert() {
        let alertController = UIAlertController(title: nil, message:loadRequesedPageErrorMessageString, preferredStyle: .alert)

        let defaultAction = UIAlertAction(title: okActionTitleString, style: .default, handler: nil)
        alertController.addAction(defaultAction)

        present(alertController, animated: true, completion: nil)
    }
}

// MARK: WebVIewDelegate

extension WebViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.activityIndicator.stopAnimating()
    }

    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        showAlert()
    }
}
