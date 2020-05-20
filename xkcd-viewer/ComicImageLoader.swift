//
//  ImageLoader.swift
//  xkcd-viewer
//

import Foundation
import SwiftUI
import Combine


struct Comic: Codable {
    var num: Int
    var title: String
    var altText: String
    var imgURL: String
    
    private enum CodingKeys: String, CodingKey {
        case num, title, altText = "alt", imgURL = "img"
    }
}

// adapted from https://www.vadimbulavin.com/asynchronous-swiftui-image-loading-from-url-with-combine-and-swift/
class ComicImageLoader : ObservableObject {
    @Published var image: NSImage?
    var comic: Comic?
    private var cancellable: AnyCancellable?
    private var endpoint: String
    
    init() {
        self.endpoint = "https://xkcd.com/info.0.json"
    }
    
    init(num: Int) {
        self.endpoint = "https://xkcd.com/\(num)/info.0.json"
    }
    
    deinit {
        cancel()
    }
    
    func load() {
        // the endpoint url must be a well formed string
        let url = URL(string: endpoint)!
        _ = URLSession.shared.dataTask(with: url) {
            data, response, error in
            // todo: error checking
            let decoder = JSONDecoder()
            
            self.comic = try! decoder.decode(Comic.self, from: data!)
            
            self.cancellable = URLSession.shared.dataTaskPublisher(for: URL(string: self.comic!.imgURL)!)
                .map {NSImage(data: $0.data)}
                .replaceError(with: nil)
                .receive(on: DispatchQueue.main)
                .assign(to: \.image, on:self)
        }.resume()
    }
    
    func cancel() {
        cancellable?.cancel()
    }
}
