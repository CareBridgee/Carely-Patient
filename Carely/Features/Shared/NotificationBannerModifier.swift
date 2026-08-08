//
//  NotificationBannerModifier.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 04/08/2026.
//


import SwiftUI

struct NotificationBannerModifier: ViewModifier {
    @Binding var notification: NotificationData?
    var onTap: () -> Void

    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            content
            
            if let notif = notification {
                NotificationBannerView(
                    data: notif,
                    onDismiss: {
                        withAnimation {
                            notification = nil
                        }
                    },
                    onTap: {
                        onTap()
                        withAnimation {
                            notification = nil
                        }
                    }
                )
                .transition(.move(edge: .top).combined(with: .opacity))
                .zIndex(1)
                .padding(.top, 40) 
            }
        }
        .animation(.spring(), value: notification)
    }
}

extension View {
    func notificationBanner(data: Binding<NotificationData?>, onTap: @escaping () -> Void) -> some View {
        modifier(NotificationBannerModifier(notification: data, onTap: onTap))
    }
}
