//
//  ContentView.swift
//  swifty_companion
//
//  Created by owalid on 15/11/2020.
//  Copyright © 2020 owalid. All rights reserved.
//

import SwiftUI
import BetterSafariView

struct ContentView: View {
  @State private var login: String = ""
  @State private var startingWebAuthenticationSession = false
  var urlAuthorize = "\(FT_URL_API)?client_id=\(FT_CONSUMER_KEY)&client_secret=\(FT_CONSUMER_SECRET)&redirect_uri=\(FT_URL_SCHEME)&response_type=code"

  var body: some View {
    
    VStack(alignment: .center) {
      if !self.startingWebAuthenticationSession {
        Button("Start WebAuthenticationSession") {
          self.startingWebAuthenticationSession = true
          }
          .webAuthenticationSession(isPresented: $startingWebAuthenticationSession) {
            WebAuthenticationSession(
            url: URL(string: urlAuthorize)!,
            callbackURLScheme: FT_URL_SCHEME.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
          ) { callbackURL, error in
              print(callbackURL, error)
            }
        }
      }
      NavigationView {
          VStack {
            TextField("Login", text: $login)
                   .textFieldStyle(RoundedBorderTextFieldStyle())
            NavigationLink(destination: UserView(login: self.$login)) {
                  Text("Recchercher")
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

