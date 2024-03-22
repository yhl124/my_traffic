//
//  MainView.swift
//  my_traffic
//
//  Created by yhl on 2024/03/20.
//

import Foundation
import SwiftUI

struct MainView: View {    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Spacer()
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("Hello, world!")
                    Spacer()
                    HStack {
                        NavigationLink(destination: SubwayView()){
                            ZStack {
                                Circle()
                                    .foregroundColor(.blue)
                                    .frame(width: 60, height: 60)
                                Image(systemName: "train.side.front.car")
                                    .foregroundColor(.white)
                            }
                        }
                        Spacer()
                        NavigationLink(destination: BusView()){
                            ZStack {
                                Circle()
                                    .foregroundColor(.blue)
                                    .frame(width: 60, height: 60)
                                
                                Image(systemName: "bus")
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
            }
            //.navigationBarTitleDisplayMode(.inline)
            //.navigationBarTitle("위젯 설정", displayMode: .inline)
            .navigationTitle("위젯 설정")
            .navigationBarItems(
                //leading: Text("위젯 설정").font(.headline),
                trailing: NavigationLink(destination: SettingView()) {
                    Image(systemName: "gear")
                }
            )
            .padding()
        }
    }
}

#Preview {
    MainView()
}
