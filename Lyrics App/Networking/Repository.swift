//
//  Repository.swift
//  Lyrics App
//
//  Created by Eleazer Toluan on 07/06/2019.
//  Copyright © 2019 Eleazer Toluan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Repository {
   static let shared: Repository! = Repository()
   
   let url = elastic_server_url + "elasticsearch/lyrics/title_artist/_search?"
   let filterQuery = "pretty&filter_path=hits.hits._id,hits.hits._source&default_operator=AND"
   
   let credential = URLCredential(user: elasticSearchUser, password: elasticSearchPassword, persistence: .forSession)
   
   func search(query: String, size: Int, completion: @escaping (_ lyrics: [Lyric]?)->Void){
      
      let q = query.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
      let url = self.url + filterQuery + "&q=\(q)&size=\(size)"
      
      Alamofire.request(url)
         .authenticate(usingCredential: credential)
         .validate()
         .responseJSON{ response in
            
            switch response.result {
            case .success:
               let data = JSON(response.result.value!)
               completion(self.parseLyrics(data: data))
            case .failure( _):
               completion(nil)
            }
      }
   }
   
   func parseLyrics(data:JSON) -> [Lyric]? {
      var record = [Lyric]()
      let hits = data["hits"]["hits"].array
      
      hits?.forEach { (hitsJSON) -> () in
         var shared_by: String? = hitsJSON["_source"]["shared_by"].stringValue
         
         if let id = shared_by {
            if id.isEmpty {
               shared_by = nil
            }
         }
         
         record.append(Lyric(
            id: hitsJSON["_id"].stringValue,
            title: hitsJSON["_source"]["title"].stringValue ,
            artist: hitsJSON["_source"]["artist"].stringValue,
            shared_by: shared_by)
         )
      }
      
      if record.count == 0 {
         return nil
      }
      
      return record
   }
}
