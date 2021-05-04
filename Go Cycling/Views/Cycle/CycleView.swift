//
//  ContentView.swift
//  Go Cycling
//
//  Created by Anthony Hopkins on 2021-03-14.
//

import SwiftUI

struct CycleView: View {
    
    @EnvironmentObject var cyclingStatus: CyclingStatus
    
    @StateObject var timer = TimerViewModel()
    @State private var showingAlert = false
    @State private var cyclingSpeed = 0.0
    @State private var cyclingStartTime = Date()
    @State private var timeCycling = 0.0
    
    var body: some View {
        VStack {
            MapWithSpeedView(cyclingStartTime: $cyclingStartTime, timeCycling: $timeCycling)
            Text(formatTimeString(accumulatedTime: timer.totalAccumulatedTime))
                .font(.custom("Avenir", size: 40))
            HStack {
                if (timer.isRunning) {
                    Button (action: {self.timer.pause()}) {
                        TimerButton(label: "Pause", buttonColour: UIColor.systemYellow)
                            .padding(.bottom, 20)
                            .minimumScaleFactor(0.3)
                            .lineLimit(1)
                    }
                    Button (action: {self.confirmStop()}) {
                        TimerButton(label: "Stop", buttonColour: UIColor.systemRed)
                            .padding(.bottom, 20)
                            .minimumScaleFactor(0.3)
                            .lineLimit(1)
                    }
                }
                if (timer.isStopped) {
                    Button (action: {self.startCycling()}) {
                        TimerButton(label: "Start", buttonColour: UIColor.systemGreen)
                            .padding(.bottom, 20)
                            .minimumScaleFactor(0.3)
                            .lineLimit(1)
                    }
                }
                if (timer.isPaused) {
                    Button (action: {self.timer.start()}) {
                        TimerButton(label: "Resume", buttonColour: UIColor.systemGreen)
                            .padding(.bottom, 20)
                            .minimumScaleFactor(0.3)
                            .lineLimit(1)
                    }
                    Button (action: {self.confirmStop()}) {
                        TimerButton(label: "Stop", buttonColour: UIColor.systemRed)
                            .padding(.bottom, 20)
                            .minimumScaleFactor(0.3)
                            .lineLimit(1)
                    }
                }
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Are you sure that you want to end the current bike ride?"),
                  message: Text("Please confirm that you are ready to end the current bike ride."),
                  primaryButton: .destructive(Text("Stop")) {
                    self.timeCycling = timer.totalAccumulatedTime
                    self.timer.stop()
                    cyclingStatus.stoppedCycling()
                  },
                  secondaryButton: .cancel()
            )
        }
    }
    
    func formatTimeString(accumulatedTime: TimeInterval) -> String {
        let hours = Int(accumulatedTime) / 3600
        let minutes = Int(accumulatedTime) / 60 % 60
        let seconds = Int(accumulatedTime) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    func startCycling() {
        cyclingStatus.startedCycling()
        self.cyclingStartTime = Date()
        self.timeCycling = 0.0
        self.timer.start()
    }
    
    func confirmStop() {
        self.timer.pause()
        showingAlert = true
    }
}

struct CycleView_Previews: PreviewProvider {
    static var previews: some View {
        CycleView()
    }
}
