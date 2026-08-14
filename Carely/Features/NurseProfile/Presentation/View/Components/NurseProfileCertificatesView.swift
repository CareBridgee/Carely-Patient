import SwiftUI

struct NurseProfileCertificatesView: View {
    let profile: NurseDetails
    @State private var selectedCertificate: NurseDetails.Certificate?
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s12) {
            Text("Certificates")
                .carelyText(style: .bodyLarge, weight: .medium)
                .foregroundColor(Color.primaryFont)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.s16) {
                    ForEach(profile.certificates) { cert in
                        Button(action: {
                            selectedCertificate = cert
                        }) {
                            VStack(alignment: .leading, spacing: Spacing.s8) {
                                // Certificate Image Thumbnail
                                AsyncImage(url: URL(string: cert.imageUrl)) { phase in
                                    switch phase {
                                    case .empty:
                                        Rectangle()
                                            .fill(Color.surfaceVariant)
                                            .overlay(ProgressView())
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    case .failure:
                                        Rectangle()
                                            .fill(Color.surfaceVariant)
                                            .overlay(
                                                VStack(spacing: Spacing.s4) {
                                                    Image(systemName: "doc.text.fill")
                                                        .font(.title)
                                                        .foregroundColor(Color.brandPrimary.opacity(0.6))
                                                }
                                            )
                                    @unknown default:
                                        Rectangle()
                                            .fill(Color.surfaceVariant)
                                            .overlay(
                                                VStack(spacing: Spacing.s4) {
                                                    Image(systemName: "doc.text.fill")
                                                        .font(.title)
                                                        .foregroundColor(Color.brandPrimary.opacity(0.6))
                                                }
                                            )
                                    }
                                }
                                .frame(width: 180, height: 120)
                                .cornerRadius(Spacing.s8)
                                .clipped()
                                .overlay(
                                    RoundedRectangle(cornerRadius: Spacing.s8)
                                        .stroke(Color.divider, lineWidth: 1)
                                )
                                
                                Text(cert.name)
                                    .carelyText(style: .bodySmall, weight: .semiBold)
                                    .foregroundColor(Color.primaryFont)
                                    .lineLimit(1)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
        .fullScreenCover(item: $selectedCertificate) { cert in
            CertificateDetailView(certificate: cert)
        }
    }
}

// MARK: - Full Screen Certificate Detail View
private struct CertificateDetailView: View {
    let certificate: NurseDetails.Certificate
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: Spacing.s16) {
                // Header Bar
                HStack {
                    Text(certificate.name)
                        .font(.headline)
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                .padding(.horizontal, Spacing.s20)
                .padding(.top, Spacing.s16)
                
                Spacer()
                
                // Detailed Image View
                AsyncImage(url: URL(string: certificate.imageUrl)) { phase in
                    switch phase {
                    case .empty:
                        VStack(spacing: Spacing.s12) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            Text("Loading document...")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                        }
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.5), radius: 15)
                            .padding(.horizontal, Spacing.s16)
                    case .failure:
                        VStack(spacing: Spacing.s12) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.yellow)
                            Text("Unable to load document image")
                                .font(.callout)
                                .foregroundColor(.white)
                        }
                    @unknown default:
                        VStack(spacing: Spacing.s12) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.yellow)
                            Text("Unable to load document image")
                                .font(.callout)
                                .foregroundColor(.white)
                        }
                    }
                }
                
                Spacer()
            }
        }
    }
}
