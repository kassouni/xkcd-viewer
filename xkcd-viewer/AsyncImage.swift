//
//  AsyncImage.swift
//  xkcd-viewer
//

import SwiftUI

public extension View {
    func toolTip(_ toolTip: String) -> some View {
            self.overlay(TooltipView(toolTip))
    }
}

private struct TooltipView: NSViewRepresentable {
    let toolTip: String

    init(_ toolTip: String?) {
        if let toolTip = toolTip {
            self.toolTip = toolTip
        }
        else
        {
            self.toolTip = ""
        }
    }

    func makeNSView(context: NSViewRepresentableContext<TooltipView>) -> NSView {
        NSView()
    }

    func updateNSView(_ nsView: NSView, context: NSViewRepresentableContext<TooltipView>) {
        nsView.toolTip = self.toolTip
    }
}

// adapted from https://www.vadimbulavin.com/asynchronous-swiftui-image-loading-from-url-with-combine-and-swift/
struct AsyncImage<Placeholder: View>: View {
    
    @ObservedObject private var loader: ComicImageLoader
    private let placeholder: Placeholder?
    
    init(loader:ComicImageLoader, placeholder: Placeholder? = nil) {
        self.placeholder = placeholder
        self.loader = loader
    }
    
    var body: some View {
        image
            .onAppear(perform: loader.load)
            .onDisappear(perform: loader.cancel)
    }
    
     private var image: some View {
           Group {
               if loader.image != nil {
                VStack{
                    Text(loader.comic!.title)
                    Image(nsImage: loader.image!)
                        .resizable()
                    .toolTip(loader.comic!.altText)
                    
                }
                
               } else {
                   placeholder
               }
            }
       }
}
