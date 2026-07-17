//
//  OTPResendSectionView.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 16/07/2026.
//


import SwiftUI

struct OTPResendSectionView: View {
    @State private var secondsRemaining = 30
    @State private var endTime: Date = Date().addingTimeInterval(30)
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    let onResendTapped: () -> Void
    
    var body: some View {
        Group {
            if secondsRemaining > 0 {
                Text("Resend code in \(timeString)")
                    .carelyText(style: .bodySmall, weight: .medium)
                    .foregroundStyle(Color.primary)
            } else {
                Button {
                    endTime = Date().addingTimeInterval(30)
                    secondsRemaining = 30
                    onResendTapped()
                } label: {
                    Text("Resend code")
                        .carelyText(style: .bodySmall, weight: .semiBold)
                        .foregroundStyle(Color.primary)
                }
            }
        }
        .onReceive(timer) { _ in
            guard secondsRemaining > 0 else { return }
            let remaining = Int(endTime.timeIntervalSinceNow)
            secondsRemaining = max(0, remaining)
        }
    }
    
    private var timeString: String {
        let minutes = secondsRemaining / 60
        let seconds = secondsRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
