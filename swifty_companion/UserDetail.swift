//
//  UserDetail.swift
//  swifty_companion
//
//  Created by owalid on 18/12/2020.
//  Copyright © 2020 owalid. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserDetail: View {
  @State private var usersDetail: UserDetailStruct?
  var id: Int
  let api = Api.instance

  var body: some View {
    Text("")
      .onAppear {
        self.api.getUserDetail(id: id) {response, error in
          self.usersDetail = response
      }
    }
    if (usersDetail != nil) {
      WebImage(url: URL(string: "\(FT_BASE_URL_PIC)/large_\(usersDetail!.login).jpg"))
      .resizable()
      .placeholder {Rectangle().foregroundColor(.gray)}
      .indicator(.activity)
      .scaledToFit()
      .cornerRadius(50)
      .frame(width: 200, height: 150)
      Text(usersDetail!.login)
      Text("\(usersDetail!.firstName) - \(usersDetail!.lastName)")
      Text("\(usersDetail!.cursusUsers[0].level)")
      Text("\(usersDetail!.correctionPoint)")
      Text("Grade: \(usersDetail!.cursusUsers[0].grade!)")
      Text("\(usersDetail!.wallet)₳")
      Text("Picine: \(usersDetail!.poolMonth) - \(usersDetail!.poolYear)")
      Text("Campus: \(usersDetail!.campus[0].name)")
    }
  }
}

//struct UserDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        UserDetail()
//    }
//}
