//
//  ContentView.swift
//  swifty_companion
//
//  Created by owalid on 15/11/2020.
//  Copyright © 2020 owalid. All rights reserved.
//

import SwiftUI

struct ContentView: View {
  @State private var login: String = ""
  
  var body: some View {
    
    VStack(alignment: .center) {
     
      NavigationView {
          VStack {
            TextField("Login", text: $login)
                   .textFieldStyle(RoundedBorderTextFieldStyle())
            NavigationLink(destination: UserView(login: self.$login)) {
                  Text("Show Detail View")
                  .foregroundColor(.purple)
                  .font(.body)
                  .padding(5)
                  .border(Color.purple, width: 2)
              }.navigationBarTitle("Recherche")
          }
      }
//      NavigationLink(destination: UserView()) {
//        Text("Awesome Button")
//                           .frame(minWidth: 0, maxWidth: 300)
//                           .padding()
//                           .foregroundColor(.white)
//                           .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .leading, endPoint: .trailing))
//                           .cornerRadius(40)
//                           .font(.title)
//      }
//       Button(action: {
//           self.name = "Hello text"
//       }) {
//         Text("Rechercher")
//           .foregroundColor(.purple)
//          .font(.body)
//          .padding(5)
//          .border(Color.purple, width: 2)
//       }
    }.padding()
    
//    VStack {
//       TextField("Enter your name", text: $name)
//       Text("Hello, \(name)!")
//     }
  
//    Button(action: {
//      print("hello world")
//    }) {
//      Text("Rechercher")
//        .foregroundColor(.purple)
//        .font(.title)
//        .padding(5)
//        .border(Color.purple, width: 2)
//    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

