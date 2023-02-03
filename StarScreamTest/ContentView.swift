//
//  ContentView.swift
//  StarScreamTest
//
//  Created by 신상원 on 2023/02/03.
//

import SwiftUI

struct ContentView: View {
  let socketManager = SocketManager.shared

  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundColor(.accentColor)
      Text("Hello, world!")
    }
    .padding()
    .onAppear { socketManager.connect() }
  }
}

final class ContentViewModel: ObservableObject {
  let socketManager = SocketManager.shared
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
