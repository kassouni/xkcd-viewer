//
//  Comic.swift
//  xkcd-viewer
//
//  Created by Alexander Kassouni on 5/15/20.
//  Copyright © 2020 kassouni. All rights reserved.
//

import Foundation
import AppKit

class Comic {
    
    var num: Int = 0
    var title: String = ""
    var altText: String = ""
    var imgURL: String = ""
    
    // fetch comic by number
    init(number: Int) {
        let urlStr = "http://xkcd.com/" + String(number) + "/info.0.json"
        fetchDataFromURL(urlStr: urlStr)
    }
    
    // fetch most recent comic
    init () {
        fetchDataFromURL(urlStr: "https://xkcd.com/info.0.json")
    }
    
    func fetchDataFromURL(urlStr:String) {
        guard let url = URL(string:urlStr) else {
            print("failed to parse url")
            return
        }
        
        let urlReq = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: urlReq, completionHandler: { data,res,err in
            guard err == nil else {
                print("api request returned an error")
                return
            }
            
            guard let responseData = data else {
                print("data is nil")
                return
            }
                        
            do {
                guard let jsonDict = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
                    print("failed to parse json response")
                    return
                }
                
                // assign the values
                self.num = (jsonDict["num"] as? Int)!
                self.imgURL = (jsonDict["img"] as? String)!
                self.altText = (jsonDict["alt"] as? String)!
                self.title = (jsonDict["title"] as? String)!
                
            } catch {
               print("failed to parse json response")
                return
            }
        })
        task.resume()
    }
}
