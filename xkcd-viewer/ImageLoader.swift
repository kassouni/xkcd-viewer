//
//  ImageLoader.swift
//  xkcd-viewer
//
//  Created by Alexander Kassouni on 5/20/20.
//  Copyright © 2020 kassouni. All rights reserved.
//

import Foundation
import SwiftUI
import Combine


// adapted from https://www.vadimbulavin.com/asynchronous-swiftui-image-loading-from-url-with-combine-and-swift/
class ImageLoader : ObservableObject {
    @Published var image: NSImage?
    private let url: URL
    
    private var cancellable: AnyCancellable?
    
    init(url: URL) {
        self.url = url
    }
    
    deinit {
        cancel()
    }
    
    func load() {
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map {NSImage(data: $0.data)}
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on:self)
    }
    
    func cancel() {
        cancellable?.cancel()
    }
}
