//
//  ErrorToastModifier.swift
//  Carely
//
//  Created by Mina on 16/08/2026.
//
//  Reusable floating top banner for surfacing the exact server error message
//  on any screen, without a system `.alert(...)` popup. Wraps the existing
//  `AlertBanner` component with animated presentation, swipe-to-dismiss, and
//  auto-dismiss so every screen gets consistent behavior for free.
//

import SwiftUI

struct ErrorToastModifier: ViewModifier {
    @Binding var message: String?
    var style: AlertBannerStyle = .error
    var autoDismissAfter: TimeInterval? = 4

    @State private var dismissTask: DispatchWorkItem?

    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            content

            if let message, !message.isEmpty {
                AlertBanner(style: style, message: message)
                    .padding(.horizontal, Spacing.s16)
                    .padding(.top, Spacing.s8)
                    .zIndex(1)
                    .gesture(
                        DragGesture(minimumDistance: 12)
                            .onEnded { value in
                                if value.translation.height < 0 {
                                    dismiss()
                                }
                            }
                    )
                    .onTapGesture { dismiss() }
                    .onAppear { scheduleAutoDismiss() }
                    .onChange(of: message) { scheduleAutoDismiss() }
            }
        }
        .animation(CarelyMotion.springDefault, value: message)
    }

    private func scheduleAutoDismiss() {
        dismissTask?.cancel()
        guard let autoDismissAfter else { return }
        let task = DispatchWorkItem { dismiss() }
        dismissTask = task
        DispatchQueue.main.asyncAfter(deadline: .now() + autoDismissAfter, execute: task)
    }

    private func dismiss() {
        dismissTask?.cancel()
        withAnimation(CarelyMotion.springDefault) {
            message = nil
        }
    }
}

extension View {
    /// Attaches a floating, auto-dismissing error banner bound to an optional
    /// message string. Pass the exact server message
    /// (`(error as? NetworkError)?.errorDescription ?? error.localizedDescription`)
    /// rather than a hardcoded fallback.
    ///
    /// Usage:
    /// ```swift
    /// SomeScreen()
    ///     .errorToast($viewModel.errorMessage)
    /// ```
    func errorToast(
        _ message: Binding<String?>,
        style: AlertBannerStyle = .error,
        autoDismissAfter: TimeInterval? = 4
    ) -> some View {
        modifier(ErrorToastModifier(message: message, style: style, autoDismissAfter: autoDismissAfter))
    }
}
