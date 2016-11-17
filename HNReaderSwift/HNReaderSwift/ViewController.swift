//
//  ViewController.swift
//  HNReaderSwift
//
//  Created by Gorceag Olga on 16/11/16.
//  Copyright © 2016 Gorceag Olga. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let oneStorySegueIdentifier = "OneStorySegueIdentifier"
    let storyTableViewCellIdentifier = "StoryTableViewCell"

    let alertTitleString = "Oops!"
    let alertMessageString = "Looks like this story does not have a linked webpage."
    let loadingDataErrorTitleString = "Error loading data."
    let scoreLabelString = "Score: "
    let commentsLabelString = "Comments: "
    let okActionTitleString = "OK"


    lazy var modelController: ModelController = {
        let tempModelController = ModelController.init()
        return tempModelController
    }()

    var storiesArray = Array<Story>()

    @IBOutlet weak var tableView: UITableView!

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        modelController.delegate = self;
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    // MARK: Show alert method

    func showAlert(title: String?, message: String) {
        let alertController = UIAlertController(title: title ?? nil, message: message, preferredStyle: .alert)

        let defaultAction = UIAlertAction(title: okActionTitleString, style: .default, handler: nil)
        alertController.addAction(defaultAction)

        present(alertController, animated: true, completion: nil)
    }

    // MARK: Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == oneStorySegueIdentifier {
            let webViewController = segue.destination as! WebViewController
            let story = storiesArray[sender as! Int]
            webViewController.urlString = story.link
        }
    }

}

// MARK: DataLoadedProtocol

extension ViewController: DataLoadedProtocol {
    func dataLoaded(data: Array<Any>) {

        storiesArray = data as! Array<Story>
        if self.tableView.scrolledToBottom(withBuffer: tableView.contentOffset, tableView.contentSize, tableView.contentInset, tableView.bounds) {
            tableView.reloadData()
        }

    }

    func loadingFailedWithError(errorDescription: String) {
        self.showAlert(title: loadingDataErrorTitleString, message: errorDescription)
        tableView.tableFooterView?.isHidden = true;
    }
}

// MARK: TableView Datasource and Delegate

extension ViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storiesArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:StoryTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: storyTableViewCellIdentifier) as! StoryTableViewCell!

        let story = storiesArray[indexPath.row]

        cell.titleLabel?.text = story.title
        cell.userNameLabel.text = story.author
        cell.scoreLabel.text = scoreLabelString.appending("\(story.score ?? 0)")
        cell.commentsCountLabel.text = commentsLabelString.appending("\(story.commentsCount ?? 0)")
        cell.timeLabel.text = NSDate.init(timeIntervalSince1970: story.timeStamp as TimeInterval).timeAgoSinceNow()

         return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let story = storiesArray[indexPath.row]
        if story.link != nil {
            performSegue(withIdentifier: oneStorySegueIdentifier, sender: indexPath.row)
        } else {
            showAlert(title: alertTitleString, message: alertMessageString)
        }
    }
}

// MARK: UIScrollView Delegate

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView.scrolledToBottom(withBuffer: scrollView.contentOffset, scrollView.contentSize, scrollView.contentInset, scrollView.bounds) {

            modelController.fetchNextPage()

            if modelController.isLoading {
                tableView.tableFooterView?.isHidden = false;
            } else {
                tableView.tableFooterView?.isHidden = true;
            }
        }
    }
}



