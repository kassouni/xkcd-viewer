//
//  ComicView.swift
//  xkcd-viewer
//


import SwiftUI

struct ComicView: View {
    
    
    var body: some View {
        AsyncImage(
            loader: ComicImageLoader(),
            placeholder: Text("lodaing...")
        ).aspectRatio(contentMode: .fit)
    }
}

struct ComicView_Previews: PreviewProvider {
    static var previews: some View {
        Text("todo")
    }
}

