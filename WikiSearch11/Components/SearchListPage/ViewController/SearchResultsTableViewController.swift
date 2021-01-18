//
//  SearchResultsTableViewController.swift
//  WikiSearch11
//
//  Created by Priya Srivastava on 18/01/21.
//  Copyright © 2021 Priya Srivastava. All rights reserved.
//

import UIKit

class SearchResultsTableViewController: UIViewController {
    
    //MARK:- Properties
    @IBOutlet weak var tableView: UITableView!
    
    var searchedString : String = ""
    var resultsRequired: String = ""
    var viewModel: SearchListViewModel?
    var apiInterface = SearchAPIWorker()
    
    //MARK: Navigator
    static func getComponentViewController() -> UIViewController {
        return UIViewController.getViewControllerWith(storyBoardID: WikiConstants.StoryBoardIDs.SearchList, ViewControllerID: WikiConstants.ViewControllerIds.SearchResultsTableViewController)
    }
    
    //MARK:- ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        loadData()
        setUpTableView()
    }
    
    ///set Up UI
    func setUpUI() {
        title = searchedString
    }
    
    ///set Up TableView
    func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    //MARK:- FETCH DATA
    func loadData() {
        self.view.showLoader()
        apiInterface.loadSearchResultsInfo(body: searchedString,productCount: resultsRequired, success:  { [weak self](successResponse) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.view.dismissloader()
            strongSelf.viewModel = SearchListViewModel()
            let searchResultsResponse = successResponse
            if let searchQuery = searchResultsResponse.query?.pages, searchQuery.count > 0 {
                strongSelf.viewModel?.setDataSource(response: searchResultsResponse)
                DispatchQueue.main.async {
                    strongSelf.tableView.reloadData()
                }
            } else {
                strongSelf.noProductSearched()
            }
        }, failure: {
            [weak self](error) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.view.dismissloader()
            strongSelf.showError(withError: error)
        })
    }
    
    ///Show error in case of no product found
    func noProductSearched() {
        let alertAction1 = UIAlertAction(title: "Retry", style: .default) { [weak self](_) in
            self?.loadData()
        }
        let alertAction2 = UIAlertAction(title: "Search Again", style: .destructive) { [weak self](_) in
            self?.navigationController?.popViewController(animated: true)
        }
        UIAlertController.showAlert(in: self, title: "Oops!!", message: "We found no search result matching with your request", actions: [alertAction1, alertAction2])
    }
    
    ///Show error in case of api fail
    func showError(withError error: Error?) {
        let alertAction1 = UIAlertAction(title: "Retry", style: .default) { [weak self](_) in
            self?.loadData()
        }
        let alertAction2 = UIAlertAction(title: "Go Back", style: .destructive) { [weak self](_) in
            self?.navigationController?.popViewController(animated: true)
        }
        UIAlertController.showAlert(in: self, title: "Error!!", message: error?.localizedDescription ?? "", actions: [alertAction1, alertAction2])
    }
    
}

//MARK:- Tableview methods
extension SearchResultsTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let viewModel = viewModel {
            return viewModel.getNumberOfRows()
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: WikiConstants.ReuseIdentifiers.SearchResultsCell, for: indexPath) as? SearchResultsTableViewCell {
            if let viewModel = viewModel {
                cell.updateCellView(details: viewModel.getDetails(forRow : indexPath.row))
                return cell
            }
        }
        return UITableViewCell(style: .default, reuseIdentifier: "default")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let viewModel = viewModel {
            return viewModel.getCellHeight()  // have fixed height for 1 line of title and one line of description
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewModel = viewModel, let viewController = SearchViewViewController.getComponentViewController() as? SearchViewViewController {
            viewController.pageId = viewModel.getPageId(forRow: indexPath.row)
            viewController.title = viewModel.getRowTitle(forRow: indexPath.row)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
