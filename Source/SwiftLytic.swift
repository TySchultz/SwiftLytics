//
//  SwiftLytic.swift
//  SwiftLytics
//
//  Created by Tyler Schultz on 02/24/2020.
//  Copyright © 2020 Tyler Schultz. All rights reserved.
//

import UIKit
public class SwiftLytic {

    private var activeItem: SwiftLyticItem?

  private var cache: [Analytic] = []

  private var shouldShowAnalytics: Bool = true

    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(SwiftLytic.onOrientation(notification:)),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
    }

    // MARK: Public API

    public static let shared = SwiftLytic()

  public func show(
    in view: UIView? = nil,
    action: String,
    properties: [String: String],
    createdDate: Date? = nil,
    config: SwiftLytic.ViewConfiguration? = nil
  ) {
    guard shouldShowAnalytics else { return }
    let viewToUse: UIView?
    if view == nil, let top = UIApplication.shared.keyWindow?.rootViewController?.topMostChild {
      viewToUse = top.view
    } else {
      viewToUse = view
    }
    guard let baseView = viewToUse else { return }
    let analytic = Analytic(title: action, properties: properties, createdDate: createdDate ?? Date())
    // get rid of any view if currently displaying
    activeItem?.dismiss()

    let item = SwiftLyticItem(analytic: analytic,
                              config: config ?? SwiftLytic.ViewConfiguration(),
                              in: baseView)
    activeItem = item

    item.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(onPan(gesture:))))
    UIAccessibility.post(notification: UIAccessibility.Notification.announcement, argument: item.analytic.title)
    item.startTimer()

    self.cache.append(analytic)
  }

  public func showSessionAnalyticsList() {
    guard let top = UIApplication.shared.keyWindow?.rootViewController?.topMostChild else { return }
    // get rid of any view if currently displaying
    let viewController = SwiftLyticListViewController.Controller(items: self.cache)
    top.present(viewController, animated: true, completion: nil)
  }


    public func dismiss(completion: (() -> Void)? = nil) {
        activeItem?.dismiss(completion: completion)
        activeItem = nil
    }

    // MARK: Private API

    @objc func onPan(gesture: UIPanGestureRecognizer) {
        guard let activeItem = self.activeItem,
            let referenceView = activeItem.animator.referenceView
            else { return }

        switch gesture.state {
        case .began:
            activeItem.invalidateTimer()
            activeItem.animator.removeBehavior(activeItem.springBehavior)
        case .changed:
            let anchor = activeItem.springBehavior.anchorPoint
            let translation = gesture.translation(in: referenceView).y

            let y: CGFloat
            if translation < 0 {
                let unboundedY = anchor.y + translation
                y = rubberBandDistance(
                    offset: unboundedY - anchor.y,
                    dimension: referenceView.bounds.height - anchor.y
                )
            } else {
                y = translation
            }
            activeItem.view.center = CGPoint(
                x: anchor.x,
                y: y + anchor.y
            )
        case .ended, .cancelled, .failed:
            let velocity = gesture.velocity(in: referenceView).y

            // if the final destination is beyond the ref view height after 0.3 seconds...
            let duration: TimeInterval = 0.3
            let finalY = velocity * CGFloat(duration) + activeItem.view.center.y
            if finalY - activeItem.view.bounds.height / 2 > referenceView.bounds.height {
                UIView.animate(withDuration: duration, animations: {
                    var center = activeItem.view.center
                    center.y = finalY
                    activeItem.view.center = center
                }) { _ in
                    activeItem.view.removeFromSuperview()
                }
            } else {
                activeItem.startTimer()
                activeItem.animator.addBehavior(activeItem.springBehavior)
            }
        default: break
        }
    }

    @objc func onOrientation(notification: NSNotification) {
        activeItem?.recenter()
    }

  public func stopShowingAnalytics() {
    shouldShowAnalytics = false
  }

}
