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
  @State private var usersSearch: [User]?
  let api = Api.instance
  
  var body: some View {
    List {
      if (usersSearch != nil) {
        ForEach(usersSearch!, id: \.login) { user in
          NavigationLink(destination: UserDetail(id: user.id)) {
            WebImage(url: URL(string: "\(FT_BASE_URL_PIC)/small_\(user.login).jpg"))
            .resizable()
            .placeholder {Rectangle().foregroundColor(.gray)}
            .indicator(.activity)
            .scaledToFit()
            .frame(width: 50, height: 50)
            Text("\(user.login) - \(user.id)")
          }.navigationBarTitle(user.login)
        }
      } else {
        // todo: loader
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
