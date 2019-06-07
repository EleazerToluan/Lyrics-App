//
//  Lyric.swift
//  Lyrics App
//
//  Created by Eleazer Toluan on 07/06/2019.
//  Copyright © 2019 Eleazer Toluan. All rights reserved.
//

import Foundation

class Lyric {
   var id: String!
   var title: String!
   var artist: String!
   var content: String?
   var shared_by: String?
   
   init(){}

   init(id: String, title: String, artist: String?, shared_by: String?){
      self.id = id
      self.title = title
      self.artist = artist
      self.shared_by = shared_by
   }
}
