//
//  UserView.swift
//  swifty_companion
//
//  Created by owalid on 15/11/2020.
//  Copyright © 2020 owalid. All rights reserved.
//

import SwiftUI

struct UserView: View {
  @Binding var login: String
  @State private var usersSearch: [Api.User]?
  let api = Api.instance
  
  var body: some View {
    List {
      if (usersSearch != nil) {
        ForEach(usersSearch!, id: \.login) { user in
            Text(user.login)
        }
      }
    }.onAppear {
      self.api.searchUser(login: login) {response, error in
        self.usersSearch = response
      }
    }
  }
}

//struct UserView_Previews: PreviewProvider {
//
//    static var previews: some View {
//      @Binding var login: String
//      UserView(login)
//    }
//}
