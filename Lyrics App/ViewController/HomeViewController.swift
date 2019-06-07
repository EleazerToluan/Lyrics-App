//
//  ViewController.swift
//  Lyrics App
//
//  Created by Eleazer Toluan on 06/06/2019.
//  Copyright © 2019 Eleazer Toluan. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
   
   @IBOutlet weak var titleLabel: UILabel!
   @IBOutlet weak var artistLabel: UILabel!
}

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
   

   @IBOutlet weak var searchBar: UISearchBar!
   @IBOutlet weak var tableView: UITableView!
   
   var viewState = ViewState.loading
   
   var viewModel: HomeViewModel!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      viewModel = HomeViewModel(delegate: self, repository: Repository.shared)
      viewModel.loadDefaultLyrics()
      
      tableView.tableFooterView = UIView()
      searchBar.delegate = self
      
   }
   
   func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
      searchBar.showsCancelButton = true
   }
   
   func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
      searchBar.showsCancelButton = false
   }
   
   func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
      searchBar.showsCancelButton = false
      searchBar.resignFirstResponder()
      
      searchBar.text = ""
      viewModel.isSearching = false
      viewModel.searchLyrics.removeAll(keepingCapacity: false)
      tableView.reloadData()
   }
   
   func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      viewModel.searchLyrics(query: searchText)
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      if viewModel.isSearching {
         return viewModel.searchLyrics.count
      } else {
         return viewModel.lyrics.count
      }
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
      
      cell.titleLabel.text = viewModel.getTitleOf(index: indexPath.row)
      cell.artistLabel.text = viewModel.getArtistOf(index: indexPath.row)
      return cell
   }
   
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 65
   }
   
   @IBAction func onSort(_ sender: Any) {
      let alert = UIAlertController(title: "Sort by:", message: nil, preferredStyle: .actionSheet)
      alert.addAction(UIAlertAction(title: "Title", style: .default, handler: { (_) in
         self.viewModel.sortLyricsBy(sort: .title)
      }))
      alert.addAction(UIAlertAction(title: "Artist", style: .default, handler: { (_) in
         self.viewModel.sortLyricsBy(sort: .artist)
      }))
      alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
         alert.dismiss(animated: true, completion: nil)
      }))
      present(alert, animated: true, completion: nil)
   }
}

extension HomeViewController: HomeViewModelDelegate {
   
   func homeViewModelDelegate(delegate: HomeViewModelDelegate, viewState: ViewState, message: String?) {
      self.viewState = viewState
      
      switch viewState {
      case .loading:
       
         break
      case .success:
         
         tableView.reloadData()
         break
      case .failed:
         
         break
      }
   }
}

