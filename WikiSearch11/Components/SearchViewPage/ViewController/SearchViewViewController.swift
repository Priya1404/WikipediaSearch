//
//  SearchViewViewController.swift
//  WikiSearch11
//
//  Created by Priya Srivastava on 18/01/21.
//  Copyright © 2021 Priya Srivastava. All rights reserved.
//

import UIKit
import WebKit

class SearchViewViewController: UIViewController {
    
    //MARK:- Properies
    var wkWebView: WKWebView!
    var pageId: Int?
    var request: URLRequest?
    var viewModel: SearchViewViewModel?
    var apiInterface = SearchViewWorker()
    
    //MARK:- Navigator
    static func getComponentViewController() -> UIViewController {
        return UIViewController.getViewControllerWith(storyBoardID: WikiConstants.StoryBoardIDs.SearchView, ViewControllerID: WikiConstants.ViewControllerIds.SearchViewViewController)
    }
    
    //MARK:- View Controller lifecycle
    override func loadView() {
        super.loadView()
        let webConfiguration = WKWebViewConfiguration()
        wkWebView = WKWebView(frame: .zero, configuration: webConfiguration)
        wkWebView.uiDelegate = self
        wkWebView.navigationDelegate = self
        view = wkWebView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wkWebView.uiDelegate = self
        wkWebView.navigationDelegate = self
        loadData()
        if let request = request {
            wkWebView.load(request)
        }
    }
    
    //MARK:- Fetch data
    func loadData() {
        self.view.showLoader()
        if let pageId = pageId {
            apiInterface.loadSearchViewInfo(pageId: pageId, success:  { [weak self](successResponse) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.view.dismissloader()
                strongSelf.viewModel = SearchViewViewModel()
                let searchViewResponse = successResponse
                strongSelf.viewModel?.setDataSource(response: searchViewResponse, pageId: pageId)
                DispatchQueue.main.async {
                    if let viewModel = self?.viewModel, let url = URL(string: viewModel.getSearchURL()) {
                        self?.wkWebView.load(URLRequest(url: url) )
                    }
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

extension SearchViewViewController : WKNavigationDelegate, WKUIDelegate {
    /// web view loader is called
    ///
    /// - Parameter webView:
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.view.dismissloader()
        self.view.showLoader()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.view.dismissloader()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
}
