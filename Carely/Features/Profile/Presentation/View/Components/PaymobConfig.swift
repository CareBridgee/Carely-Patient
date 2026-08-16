//
//  PaymobConfig.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 16/08/2026.
//


import UIKit
import SwiftUI
 
enum PaymobConfig {
    static let publicKey = "ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2ljSEp2Wm1sc1pWOXdheUk2TVRJeE5UUTNNQ3dpYm1GdFpTSTZJbWx1YVhScFlXd2lmUS5VVzMtZEVzVWFfdXRTcUpaQlYybkdwUkR1alB5cGNXV1lubjRZdVBRVC12QjNVMjJPYnphby05TktKV1NfckV4Z01KSGttMzYwenA3bHBfaEdHYTI0QQ=="
    static let integrationId = 5855102
       static let iframeId = 1069601
       static let currency = "EGP"

       /// Must exactly match the "Redirect URL" saved in Paymob Dashboard → this Integration.
       static let callbackURLHost = "carely-app.com/payment-callback"

       static let appIcon: UIImage? = UIImage(named: "logo")
       static let appName = "Etmaen"
       static let buttonBackgroundColor = UIColor(Color.brandPrimary)
       static let buttonTextColor = UIColor(Color.onPrimary)
   }
