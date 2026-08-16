# PaymobSDK

[![CI Status](https://img.shields.io/travis/mohamedghoneim@paymob.com/Paymob.svg?style=flat)](https://travis-ci.org/mohamedghoneim@paymob.com/Paymob)
[![Version](https://img.shields.io/cocoapods/v/Paymob.svg?style=flat)](https://cocoapods.org/pods/Paymob)
[![License](https://img.shields.io/cocoapods/l/Paymob.svg?style=flat)](https://cocoapods.org/pods/Paymob)
[![Platform](https://img.shields.io/cocoapods/p/Paymob.svg?style=flat)](https://cocoapods.org/pods/Paymob)

## Requirements

## Installation

PaymobSDK is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Paymob'
```

And in the general settings of your project, under libraried and frameworks
change the library from "Do not embed" to "Embed and Sign"

## Usage

import the framework
```swift
import PaymobSDK
```

add the delegate to the class, and add the protocol stubs
```swift
class ViewController: UIViewController, PaymobSDKDelegate {
```

then create a constant
```swift
let paymob = PaymobSDK()
```

then pass self to delegate
```swift
paymob.delegate = self
```

then create the variables
```swift
//set the saved cards as such if there is any
let savedCard_1 = SavedBankCard(token: "", maskedPanNumber: "", cardType: .MasterCard)

// Replace this string with your payment key
let client_secret = "" //Put Client Secret Here
let public_key = "" // Put Public Key Here
let savedCards = [] // Put Saved Cards Here

```

now call the function
```swift
do{
    try paymob.presentPayVC(VC: self, PublicKey: public_key, ClientSecret: client_secret, SavedBankCards: savedCards)
} catch let error {

}
```

you can customize the UI of the SDK such as
```swift
// the extra UI Customization parameters are

//sets the title to be the image you want
appIcon

//sets the title to be the name you want
appName

//changes the color of the buttons throughout the SDK, the default is black
buttonBackgroundColor

//changes the color of the buttons Texts throughout the SDK, the default is white
buttonTextColor

//set save card checkbox initial value, default value is false
saveCardDefault

//set whether or not should show save card checkbox, default value is true
showSaveCard

//used like this
let paymob = PaymobSDK()

paymob.paymobSDKCustomization.appIcon = UIImage()
paymob.paymobSDKCustomization.appName = ""
paymob.paymobSDKCustomization.buttonBackgroundColor = UIColor.black
paymob.paymobSDKCustomization.buttonTextColor = UIColor.white
paymob.paymobSDKCustomization.showSaveCard = true
paymob.paymobSDKCustomization.saveCardDefault = false

try paymob.presentPayVC(VC: self, PublicKey: public_key, ClientSecret: client_secret, SavedBankCards: userCardsTest)
```

        
```

## Author

mohamedghoneim@paymob.com

## License

Paymob is available under the MIT license. See the LICENSE file for more info.
