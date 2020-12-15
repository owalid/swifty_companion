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
//  let str = UtilsAPI.searchUser(login)
    var body: some View {
      // todo: let url = https://api.intra.42.fr/v2/users?search[login]=\(login)&sort=login&page[size]=100
        Text("Hello world \(login)")
    }
}

//struct UserView_Previews: PreviewProvider {
//
//    static var previews: some View {
//      @Binding var login: String
//      UserView(login)
//    }
//}
