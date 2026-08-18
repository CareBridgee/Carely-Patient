//
//  PaymobWebView.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 16/08/2026.
//


import SwiftUI
@preconcurrency import WebKit

struct PaymobWebView: UIViewControllerRepresentable {
    let url: URL
    /// Called exactly once: true on confirmed success, false on failure,
    /// rejection, or a load error the user can't recover from in-sheet.
    let completion: (Bool) -> Void

    func makeUIViewController(context: Context) -> PaymobWebViewController {
        let controller = PaymobWebViewController()
        controller.url = url
        controller.completion = completion
        return controller
    }

    func updateUIViewController(_ uiViewController: PaymobWebViewController, context: Context) {}
}

final class PaymobWebViewController: UIViewController, WKNavigationDelegate {
    var url: URL!
    var completion: ((Bool) -> Void)?

    private var webView: WKWebView!
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let errorView = UILabel()
    private var didComplete = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)

        errorView.text = "Couldn't load the payment page.\nCheck your connection and try again."
        errorView.numberOfLines = 0
        errorView.textAlignment = .center
        errorView.textColor = .secondaryLabel
        errorView.isHidden = true
        errorView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(errorView)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            errorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])

        activityIndicator.startAnimating()
        webView.load(URLRequest(url: url))
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let urlStr = navigationAction.request.url?.absoluteString else {
            decisionHandler(.allow)
            return
        }

        if urlStr.contains(PaymobConfig.callbackURLHost) {
            let success = urlStr.contains("success=true")
            decisionHandler(.cancel)
            finish(success: success)
            return
        }

        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        // Once a result was already reported (e.g. we matched the callback
        // URL and cancelled the navigation ourselves), any subsequent
        // "load failed" callback — including WebKitErrorDomain code 102 —
        // is expected noise from that cancellation, not a real failure.
        guard !didComplete else { return }
        showLoadFailure()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        guard !didComplete else { return }
        showLoadFailure()
    }

    private func showLoadFailure() {
        activityIndicator.stopAnimating()
        errorView.isHidden = false
        finish(success: false)
    }

    /// Guards against completion firing twice (e.g. a load error right
    /// after a redirect already matched).
    private func finish(success: Bool) {
        guard !didComplete else { return }
        didComplete = true
        completion?(success)
    }
}
