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
  @State var isActive : Bool = false
  @State private var login: String = ""
  @State private var startingWebAuthenticationSession = false
  @State private var isConnectedScope = false
  var urlAuthorize = "\(FT_URL_API)?client_id=\(FT_CONSUMER_KEY)&client_secret=\(FT_CONSUMER_SECRET)&redirect_uri=\(FT_URL_SCHEME)&response_type=code"
  @ObservedObject var api = Api.instance

  var body: some View {
    if (api.accessToken == nil || api.createdAt == nil || api.expiresIn == nil) {
      Button("Connection OAuth42") {
        self.startingWebAuthenticationSession = true
        }
        .webAuthenticationSession(isPresented: $startingWebAuthenticationSession) {
          WebAuthenticationSession(
          url: URL(string: urlAuthorize)!,
          callbackURLScheme: FT_URL_SCHEME.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        ) { callbackURL, error in
            if callbackURL != nil && error == nil{
              let code = (callbackURL!).valueOf("code")
              api.requestToken(code: code!)
            }
          }
      }
      .foregroundColor(Color.white)
      .frame(width: 200, height: 35, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
      .background(Color.blue)
      .cornerRadius(10)
    } else {
  
    VStack(alignment: .center) {
      NavigationView {
          VStack {
            HStack {
              Image(systemName: "magnifyingglass").foregroundColor(.gray)
              TextField("Login", text: $login)
            }
            .padding()
            .background(Capsule().fill(Color.white))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))

            if login != "" {
              NavigationLink(destination: UserView(login: self.$login, rootIsActive: self.$isActive), isActive: self.$isActive) {
                Text("Rechercher")
                  .foregroundColor(Color.white)
                  .frame(width: 110, height: 35, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                  .background(Color.blue)
                  .cornerRadius(10)
              }.navigationBarTitle("Recherche")
          }
          }.padding()
      }.edgesIgnoringSafeArea(.top)
    }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

