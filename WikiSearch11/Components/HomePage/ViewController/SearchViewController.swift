//
//  SearchViewController.swift
//  WikiSearch11
//
//  Created by Priya Srivastava on 18/01/21.
//  Copyright © 2021 Priya Srivastava. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    //MARK:- Outlet Properties
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var resultsRequiredLabel: UILabel!
    @IBOutlet weak var resultsTextfield: UITextField!
    
    var viewModel = SearchViewModel()
    
    //MARK:- View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    //MARK:- Set up UI
    func setUpUI() {
        title = viewModel.getTitleText()
        searchBar.delegate = self
        setUpSearchBar()
        setUpSearchBarViewUI()
        setUpResultsRequiredTextField()
        resultsRequiredLabel.text = viewModel.getLabelText()
    }
    
    ///set Up Results Required TextField
    func setUpResultsRequiredTextField() {
        resultsTextfield.keyboardType = .numberPad
        //toolbar for textfield
        let keypadToolbar: UIToolbar = UIToolbar()
        let doneButton = UIBarButtonItem(title: viewModel.getDoneKeyBoardText(), style: UIBarButtonItem.Style.done, target: resultsTextfield, action: #selector(resultsTextfield.resignFirstResponder))
        doneButton.setTitleTextAttributes([ NSAttributedString.Key.foregroundColor : viewModel.getSearchButtonBackground()
        ], for: .normal)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: searchBar, action: #selector(resultsTextfield.resignFirstResponder));
        keypadToolbar.items = [flexibleSpace, doneButton]
        keypadToolbar.tintColor = UIColor.lightGray
        keypadToolbar.sizeToFit()
        
        resultsTextfield.inputAccessoryView = IS_IPAD ? nil : keypadToolbar
    }
    
    /// set Up Search Bar View UI
    func setUpSearchBarViewUI() {
        searchBar.placeholder = viewModel.getPlaceHolderText()
        searchBar.backgroundImage = UIImage()
        //Tool bar for search bar
        let keypadToolbar: UIToolbar = UIToolbar()
        let doneButton = UIBarButtonItem(title: viewModel.getDoneKeyBoardText(), style: UIBarButtonItem.Style.done, target: searchBar, action: #selector(searchBar.resignFirstResponder))
        doneButton.setTitleTextAttributes([ NSAttributedString.Key.foregroundColor : viewModel.getSearchButtonBackground()
        ], for: .normal)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: searchBar, action: #selector(searchBar.resignFirstResponder));
        keypadToolbar.items = [flexibleSpace, doneButton]
        keypadToolbar.tintColor = UIColor.lightGray
        keypadToolbar.sizeToFit()
        searchBar.inputAccessoryView = IS_IPAD ? nil : keypadToolbar
    }
    
    // set Up Search Bar
    func setUpSearchBar() {
        searchButton.setAttributedTitle(viewModel.getSearchButtonText(), for: .normal)
        searchButton.backgroundColor = viewModel.getSearchButtonBackground()
    }
    
    //MARK:- Search Button IBAction methods
    @IBAction func searchClicked(_ sender: UIButton) {
        //Naviagtes to next screen to show search results
        if let searchString = searchBar.text,let resultsString = resultsTextfield.text, let viewController = SearchResultsTableViewController.getComponentViewController() as? SearchResultsTableViewController {
            viewController.searchedString = searchString
            viewController.resultsRequired = resultsString
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

//MARK:- UISearchBarDelegate methods
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
