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
  let api = Api.instance

  var body: some View {
//    if (Api.instance.accessToken == nil || Api.instance.createdAt == nil || Api.instance.expiresIn == nil) {
      Button("Connection OAuth42") {
        self.startingWebAuthenticationSession = true
        }
        .webAuthenticationSession(isPresented: $startingWebAuthenticationSession) {
          WebAuthenticationSession(
          url: URL(string: urlAuthorize)!,
          callbackURLScheme: FT_URL_SCHEME.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        ) { callbackURL, error in
            let code = (callbackURL!).valueOf("code")
            api.requestToken(code: code!)
          }
      }
//    } else {
      

    VStack(alignment: .center) {
      NavigationView {
          VStack {
            TextField("Login", text: $login)
              .textFieldStyle(RoundedBorderTextFieldStyle())
            NavigationLink(destination: UserView(login: self.$login)) {
              Text("Rechercher")
                .foregroundColor(.purple)
                .font(.body)
                .padding(5)
                .border(Color.purple, width: 2)
          }.navigationBarTitle("Recherche")
        }
      }
    }.padding()
//    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

