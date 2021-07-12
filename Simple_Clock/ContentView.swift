//
//  ContentView.swift
//  Simple_Clock
//
//  Created by Adnan Abdollah Zaki on 4/21/1400 AP.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home: View {
    
    @State var currentTime = Time(hour: 0 , minute: 0 , second: 0)
    @State var receiver = Timer.publish(every: 1, on: .current, in:.default).autoconnect()
    var width = UIScreen.main.bounds.width
    
    var body: some View {
        VStack {
            Text(getTime())
                .font(.system(size : 50))
                .fontWeight(.bold)
                .padding(.top , 20)
            
            ZStack {
                Circle()
                    .fill(Color.white)
                
                Spacer()
                
                ForEach(0..<60, id: \.self) {i in
                    Rectangle()
                        .fill(Color.primary)
                        .frame(width: 2 , height: (i % 5) == 0 ? 15 : 5)
                        .offset(y : (width - 110) / 2)
                        .rotationEffect(.init(degrees: Double(i) * 6))
                }
                
                //Minute
                Rectangle()
                    .fill(Color.primary)
                    .frame(width: 4 , height: (width - 150) / 2)
                    .offset(y: (-(width - 200) / 4))
                    .rotationEffect(.init(degrees: Double(currentTime.minute) * 6))
                
                //Hour
                Rectangle()
                    .fill(Color.primary)
                    .frame(width: 4.5 , height : (width - 240) / 2)
                    .offset(y: -(width - 240) / 4)
                    .rotationEffect(.init(degrees: Double(currentTime.hour + currentTime.minute / 60) * 30))
                
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 2 , height: (width - 180) / 2)
                    .offset(y: -(width - 180) / 4)
                    .rotationEffect(.init(degrees: Double(currentTime.second) * 6))
                
                Circle()
                    .fill(Color.primary)
                    .frame(width: 15 , height: 15)
            }
            .frame(width: width - 100,height:width - 100)
        }
        .onAppear(perform: {
            let calendar = Calendar.current
            
            let sec = calendar.component(.second, from: Date())
            let min = calendar.component(.minute, from: Date())
            let hour = calendar.component(.hour, from: Date())

            withAnimation(Animation.linear(duration: 0.01)) {
                currentTime = Time(hour: hour, minute: min, second: sec)
            }
        })
        .onReceive(receiver) { _ in
            let calendar = Calendar.current
            
            let sec = calendar.component(.second, from: Date())
            let min = calendar.component(.minute, from: Date())
            let hour = calendar.component(.hour, from: Date())

            withAnimation(Animation.linear(duration: 0.01)) {
                currentTime = Time(hour: hour, minute: min, second: sec)
            }
        }
    }
    
    func getTime() -> String {
        let format = DateFormatter()
        format.dateFormat = "hh:mm a"
        return format.string(from: Date())
    }
}

struct Time {
    var hour : Int
    var minute : Int
    var second : Int
}
