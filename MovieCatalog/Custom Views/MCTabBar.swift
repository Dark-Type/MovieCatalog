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
    static let backgroundColor = ColorsEnum.baseGrey
}

class MCTabBar: UITabBar {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customizeTabBar()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.customizeTabBar()
    }

    private func customizeTabBar() {
        self.layer.cornerRadius = MCTabBarResources.cornerRadius
        self.layer.masksToBounds = true

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = MCTabBarResources.backgroundColor

        if let gradientTextImage = createGradientImage(size: CGSize(width: 200, height: 20)) {
            let gradientColor = UIColor(patternImage: gradientTextImage)
            appearance.stackedLayoutAppearance.selected.iconColor = gradientColor
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: gradientColor]
        }
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.gray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]

        self.standardAppearance = appearance

        self.scrollEdgeAppearance = appearance
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

    private func createGradientImage(size: CGSize) -> UIImage? {
        let gradientLayer = ColorsEnum.orangeGradient()
        gradientLayer.frame = CGRect(origin: .zero, size: size)

        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            gradientLayer.render(in: context.cgContext)
        }
    }
}
