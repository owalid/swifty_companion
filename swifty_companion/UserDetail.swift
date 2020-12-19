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

struct buttonTabStyle: ButtonStyle {
  var condition: Bool
  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
      .foregroundColor(condition ? Color.white : Color.blue)
      .padding()
      .background(condition ? Color.blue : Color.white)
      .cornerRadius(15.0)
  }
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
  @State var selectedTab = 0
  @State var expand = false
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
            Button(action: {
                self.expand.toggle()
            }) {
              Text("\(self.usersDetail!.cursusUsers[selectedCursus].cursus.name)")
            }
            if expand {
              Picker(selection: $selectedCursus, label: Text("")) {
                  ForEach(0 ..< usersDetail!.cursusUsers.count) {
                    Text(self.usersDetail!.cursusUsers[$0].cursus.name)
                  }
              }
            }
          }
        }
        HStack() {
          Text("Wallet \(usersDetail!.wallet)₳") // wallet
          Text("Point d'evaluation \(usersDetail!.correctionPoint)") // evaluation point
        }.padding()
        
        ProgressBar(value: usersDetail!.cursusUsers[self.selectedCursus].level).frame(height: 20)
        
        HStack() {
          Button(action: {
            self.selectedTab = 0
          }) {
            Text("Projets")
          }.buttonStyle(buttonTabStyle(condition: self.selectedTab == 0))
          Button(action: {
            self.selectedTab = 1
          }) {
            Text("Achievement")
          }.buttonStyle(buttonTabStyle(condition: self.selectedTab == 1))
          Button(action: {
            self.selectedTab = 2
          }) {
            Text("Graphiques")
          }.buttonStyle(buttonTabStyle(condition: self.selectedTab == 2))
        }.padding()
        
        if (self.selectedTab == 0) {
          VStack(spacing: 0) {
            List {
              ForEach(usersDetail!.projectsUsers, id: \.id) { project in
                if (project.cursusIDS[0] == usersDetail!.cursusUsers[self.selectedCursus].cursusID && project.project.parentID == nil) {
                  Text("\(project.project.name) - \((project.finalMark != nil) ? String(project.finalMark!) : "En cours...")")
                }
              }
            }.frame(height: CGFloat(usersDetail!.projectsUsers.count))
          }.layoutPriority(1)
        } else if (self.selectedTab == 1) {
          VStack(spacing: 0) {
            List {
              ForEach(usersDetail!.achievements, id: \.id) { achievement in
                HStack() {
                  WebImage(url: URL(string: "https://api.intra.42.fr\(achievement.image)"))
                    .resizable()
                    .placeholder {Rectangle().foregroundColor(.gray)}
                    .indicator(.activity)
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                  Text("\(achievement.name) - \(achievement.achievementDescription)")
                }
              }
            }.frame(height: CGFloat(usersDetail!.projectsUsers.count))
          }.layoutPriority(1)
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
