//
//  ComicLoader.swift
//  xkcd-viewer
//
//  Created by Alexander Kassouni on 5/20/20.
//  Copyright © 2020 kassouni. All rights reserved.
//

import Foundation
import SwiftUI
import Combine


class ComicLoader : ObservableObject {
    @Published var comic: Comic?
    private let url: URL
    
    private var cancellable: AnyCancellable?
    
    // load the most recent comic
    init() {
        self.url = URL(string: "http://xkcd.com/info.0.json")!
    }
    
    // load the comic by number
    init(num: Int) {
        self.url = URL(string: "http://xkcd.com/\(num)/info.0.json")!
    }
    
    func load() {
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
        .tryMap() { element -> Data in
            guard let httpResponse = element.response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
            return element.data
            }
        .decode(type: Comic.self, decoder: JSONDecoder())
        .sink(receiveCompletion: {print ("Received completion: \($0).")}, receiveValue: {comic in self.comic = comic})
    }
    
    func cancel() {
        cancellable?.cancel()
    }
    
    deinit {
        cancel()
    }
    
}

