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
  @State var loading = false

  @State private var shouldAnimate = false
  @State var leftOffset: CGFloat = -100
  @State var rightOffset: CGFloat = 100
  
  let styleLoader = StrokeStyle(lineWidth: 6, lineCap: .round)
  let api = Api.instance
  
  var body: some View {
    List {
      if usersSearch != nil {
        ForEach(usersSearch!, id: \.login) { user in
          NavigationLink(destination: UserDetail(id: user.id, rootViewIsActive: self.$rootIsActive)) {
            WebImage(url: URL(string: "\(FT_BASE_URL_PIC)/small_\(user.login).jpg"))
            .resizable()
            .placeholder {Rectangle().foregroundColor(.gray)}
            .indicator(.activity)
            .scaledToFit()
            .frame(width: 50, height: 50)
            Text("\(user.login) - \(user.id)").onAppear {
              if self.usersSearch!.last == user && !isFinished {
                self.loading = true
                self.page += 1
                self.api.searchUser(login: login, page: page) {response, error in
                  if response?.count == 0 {
                    self.isFinished = true
                  }
                  self.usersSearch! += response!
                  self.loading = false
                }
              }
          }
          }.navigationBarTitle(user.login)
        }
        if self.loading {
          RoundedRectangle(cornerRadius: 10)
           .fill(Color.blue)
           .frame(width: 80, height: 20)
            .offset(x: shouldAnimate ? rightOffset : leftOffset)
            .animation(Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true))
            .onAppear {self.shouldAnimate = true}
        }
      }
    }.onAppear {
      self.api.searchUser(login: login, page: page) {response, error in
        if response == nil || error != nil {
          self.rootIsActive = false
        } else {
          self.usersSearch = response
        }
      }
    }
    if usersSearch == nil {
      HStack() {
        RoundedRectangle(cornerRadius: 10)
        .fill(Color.blue)
        .frame(width: 80, height: 20)
        .offset(x: shouldAnimate ? rightOffset : leftOffset)
        .animation(Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true))
        .onAppear {self.shouldAnimate = true}
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
