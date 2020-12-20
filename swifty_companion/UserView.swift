//
//  UserView.swift
//  swifty_companion
//
//  Created by owalid on 15/11/2020.
//  Copyright © 2020 owalid. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI


struct UserView: View {
  @Binding var login: String
  @Binding var rootIsActive : Bool
  
  @State var usersSearch: [User]?
  @State var isFinished = false
  @State var page = 0
  @State var redirectHomeView = false
  
  let api = Api.instance
  
  var body: some View {
    List {
      if usersSearch != nil {
        ForEach(usersSearch!, id: \.login) { user in
          NavigationLink(destination: UserDetail(id: user.id)) {
            WebImage(url: URL(string: "\(FT_BASE_URL_PIC)/small_\(user.login).jpg"))
            .resizable()
            .placeholder {Rectangle().foregroundColor(.gray)}
            .indicator(.activity)
            .scaledToFit()
            .frame(width: 50, height: 50)
            Text("\(user.login) - \(user.id)").onAppear {
              if self.usersSearch!.last == user && !isFinished {
                self.page += 1
                self.api.searchUser(login: login, page: page) {response, error in
                  if response?.count == 0 {
                    print("wesh alors")
                    self.isFinished = true
                  }
                  self.usersSearch! += response!
                }
              }
          }
          }.navigationBarTitle(user.login)
        }
      } else {
        // todo: loader
       }
    }.onAppear {
      self.api.searchUser(login: login, page: page) {response, error in
        if response == nil {
          print("isActive \(rootIsActive) ??")
          self.rootIsActive = false
        } else {
          self.usersSearch = response
        }
      }
    }
//    NavigationView {
//    NavigationLink(destination: ContentView(), isActive: $redirectHomeView) {
//      EmptyView()
//     }.hidden()
//    }
  }
}

//struct UserView_Previews: PreviewProvider {
//
//    static var previews: some View {
//      @Binding var login: String
//      UserView(login)
//    }
//}
