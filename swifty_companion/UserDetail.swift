//
//  UserDetail.swift
//  swifty_companion
//
//  Created by owalid on 18/12/2020.
//  Copyright © 2020 owalid. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI


final class ChartDataModel: ObservableObject {
    var chartCellModel: [Skill]
    var startingAngle = Angle(degrees: 0)
  
    private var lastBarEndAngle = Angle(degrees: 0)
    
        
    init(dataModel: [Skill]) {
        chartCellModel = dataModel
    }
    
    var totalValue: CGFloat {
        chartCellModel.reduce(CGFloat(0)) { (result, data) -> CGFloat in
            result + CGFloat(data.level)
        }
    }
    
    func angle(for value: CGFloat) -> Angle {
        if startingAngle != lastBarEndAngle {
            startingAngle = lastBarEndAngle
        }
        lastBarEndAngle += Angle(degrees: Double(value / totalValue) * 360)
        return lastBarEndAngle
    }
}

struct PieChartCell: Shape {
  let startAngle: Angle
  let endAngle: Angle
  
  func path(in rect: CGRect) -> Path {
    let center = CGPoint.init(x: (rect.origin.x + rect.width)/2, y: (rect.origin.y + rect.height)/2)
    let radii = min(center.x, center.y)
    let path = Path { p in
      p.addArc(center: center,
               radius: radii,
               startAngle: startAngle,
               endAngle: endAngle,
               clockwise: true)
      p.addLine(to: center)
    }
    return path
   }
}

struct PieChart: View {
    @State private var selectedCell: Int = -1
    
    let dataModel: ChartDataModel
    let onTap: (Skill?) -> ()
    var body: some View {
      ZStack {
          ForEach(dataModel.chartCellModel) { dataSet in
              PieChartCell(startAngle: self.dataModel.angle(for: CGFloat(dataSet.level)), endAngle: self.dataModel.startingAngle)
                .foregroundColor(Color(
                  red: Double(dataSet.id) / 100 + 0.04 * dataSet.level,
                  green: Double(dataSet.id) / 100 + 0.08 * dataSet.level,
                  blue: Double(dataSet.id) / 100 + 0.15 * dataSet.level
              ))
                 .onTapGesture {
                   withAnimation {
                      if self.selectedCell == dataSet.id {
                        self.onTap(nil)
                        self.selectedCell = -1
                      } else {
                          self.selectedCell = dataSet.id
                          self.onTap(dataSet)
                      }
                  }
              }.scaleEffect((self.selectedCell == dataSet.id) ? 1.15 : 1.0)
          }
        }
  }
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
          Spacer()
          Text("\(self.value, specifier: "%.2f")").fontWeight(.light)
          Spacer()
        })
      }.cornerRadius(45.0)
    }
  }
}
struct UserDetail: View {
    var id: Int
    @Binding var rootViewIsActive : Bool
  
    @State var selectedPie: String = ""
    @State var selectedTab = 0
    @State var expand = false
    @State private var usersDetail: UserDetailStruct?
    @State private var expertises: [Expertise]?
    @State private var userCoalition: Coalition?
    @State private var selectedCursus = 0
  
    let api = Api.instance
  
  func dateToString(date: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
    return dateFormatter.date(from: date)!
  }

  var body: some View {
    ZStack {
      
      if (usersDetail != nil && expertises != nil) {
                    if userCoalition != nil {
                      WebImage(url: URL(string: userCoalition!.coverURL))
                      .resizable()
                      .indicator(.activity)
                      .scaledToFit()
                      .edgesIgnoringSafeArea(.all)
                    }
      VStack(spacing: 10) {
        VStack(spacing: 10) {
          
          HStack(alignment: .top) {
            VStack() {
              Text("\(usersDetail!.campus[0].name)") // campus name
            }.frame(maxWidth: 70)
            Spacer()
              WebImage(url: URL(string: "\(FT_BASE_URL_PIC)/large_\(usersDetail!.login).jpg"))
                .resizable()
                .placeholder {Rectangle().foregroundColor(.gray)}
                .indicator(.activity)
                .scaledToFit()
                .cornerRadius(100)
                .frame(width: 150, height: 150, alignment: .center)
            Spacer()
            VStack() {
              if usersDetail!.poolYear != nil {
                Text("\(usersDetail!.poolYear!)") // piscine
              }
            }.frame(maxWidth: 70)
          }
          HStack(alignment: .top) {
            Spacer()
           VStack(alignment: .center) {
            if usersDetail?.staff != nil && usersDetail?.staff == true{
              ZStack {
                Rectangle()
                  .fill(Color.red)
                  .cornerRadius(10)
                  .frame(width: 50, height: 20)
                  Text("Staff")
                  .foregroundColor(.white)
              }
            }
             Text("\(usersDetail!.firstName) - \(usersDetail!.lastName)").font(.system(size: 30)).fontWeight(.semibold) // first name
             Text("\(usersDetail!.login)").font(.system(size: 20)).fontWeight(.light) // login
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
            Spacer()
         }
         HStack() {
          Text("Wallet ").font(.system(size: 15)) + Text("\(usersDetail!.wallet)").font(.system(size: 16)).bold() + Text("₳").font(.system(size: 15)) // wallet
           Text("Point d'evaluation ").font(.system(size: 15)) + Text("\(usersDetail!.correctionPoint)").font(.system(size: 16)).bold()// evaluation point
         }.padding()
          ProgressBar(value: usersDetail!.cursusUsers[self.selectedCursus].level).frame(height: 20).padding()
          HStack() {
            
            Button(action: {
              self.selectedTab = 0
            }) {
              Text("Projets").font(.system(size: 13)).fontWeight(.light)
            }.buttonStyle(buttonTabStyle(condition: self.selectedTab == 0))
            
            Button(action: {
              self.selectedTab = 1
            }) {
              Text("Achievements").font(.system(size: 13)).fontWeight(.light)
            }.buttonStyle(buttonTabStyle(condition: self.selectedTab == 1))
            
            Button(action: {
              self.selectedTab = 2
            }) {
              Text("Graphiques").font(.system(size: 13)).fontWeight(.light)
            }.buttonStyle(buttonTabStyle(condition: self.selectedTab == 2))
            
            Button(action: {
              self.selectedTab = 3
            }) {
              Text("Expertise").font(.system(size: 13)).fontWeight(.light)
            }.buttonStyle(buttonTabStyle(condition: self.selectedTab == 3))
            
          }
          if (self.selectedTab == 0) {
            VStack(spacing: 0) {
              List {
                ForEach(usersDetail!.projectsUsers, id: \.id) { project in
                  if project.cursusIDS[0] == usersDetail!.cursusUsers[self.selectedCursus].cursusID && project.project.parentID == nil {
                    if (project.status != "in_progress" && project.validated != nil) {
                      
                      HStack {
                        Text("\(project.project.name)").foregroundColor((project.validated!) ? Color.green : Color.red)
                        if project.markedAt != nil{
                          Text(" - \(dateToString(date: project.markedAt!).timeAgoDisplay())").font(.system(size: 13)).fontWeight(.light)
                        }
                        Spacer()
                        Text("\(String(project.finalMark!))").foregroundColor((project.validated!) ? Color.green : Color.red)
                      }
                    } else {
                      HStack {
                        Text("\(project.project.name)").foregroundColor(Color(red: 1.00, green: 0.76, blue: 0.03))
                        Spacer()
                        Text("En cours...").foregroundColor(Color(red: 1.00, green: 0.76, blue: 0.03))
                      }
                    }
                  }
                }
              }
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
              }
            }.layoutPriority(1)
          } else if self.selectedTab == 2 {
            VStack {
             HStack(spacing: 0) {
                 PieChart(dataModel: ChartDataModel.init(dataModel: usersDetail!.cursusUsers[self.selectedCursus].skills), onTap: {
                     dataModel in
                     if let dataModel = dataModel {
                      self.selectedPie = "\(dataModel.name): \(dataModel.level.rounded(toPlaces: 2))"
                     } else {
                         self.selectedPie = ""
                     }
                 })
                     .frame(width: 150, height: 150, alignment: .center)
                     .padding()
                 Text(selectedPie)
                 .font(.footnote)
                 .multilineTextAlignment(.leading)
                 Spacer()
             }
           }
          } else {
            VStack(spacing: 0) {
              List {
                ForEach(usersDetail!.expertisesUsers, id: \.id) { expertiseUser in
                    let cpy = expertises
                    let expertisesFiltered = cpy!.filter{ $0.id == expertiseUser.expertiseID}
                    if  expertisesFiltered.count > 0 && expertisesFiltered.count != 0 {
                      HStack {
                        Text("\(expertisesFiltered[0].name)")
                        ForEach(0..<(expertiseUser.value), id: \.self) { index in
                               Image(systemName: "star.fill")
                                   .foregroundColor(Color.blue)
                           }
                       }
                    }
                }
              }
            }.layoutPriority(1)
          }
        }
        Spacer()
      }
      .foregroundColor(Color.black.opacity(0.7))
      .padding()
      }
    }.onAppear {
      self.api.getUserDetail(id: id) {response, error in
        if response == nil || error != nil {
          self.rootViewIsActive = false
        } else {
          self.usersDetail = response
      }
    }
      self.api.getExpertises() {response, error in
        if response == nil || error != nil {
          self.rootViewIsActive = false
        } else {
          self.expertises = response
        }
      }
      self.api.getUserCoalition(id: id) {response, error in
        if response == nil || error != nil {
          self.rootViewIsActive = false
        } else {
          self.userCoalition = response
          print(self.userCoalition)
        }
      }
  }
  }
}
//struct UserDetail: View {
//  var id: Int
//  @Binding var rootViewIsActive : Bool
//
//  @State var selectedPie: String = ""
//  @State var selectedTab = 0
//  @State var expand = false
//  @State private var usersDetail: UserDetailStruct?
//  @State private var selectedCursus = 0
//
//  let api = Api.instance
//
//  var body: some View {
//    Text("FESSE")
//      .onAppear {
//        self.api.getUserDetail(id: id) {response, error in
//          if response == nil || error != nil {
//            self.rootViewIsActive = false
//          } else {
//            self.usersDetail = response
//        }
//      }
//    }
//    if (usersDetail != nil) {
//      ZStack {
//      VStack(spacing: 10) {
//        HStack(alignment: .top) {
//          Text("\(usersDetail!.campus[0].name)") // campus name
//            WebImage(url: URL(string: "\(FT_BASE_URL_PIC)/large_\(usersDetail!.login).jpg"))
//              .resizable()
//              .placeholder {Rectangle().foregroundColor(.gray)}
//              .indicator(.activity)
//              .scaledToFit()
//              .cornerRadius(100)
//              .frame(width: 150, height: 150, alignment: .center)
//          Text("\(usersDetail!.poolYear)") // piscine
//        }
//        HStack() {
//          VStack() {
//            Text("\(usersDetail!.firstName) - \(usersDetail!.lastName)") // first name
//            Text(usersDetail!.login) // login
//            Button(action: {
//                self.expand.toggle()
//            }) {
//              Text("\(self.usersDetail!.cursusUsers[selectedCursus].cursus.name)")
//            }
//            if expand {
//              Picker(selection: $selectedCursus, label: Text("")) {
//                  ForEach(0 ..< usersDetail!.cursusUsers.count) {
//                    Text(self.usersDetail!.cursusUsers[$0].cursus.name)
//                  }
//              }
//            }
//          }
//        }
//        HStack() {
//          Text("Wallet \(usersDetail!.wallet)₳") // wallet
//          Text("Point d'evaluation \(usersDetail!.correctionPoint)") // evaluation point
//        }.padding()
//
//        ProgressBar(value: usersDetail!.cursusUsers[self.selectedCursus].level).frame(height: 20)
//
//        HStack() {
//          Button(action: {
//            self.selectedTab = 0
//          }) {
//            Text("Projets")
//          }.buttonStyle(buttonTabStyle(condition: self.selectedTab == 0))
//          Button(action: {
//            self.selectedTab = 1
//          }) {
//            Text("Achievements")
//          }.buttonStyle(buttonTabStyle(condition: self.selectedTab == 1))
//          Button(action: {
//            self.selectedTab = 2
//          }) {
//            Text("Graphiques")
//          }.buttonStyle(buttonTabStyle(condition: self.selectedTab == 2))
//        }.padding()
//
//        if (self.selectedTab == 0) {
//          VStack(spacing: 0) {
//            List {
//              ForEach(usersDetail!.projectsUsers, id: \.id) { project in
//                if (project.cursusIDS[0] == usersDetail!.cursusUsers[self.selectedCursus].cursusID && project.project.parentID == nil) {
//                  Text("\(project.project.name) - \((project.finalMark != nil) ? String(project.finalMark!) : "En cours...")")
//                }
//              }
//            }.frame(height: CGFloat(usersDetail!.projectsUsers.count))
//          }.layoutPriority(1)
//        } else if (self.selectedTab == 1) {
//          VStack(spacing: 0) {
//            List {
//              ForEach(usersDetail!.achievements, id: \.id) { achievement in
//                HStack() {
//                  WebImage(url: URL(string: "https://api.intra.42.fr\(achievement.image)"))
//                    .resizable()
//                    .placeholder {Rectangle().foregroundColor(.gray)}
//                    .indicator(.activity)
//                    .scaledToFit()
//                    .frame(width: 20, height: 20)
//                  Text("\(achievement.name) - \(achievement.achievementDescription)")
//                }
//              }
//            }.frame(height: CGFloat(usersDetail!.projectsUsers.count))
//          }.layoutPriority(1)
//        } else {
//          VStack {
//           HStack(spacing: 20) {
//               PieChart(dataModel: ChartDataModel.init(dataModel: usersDetail!.cursusUsers[self.selectedCursus].skills), onTap: {
//                   dataModel in
//                   if let dataModel = dataModel {
//                       self.selectedPie = "\(dataModel.name): \(dataModel.level)"
//                   } else {
//                       self.selectedPie = ""
//                   }
//               })
//                   .frame(width: 150, height: 150, alignment: .center)
//                   .padding()
//               Text(selectedPie)
//               .font(.footnote)
//               .multilineTextAlignment(.leading)
//               Spacer()
//           }
//         }
//        }
//      }
//        Spacer()
//    }
//    }
//  }
//}

//struct UserDetail_Previews: PreviewProvider {
//    static var previews: some View {
//      UserDetail()
//    }
//}
