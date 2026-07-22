//
//  HomeBottomNavBar.swift
//  Carely
//
//  Created by Mina on 22/07/2026.
//

import SwiftUI
 
struct HomeBottomNavBar: View {
    enum Tab {
        case home, services, bookings, profile
    }
 
    let selectedTab: Tab
    var onHomeTapped: () -> Void = {}
    var onServicesTapped: () -> Void = {}
    var onBookingsTapped: () -> Void = {}
    var onProfileTapped: () -> Void = {}
 
    var body: some View {
        HStack(spacing: Spacing.s0) {
            tabButton(tab: .home, title: "Home", icon: "house.fill", action: onHomeTapped)
            tabButton(tab: .services, title: "Services", icon: "cross.case.fill", action: onServicesTapped)
            tabButton(tab: .bookings, title: "Bookings", icon: "calendar", action: onBookingsTapped)
            tabButton(tab: .profile, title: "Profile", icon: "person.fill", action: onProfileTapped)
        }
        .padding(.horizontal, Spacing.s16)
        .padding(.vertical, Spacing.s8)
        .background(Color.surface)
        .carelyShadow(.md)
    }
 
    @ViewBuilder
    private func tabButton(tab: Tab, title: String, icon: String, action: @escaping () -> Void) -> some View {
        let isSelected = tab == selectedTab
 
        Button(action: action) {
            VStack(spacing: Spacing.s4) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                Text(title)
                    .carelyText(style: .caption, weight: .medium)
            }
            .foregroundColor(isSelected ? .onPrimary : .secondaryFont)
            .padding(.horizontal, Spacing.s16)
            .padding(.vertical, Spacing.s4)
            .background(isSelected ? Color.primaryContainer : Color.clear)
            .clipShape(RoundedRectangle.carely(Radius.r16))
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}
 
//#Preview {
//    HomeBottomNavBar(selectedTab: .home)
//}
