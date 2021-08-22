//
//  ApplicationScheme.swift
//  BProtective
//
//  Created by Colin Chumak on 2021-01-27.
//  Copyright © 2021 DustyTheCutie. All rights reserved.
//

import Foundation
import UIKit

import MaterialComponents

class ApplicationScheme: NSObject {

  private static var singleton = ApplicationScheme()

  static var shared: ApplicationScheme {
    return singleton
  }

  override init() {
    self.buttonScheme.colorScheme = self.colorScheme as! MDCSemanticColorScheme
    self.buttonScheme.typographyScheme = self.typographyScheme as! MDCTypographyScheme
    super.init()
  }

  public let buttonScheme = MDCContainerScheme()

  public let colorScheme: MDCColorScheming = {
    let scheme = MDCSemanticColorScheme(defaults: .material201804)
    //TODO: Customize our app Colors after this line
    scheme.primaryColor =
      UIColor(red: 126/255.0, green: 213/255.0, blue: 234/255.0, alpha: 1.0)
    scheme.primaryColorVariant =
      UIColor(red: 105/255.0, green: 48/255.0, blue: 195/255.0, alpha: 1.0)
    scheme.onPrimaryColor =
      UIColor(red: 126/255.0, green: 213/255.0, blue: 234/255.0, alpha: 1.0)
    scheme.secondaryColor =
      UIColor(red: 83/255.0, green: 144/255.0, blue: 217/255.0, alpha: 1.0)
    scheme.onSecondaryColor =
      UIColor(red: 126/255.0, green: 213/255.0, blue: 234/255.0, alpha: 1.0)
    scheme.surfaceColor =
      UIColor(red: 46/255.0, green: 54/255.0, blue: 73/255.0, alpha: 1.0)
    scheme.onSurfaceColor =
      UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
    scheme.backgroundColor =
      UIColor(red: 72/255.0, green: 191/255.0, blue: 227/255.0, alpha: 1.0)
    scheme.onBackgroundColor =
      UIColor(red: 126/255.0, green: 213/255.0, blue: 234/255.0, alpha: 1.0)
    scheme.errorColor =
      UIColor(red: 100/255.0, green: 223/255.0, blue: 223/255.0, alpha: 1.0)
    return scheme
  }()

  public let typographyScheme: MDCTypographyScheming = {
    let scheme = MDCTypographyScheme()
    //TODO: Add our custom fonts after this line
    let fontName = "AppleSDGothicNeo-Heavy"
//    scheme.headline5 = UIFont(name: fontName, size: 24)!
//    scheme.headline6 = UIFont(name: fontName, size: 20)!
//    scheme.subtitle1 = UIFont(name: fontName, size: 16)!
//    scheme.button = UIFont(name: fontName, size: 26.0)!
    return scheme
  }()
}
