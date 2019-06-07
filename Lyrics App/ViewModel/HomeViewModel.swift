//
//  HomeViewModel.swift
//  Lyrics App
//
//  Created by Eleazer Toluan on 07/06/2019.
//  Copyright © 2019 Eleazer Toluan. All rights reserved.
//

import Foundation

protocol HomeViewModelDelegate {
   
   func homeViewModelDelegate(delegate: HomeViewModelDelegate, viewState: ViewState, message: String?)
}

class HomeViewModel {
   
   var repository: Repository!
   var delegate: HomeViewModelDelegate!
   
   var lyrics: [Lyric] = []
   var searchLyrics: [Lyric] = []
   var isSearching = false
   
   init(delegate: HomeViewModelDelegate, repository: Repository) {
      self.repository = repository
      self.delegate = delegate
   }
   
   func loadDefaultLyrics() {
      repository?.search(query: "Love", size: 10, completion: { (lyrics) in
         if let lyrics = lyrics {
            
            self.lyrics = lyrics
            self.delegate.homeViewModelDelegate(delegate: self.delegate, viewState: .success, message: nil)
         } else {
            self.delegate.homeViewModelDelegate(delegate: self.delegate, viewState: .failed, message: "No Lyrics found")
         }
      })
   }
   
   func searchLyrics(query: String) {
      isSearching = true
      
      searchLyrics = lyrics.filter({ $0.title.lowercased() == query.lowercased() })
      self.delegate.homeViewModelDelegate(delegate: self.delegate, viewState: .success, message: nil)
   }
   
   func sortLyricsBy(sort: SortLyrics){
      lyrics = lyrics.sorted(by: { (right, left) -> Bool in
         return sort == .title ? right.title < left.title : right.artist! < left.artist!
      })
      self.delegate.homeViewModelDelegate(delegate: self.delegate, viewState: .success, message: nil)
   }
   
   func getTitleOf(index: Int) -> String {
      if isSearching {
         return searchLyrics[index].title
      } else {
         return lyrics[index].title
      }
   }
   
   func getArtistOf(index: Int) -> String? {
      if isSearching {
         return searchLyrics[index].artist
      } else {
         return lyrics[index].artist
      }
   }
}
