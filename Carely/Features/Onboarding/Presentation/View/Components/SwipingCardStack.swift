//
//  SwipingCardStack.swift
//  Carely
//

import SwiftUI

struct SwipingCardStack<T: Identifiable, Content: View>: View {
    let items: [T]
    @Binding var currentIndex: Int
    @Binding var triggerSwipe: Bool
    let maxVisibleCards: Int
    let content: (T) -> Content

    var body: some View {
        ZStack {
            ForEach(Array(items.enumerated().reversed()), id: \.element.id) { index, item in
                if index >= currentIndex && index < currentIndex + maxVisibleCards {
                    content(item)
                        .stacked(at: index - currentIndex)
                        .modifier(SwipeableModifier(
                            isTopCard: index == currentIndex,
                            isLastCard: index == items.count - 1,
                            triggerSwipe: $triggerSwipe,
                            onSwipe: {
                                currentIndex += 1
                            }
                        ))
                }
            }
        }
    }
}

private extension View {
    func stacked(at index: Int) -> some View {
        let scale = 1.0 - CGFloat(index) * 0.04
        
        // Card 1 rotates clockwise (peeks bottom-left and top-right)
        // Card 2 rotates counter-clockwise (peeks top-left and bottom-right)
        let rotation: Double = index == 0 ? 0.0 : (index == 1 ? 6.0 : -6.0)
        
        return self
            .scaleEffect(scale)
            .rotationEffect(.degrees(rotation))
            .zIndex(-Double(index))
    }
}

private struct SwipeableModifier: ViewModifier {
    let isTopCard: Bool
    let isLastCard: Bool
    @Binding var triggerSwipe: Bool
    let onSwipe: () -> Void
    
    @State private var offset: CGSize = .zero
    
    func body(content: Content) -> some View {
        content
            .offset(x: offset.width, y: offset.height * 0.4)
            .rotationEffect(.degrees(Double(offset.width / 15)))
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        if isTopCard && !isLastCard {
                            offset = gesture.translation
                        }
                    }
                    .onEnded { gesture in
                        if isTopCard && !isLastCard {
                            if abs(gesture.translation.width) > 100 {
                                // Swipe out
                                let width = gesture.translation.width > 0 ? 500.0 : -500.0
                                withAnimation(.easeOut(duration: 0.2)) {
                                    offset = CGSize(width: width, height: gesture.translation.height)
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    onSwipe()
                                    offset = .zero
                                }
                            } else {
                                // Snap back
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                                    offset = .zero
                                }
                            }
                        }
                    }
            )
            .onChange(of: triggerSwipe) { _, newValue in
                if newValue && isTopCard && !isLastCard {
                    withAnimation(.easeOut(duration: 0.2)) {
                        offset = CGSize(width: -500.0, height: 0) // animate out to left
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        onSwipe()
                        offset = .zero
                        triggerSwipe = false
                    }
                }
            }
    }
}
