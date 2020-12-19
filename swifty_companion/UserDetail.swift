//
//  UserDetail.swift
//  swifty_companion
//
//  Created by owalid on 18/12/2020.
//  Copyright © 2020 owalid. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct TabItem: Identifiable {
    var id = UUID()
    var title: Text
    var tag: Int
}

struct ProgressBar: View {
  var value: Double

    var body: some View {
      
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color(UIColor.systemTeal))
              Rectangle().frame(width: min(CGFloat(Float("0.\(String(self.value).components(separatedBy: ".")[1])")!)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(Color(UIColor.systemBlue))
                    .animation(.linear)
              HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
                Text("\(self.value.rounded(toPlaces: 2))")
              })
            }.cornerRadius(45.0)
        }
    }
}

struct UserDetail: View {
  let tabData = [
    TabItem(title: Text("Projets"), tag: 1),
    TabItem(title: Text("Achievments"), tag: 2),
    TabItem(title: Text("Graphiques"), tag: 3),
  ]

  @State private var selectedTab = 0
  
  @State private var usersDetail: UserDetailStruct?
  @State private var selectedCursus = 0
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
      VStack() {
        HStack(alignment: .top) {
          Text("\(usersDetail!.campus[0].name)") // paris
            WebImage(url: URL(string: "\(FT_BASE_URL_PIC)/large_\(usersDetail!.login).jpg"))
              .resizable()
              .placeholder {Rectangle().foregroundColor(.gray)}
              .indicator(.activity)
              .scaledToFit()
              .cornerRadius(100)
              .frame(width: 200, height: 150, alignment: .center)
          Text("\(usersDetail!.poolYear)") // piscine
        }
        HStack() {
          VStack() {
            Text("\(usersDetail!.firstName) - \(usersDetail!.lastName)") // first name
            Text(usersDetail!.login) // login
          }
        }
        HStack() {
          Text("Wallet \(usersDetail!.wallet)₳") // wallet
          Text("Point d'evaluation \(usersDetail!.correctionPoint)") // evaluation point
        }.padding()
        ProgressBar(value: usersDetail!.cursusUsers[self.selectedCursus].level).frame(height: 20)
//        Text("\(usersDetail!.cursusUsers[self.selectedCursus].level)") // level
        
        // Tab: Projects / achievement / charts
//        TabView(selection: $selectedTab) {
//          ForEach(tabData) { tabItem in
//              Text("Screen: \(tabItem.tag)")
//                  .tabItem {
//                      tabItem.title
//              }.tag(tabItem.tag)
//          }
//        }
        VStack(spacing: 0) {
          List {
            ForEach(usersDetail!.projectsUsers, id: \.id) { project in
              if (project.cursusIDS[0] == usersDetail!.cursusUsers[self.selectedCursus].cursusID && project.project.parentID == nil) {
                Text("\(project.project.name) - \((project.finalMark != nil) ? String(project.finalMark!) : "En cours...")")
              }
            }
          }.frame(height: CGFloat(usersDetail!.projectsUsers.count))
        }.layoutPriority(1)
        Picker(selection: $selectedCursus, label: Text("")) {
            ForEach(0 ..< usersDetail!.cursusUsers.count) {
              Text(self.usersDetail!.cursusUsers[$0].cursus.name)
            }
         }
      }
    }
  }
}

//struct UserDetail_Previews: PreviewProvider {
//    static var previews: some View {
//      UserDetail(id: 1)
//    }
//}
