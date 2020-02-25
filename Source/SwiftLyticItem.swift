//
//  SwiftLyticItem.swift
//  SwiftLytics
//
//  Created by Tyler Schultz on 02/24/2020.
//  Copyright © 2020 Tyler Schultz. All rights reserved.
//

import UIKit

internal final class SwiftLyticItem: SwiftLyticViewDelegate {

    let view: SwiftLyticView
    let animator: UIDynamicAnimator
    let springBehavior: UIAttachmentBehavior
    let configuration: SwiftLytic.ViewConfiguration
    var analytic: Analytic

    private var timer: Timer?

  init(analytic: Analytic, config: SwiftLytic.ViewConfiguration, in baseView: UIView) {
        configuration = config
        self.analytic = analytic
        if self.analytic.createdDate == nil {
          self.analytic.createdDate = Date()
        }

        view = SwiftLyticView(analytic: analytic, configuration: config)
        view.frame = CGRect(origin: .zero, size: view.contentSize())
        baseView.addSubview(view)

        animator = UIDynamicAnimator(referenceView: baseView)

        let initAnchor = anchor(view: view, referenceView: baseView, configuration: configuration)

        // position off screen so it snaps in. must happen before setting up spring
        view.center = initAnchor.applying(CGAffineTransform(
            translationX: 0,
            y: baseView.bounds.height - initAnchor.y
        ))

        springBehavior = UIAttachmentBehavior(item: view, attachedToAnchor: initAnchor)
        springBehavior.length = 0
        springBehavior.damping = 0.9
        springBehavior.frequency = 2

        // use UIView animations to avoid annoying oscillation from behavior
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.1,
            options: [],
            animations: {
                self.view.center = initAnchor
        }) { _ in
            guard self.view.superview != nil else { return }
            self.animator.addBehavior(self.springBehavior)
        }

        view.delegate = self
    }

    // MARK: Public API

    func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }

    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            withTimeInterval: configuration.dismissDuration,
            repeats: false,
            block: { [weak self] (_) in
                self?.dismiss()
        })
    }

    func dismiss(completion: (() -> Void)? = nil) {
        invalidateTimer()
        animator.removeBehavior(springBehavior)

        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
            self.view.alpha = 0
            self.view.center = self.dismissAnchor
        }, completion: { _ in
            self.view.removeFromSuperview()
            completion?()
        })
    }

    func recenter() {
        // UIDynamics will throw if adding the behavior back when the view has already been removed
        guard view.superview != nil,
            let referenceView = animator.referenceView
            else { return }

        // hack to work around UI bug where behavior will permanently oscillate
        animator.removeBehavior(springBehavior)
        springBehavior.anchorPoint = anchor(view: view, referenceView: referenceView, configuration: configuration)
        animator.addBehavior(springBehavior)
    }

    // MARK: Private API

    private var dismissAnchor: CGPoint {
        guard let referenceView = animator.referenceView else { return .zero }
        return CGPoint(
            x: referenceView.bounds.width / 2,
            y: referenceView.bounds.height + view.bounds.height / 2 + 100
        )
    }

    // MARK: SwiftLyticViewDelegate

    func didTapInfo(for view: SwiftLyticView) {
        configuration.buttonTapHandler?()
    }

}
