//
//  CustomExpandAnimator.swift
//  WeatherApp
//
//  Created by Tayfun Sener on 23.07.2024.
//


import UIKit

class CustomExpandAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var isPresenting: Bool = true
    var originFrame: CGRect = .zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to) else {
            return
        }
        
        let initialFrame = isPresenting ? originFrame : transitionContext.finalFrame(for: fromVC)
        let finalFrame = isPresenting ? transitionContext.finalFrame(for: toVC) : originFrame
        
        let animatingView = isPresenting ? toVC.view! : fromVC.view!
        
        if isPresenting {
            containerView.addSubview(toVC.view)
            animatingView.frame = initialFrame
            animatingView.layer.cornerRadius = 20
            animatingView.clipsToBounds = true
        }
        
        let cornerRadius: CGFloat = isPresenting ? 0 : 20
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            animatingView.frame = finalFrame
            animatingView.layer.cornerRadius = cornerRadius
        }) { (completed) in
            transitionContext.completeTransition(completed)
        }
    }
}

class CustomTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    var originFrame: CGRect = .zero
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = CustomExpandAnimator()
        animator.isPresenting = true
        animator.originFrame = originFrame
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = CustomExpandAnimator()
        animator.isPresenting = false
        animator.originFrame = originFrame
        return animator
    }
}
