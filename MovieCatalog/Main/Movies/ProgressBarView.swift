//
//  ProgressionBarView.swift
//  MovieCatalog
//
//  Created by dark type on 27.10.2024.
//

import UIKit

class ProgressBarView: UIView {
    private var bars: [UIView] = []
    private var barCount: Int = 0

    func setupBars(count: Int) {
        barCount = count
        bars.forEach { $0.removeFromSuperview() }
        bars.removeAll()

        for _ in 0..<count {
            let bar = UIView()
            bar.backgroundColor = .gray
            bar.layer.cornerRadius = 2.5
            bar.clipsToBounds = true
            addSubview(bar)
            bars.append(bar)
        }

        setNeedsLayout()
        if barCount > 0 {
            updateProgress(index: 0, progress: 1.0)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let barWidth = (bounds.width - CGFloat(barCount - 1) * 5) / CGFloat(barCount)
        for (index, bar) in bars.enumerated() {
            bar.frame = CGRect(
                x: CGFloat(index) * (barWidth + 5),
                y: 0,
                width: barWidth,
                height: bounds.height
            )
        }
    }

    func updateProgress(index: Int, progress: CGFloat) {
        guard index < bars.count else { return }
        let barWidth = (bounds.width - CGFloat(barCount - 1) * 5) / CGFloat(barCount)
        for (i, bar) in bars.enumerated() {
            if i < index {
                bar.backgroundColor = .orange
                bar.frame.size.width = barWidth
            } else if i == index {
                let progressBar = UIView()
                progressBar.backgroundColor = .orange
                progressBar.layer.cornerRadius = 2.5
                progressBar.clipsToBounds = true
                progressBar.frame = CGRect(
                    x: CGFloat(index) * (barWidth + 5),
                    y: 0,
                    width: 0,
                    height: bounds.height
                )
                addSubview(progressBar)
                UIView.animate(withDuration: 5.0) { [weak self] in
                    if self == nil { return }
                    progressBar.frame.size.width = barWidth * progress
                }
            } else {
                bar.backgroundColor = .gray
                bar.frame.size.width = barWidth
            }
        }
    }

    func fillCurrentBar(index: Int) {
        guard index < bars.count else { return }
        let bar = bars[index]
        let barWidth = (bounds.width - CGFloat(barCount - 1) * 5) / CGFloat(barCount)
        UIView.animate(withDuration: 0.5) { [weak self] in
            if self == nil { return }
            bar.backgroundColor = .orange
            bar.frame.size.width = barWidth
        }
    }

    func clearBars() {
        bars.forEach { $0.removeFromSuperview() }
        bars.removeAll()
    }

    func goToPreviousBar(index: Int) {
        guard index < bars.count, index > 0 else { return }
        let currentBar = bars[index]
        let previousBar = bars[index - 1]

        currentBar.layer.removeAllAnimations()
        currentBar.subviews.forEach { $0.removeFromSuperview() }
        currentBar.backgroundColor = .gray
        currentBar.frame.size.width = 0
 
        previousBar.layer.removeAllAnimations()
        previousBar.subviews.forEach { $0.removeFromSuperview() }
        previousBar.backgroundColor = .gray
        previousBar.frame.size.width = 0

        updateProgress(index: index - 1, progress: 1.0)
    }
    func goToNextBar(index: Int) {
        guard index < bars.count else { return }
        if index == bars.count - 1 {
            clearBars()
            return
        }
        let currentBar = bars[index]

        UIView.animate(withDuration: 0, animations: { [weak self] in
            if self == nil { return }
            currentBar.backgroundColor = .orange
            currentBar.frame.size.width = (self?.bounds.width ?? 0 - CGFloat(self?.barCount ?? 0 - 1) * 5) / CGFloat(self?.barCount ?? 0)
        }) { [weak self] _ in
            if self == nil { return }
            self?.updateProgress(index: index + 1, progress: 1.0)
        }
    }
}
