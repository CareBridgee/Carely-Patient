import SwiftUI
import CoreImage.CIFilterBuiltins

struct ArrivalQRCodeView: View {
    @StateObject private var viewModel: ArrivalQRCodeViewModel
    
    init(viewModel: ArrivalQRCodeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: Spacing.s24) {
                    
                    // Titles
                    VStack(spacing: Spacing.s12) {
                        Text("Arrival QR Code")
                            .carelyText(style: .heading2, weight: .semiBold)
                            .foregroundColor(Color.brandPrimary)
                        
                        Text("Show this code to your nurse upon\narrival to verify the visit.")
                            .carelyText(style: .bodyRegular)
                            .foregroundColor(Color.secondaryFont)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, Spacing.s32)
                    
                    // QR Code Card
                    VStack(spacing: Spacing.s20) {
                        Image(uiImage: generateQRCode(from: viewModel.qrCodeData))
                            .interpolation(.none)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                        
                        VStack(spacing: Spacing.s4) {
                            Text("VISIT REFERENCE")
                                .carelyText(style: .caption, weight: .medium)
                                .foregroundColor(Color.secondaryFont)
                                .textCase(.uppercase)
                            
                            Text(viewModel.referenceNumber)
                                .carelyText(style: .bodyLarge, weight: .semiBold)
                                .foregroundColor(Color.primaryFont)
                        }
                    }
                    .padding(Spacing.s24)
                    .background(Color.surface)
                    .cornerRadius(Spacing.s16)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                    
                    // Secure Pill
                    HStack(spacing: Spacing.s8) {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 14))
                        Text("Secure Patient Verification")
                            .carelyText(style: .bodySmall, weight: .medium)
                    }
                    .foregroundColor(Color.brandPrimary)
                    .padding(.horizontal, Spacing.s16)
                    .padding(.vertical, Spacing.s8)
                    .background(Color.brandPrimary.opacity(0.1))
                    .cornerRadius(100)
                    
                }
                .padding(.horizontal, Spacing.s20)
            }
            
            // Close Button
            VStack {
                Button(action: {
                    viewModel.close()
                }) {
                    Text("Close")
                        .carelyText(style: .bodyLarge, weight: .semiBold)
                        .foregroundColor(Color.brandPrimary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.surface)
                        .cornerRadius(100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 100)
                                .stroke(Color.brandPrimary, lineWidth: 1)
                        )
                }
            }
            .padding(.horizontal, Spacing.s20)
            .padding(.top, Spacing.s16)
            .padding(.bottom, Spacing.s24)
            .background(Color.backGround.ignoresSafeArea(edges: .bottom))
        }
        .background(Color.backGround.ignoresSafeArea())
        .navigationBarHidden(true)
        Spacer(minLength: Spacing.s56)

    }
    
    private func generateQRCode(from string: String) -> UIImage {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage {
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let scaledImage = outputImage.transformed(by: transform)
            
            if let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        
        return UIImage(systemName: "qrcode") ?? UIImage()
    }
}

#Preview {
    let viewModel = ArrivalQRCodeViewModel(qrCodeData: "carely-bkg-1", referenceNumber: "#HOSP-7729-BK", onClose: {})
    return ArrivalQRCodeView(viewModel: viewModel)
}
