//
//  MCTabBar.swift
//  MovieCatalog
//
//  Created by dark type on 13.10.2024.
//

import UIKit

enum MCTabBarResources {
    static let cornerRadius: CGFloat = 20
    static let tabBarHeight: CGFloat = 70
    static let tabBarBottomOffset: CGFloat = 20
    static let tabBarHorizontalPadding: CGFloat = 25
    static let tabBarWidthOffset: CGFloat = 50
    static let gradientColors = ColorsEnum.orangeGradient
    static let backgroundColor = ColorsEnum.baseGrey
}

class MCTabBar: UITabBar {
    override init(frame: CGRect) {
        super.init(frame: frame)
        customizeTabBar()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customizeTabBar()
    }

    private func customizeTabBar() {
        self.layer.cornerRadius = MCTabBarResources.cornerRadius
        self.layer.masksToBounds = true

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = MCTabBarResources.backgroundColor

        let gradientTextImage = createGradientImage(colors: MCTabBarResources.gradientColors.colors as! [CGColor], size: CGSize(width: 1, height: 1))
        let gradientColor = UIColor(patternImage: gradientTextImage!)

        appearance.stackedLayoutAppearance.selected.iconColor = gradientColor
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: gradientColor]

        self.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            self.scrollEdgeAppearance = appearance
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let superview = self.superview else { return }

        var tabFrame = self.frame
        tabFrame.size.height = MCTabBarResources.tabBarHeight
        tabFrame.origin.y = superview.frame.height - tabFrame.size.height - MCTabBarResources.tabBarBottomOffset
        tabFrame.origin.x = MCTabBarResources.tabBarHorizontalPadding
        tabFrame.size.width = superview.frame.width - MCTabBarResources.tabBarWidthOffset
        self.frame = tabFrame
    }

    private func createGradientImage(colors: [CGColor], size: CGSize) -> UIImage? {
        let gradientLayer = ColorsEnum.orangeGradient
        gradientLayer.frame = CGRect(origin: .zero, size: size)

        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            gradientLayer.render(in: context.cgContext)
        }
    }
}
