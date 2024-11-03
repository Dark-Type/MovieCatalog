//
//  ColorsEnum.swift
//  MovieCatalog
//
//  Created by dark type on 23.10.2024.
//

import UIKit
import SwiftUI
enum ColorsEnum {
    static let orangeGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 223/255, green: 40/255, blue: 0, alpha: 1).cgColor,
            UIColor(red: 255/255, green: 102/255, blue: 51/255, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        return gradient
    }()

    static let baseGrey: UIColor = {
        return UIColor(named: "BaseGrey") ?? UIColor.gray
    }()

    static let baseDarkGrey: UIColor = {
        return UIColor(named: "BaseDarkGrey") ?? UIColor.darkGray
    }()

    static let greyFaded: UIColor = {
        return UIColor(named: "GreyFaded") ?? UIColor.gray
    }()

    static let subTitleGrey: UIColor = {
        return UIColor(named: "SubTitleGrey") ?? UIColor.gray
    }()
    static let orangeLinearGradient: LinearGradient = {
        LinearGradient(
            gradient: Gradient(colors: [Color(red: 223/255, green: 40/255, blue: 0), Color(red: 255/255, green: 102/255, blue: 51/255)]),
            startPoint: UnitPoint(x: 0, y: 0.5),
            endPoint: UnitPoint(x: 1, y: 0.5)
        )    }()
  
}
