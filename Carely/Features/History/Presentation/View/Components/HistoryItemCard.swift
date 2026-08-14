//
//  HistoryItemCard.swift
//  Carely
//
//  Created by Mina on 14/08/2026.
//

import SwiftUI
 
struct HistoryItemCard: View {
    let item: VisitHistoryItem
    var action: () -> Void = {}
 
    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: Spacing.s16) {
                avatar
 
                VStack(alignment: .leading, spacing: Spacing.s4) {
                    HStack {
                        Text(item.nurseName)
                            .carelyText(style: .bodyRegular, weight: .bold)
                            .foregroundColor(.primaryFont)
 
                        Spacer()
 
                        VisitStatusBadge(status: item.status)
                    }
 
                    Text(item.serviceName)
                        .carelyText(style: .bodySmall)
                        .foregroundColor(.secondaryFont)
 
                    HStack(spacing: Spacing.s4) {
                        Image(systemName: "clock")
                        Text(item.dateTimeText)
                    }
                    .carelyText(style: .caption)
                    .foregroundColor(.hint)
                }
            }
            .padding(Spacing.s16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.surface)
            .clipShape(RoundedRectangle.carely(Radius.r24))
            .carelyShadow(.sm)
        }
        .buttonStyle(.plain)
    }
 
    private var avatar: some View {
        Group {
            if let urlString = item.nurseImageUrl, let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable().scaledToFill()
                    case .failure:
                        placeholderIcon
                    @unknown default:
                        placeholderIcon
                    }
                }
            } else {
                placeholderIcon
            }
        }
        .frame(width: 48, height: 48)
        .background(Color.primaryContainer.opacity(0.3))
        .clipShape(RoundedRectangle.carely(Radius.r16))
    }
 
    private var placeholderIcon: some View {
        Image(systemName: "person.fill")
            .foregroundColor(.brandPrimary)
    }
}
 
