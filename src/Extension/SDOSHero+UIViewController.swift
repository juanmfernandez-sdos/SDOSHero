//
//  SDOSHero+UIViewController.swift
//  SDOSHero
//
//  Created by Antonio Jesús Pallares on 13/7/17.
//

import Hero


extension UIViewController {
    
    internal static var AssociatedKeyDesiredHeroDefaultAnimationType = "SDOSHero.desiredHeroDefaultAnimationType"
    
    /// This property stores the animation type set using the 3 methods setSDOSHeroAnimationTypeForModalPresentation:, setSDOSHeroAnimationTypeForModalDismissal and setSDOSHeroAnimationTypeForModalPresentation:forModalDismissal:
    ///
    /// By default, the animation types for presentations and dismissals are .auto.
    ///
    /// Setting only the animation type for presentation (with setSDOSHeroAnimationTypeForModalPresentation:) sets the desired animation type only for that animation type (and viceversa with setSDOSHeroAnimationTypeForModalDismissal:). In this case, the desired animation type for dismissal would remain unchanged (and viceversa).
    ///
    /// However, the actual heroDefaultAnimationType (the one that takes effect) may not coincide with the desired animation type.
    ///
    /// The reason is that SDOSHero translates .auto as the opposite animation of the contrary action (presentation or dismissal). Therefore, if the desired animation type for presentation is, e.g., zoom in and the desired animation type for dismissal is auto, then the actual heroDefaultAnimationType is set to zoom in for presentation and zoom out for dismissal.
    private var desiredHeroDefaultAnimationType: HeroDefaultAnimationType {
        get {
            if let type = objc_getAssociatedObject(self, &UIViewController.AssociatedKeyDesiredHeroDefaultAnimationType) as? HeroDefaultAnimationType {
                return type
            }
            let type = HeroDefaultAnimationType.auto
            self.desiredHeroDefaultAnimationType = type
            return type
        }
        set { objc_setAssociatedObject(self, &UIViewController.AssociatedKeyDesiredHeroDefaultAnimationType, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    
    //MARK: - Getting the animation types
    
    /// The current animation type of the receiver for modal presentations.
    ///
    /// If set to `.auto`, then the animation for the modal presentation will be the opposite animation to that in `animationTypeForDismissing`.
    /// If `animationTypeForDismissing` is also `.auto`, then the animation for the modal presentation will be the default animation for Hero, that is, fade.
    ///
    /// - Important: The receiver must be the view controller that is going to be presented (do not confuse with the presenting view controller).
    @objc public var animationTypeForPresenting: SDOSHeroAnimationType {
        get {
            return desiredHeroDefaultAnimationType.sdosHeroAnimationTypeForPresenting
        }
        set {
            let heroPresentationType = newValue.heroDefaultAnimationType
            switch desiredHeroDefaultAnimationType {
            case .selectBy(presenting: _, dismissing: let currentDesiredDismissalType):
                desiredHeroDefaultAnimationType = .selectBy(presenting: heroPresentationType, dismissing: currentDesiredDismissalType)
            default:
                desiredHeroDefaultAnimationType = .selectBy(presenting: heroPresentationType, dismissing: .auto)
            }
            
            updateHeroModalAnimationType()
        }
    }
    
    /// The current animation type of the receiver for modal dismissals.
    ///
    /// If set to `.auto`, then the animation for the modal dismissal will be the opposite animation to that in `animationTypeForPresenting`.
    /// If `animationTypeForPresenting` is also `.auto`, then the animation for modal dismissals will be the default animation for Hero, that is, fade.
    ///
    /// - Important: The receiver must be the view controller that is going to be dismissed (do not confuse with the presenting view controller).
    @objc public var animationTypeForDismissing: SDOSHeroAnimationType {
        get {
            return desiredHeroDefaultAnimationType.sdosHeroAnimationTypeForDismissing
        }
        set {
            let heroDismissalType = newValue.heroDefaultAnimationType
            switch desiredHeroDefaultAnimationType {
            case .selectBy(presenting: let currentDesiredPresentationType, dismissing: _):
                desiredHeroDefaultAnimationType = .selectBy(presenting: currentDesiredPresentationType, dismissing: heroDismissalType)
            default:
                desiredHeroDefaultAnimationType = .selectBy(presenting: .auto, dismissing: heroDismissalType)
            }
            
            updateHeroModalAnimationType()
        }
    }
    
    
    /// Method used to set the Hero animation type for modal presentations and dismissals of the receiver. Passing .auto for both parameters will cause the modal transitions to be performed using the default animations provided by the system. Setting the animation type to .auto for only one transition will cause that transition to be animated with the opposite animation type of the other passed animation type.
    /// - Important: The receiver must be the view controller that is going to be presented and/or dismissed (do not confuse with the presenting view controller).
    ///
    /// - Parameter presentationType: The type of the animation for the modal presentation
    /// - Parameter dismissalType: The type of the animation for the modal dismissal
    @objc public func setSDOSHeroAnimationTypeForModalPresenting(_ presentationType: SDOSHeroAnimationType, forModalDismissing dismissalType: SDOSHeroAnimationType) {
        
        let heroPresentationType = presentationType.heroDefaultAnimationType
        let heroDismissalType = dismissalType.heroDefaultAnimationType
        desiredHeroDefaultAnimationType = .selectBy(presenting: heroPresentationType, dismissing: heroDismissalType)
        
        updateHeroModalAnimationType()
    }
    
    /// This method copies the type of the modal presentation of `viewController` and sets it on the receiver.
    ///
    /// - Parameter viewController: The view controller from which to copy the hero modal animation type
    @objc public func copyModalSDOSHeroAnimationTypeFrom(viewController: UIViewController) {
        
        desiredHeroDefaultAnimationType = viewController.desiredHeroDefaultAnimationType
        
        updateHeroModalAnimationType()
    }
    
    
    private func updateHeroModalAnimationType() {
        switch desiredHeroDefaultAnimationType {
        case .selectBy(presenting: .auto, dismissing: .auto):
            hero.modalAnimationType = .auto
        case .selectBy(presenting: let presenting, dismissing: .auto):
            hero.modalAnimationType = .selectBy(presenting: presenting, dismissing: presenting.oppositeAnimationType)
        case .selectBy(presenting: .auto, dismissing: let dismissing):
            hero.modalAnimationType = .selectBy(presenting: dismissing.oppositeAnimationType, dismissing: dismissing)
        default:
            hero.modalAnimationType = desiredHeroDefaultAnimationType
        }
    }
    
    
    //MARK: - Present methods
    
    /// Presents a view controller modall using the passed animation for the transition.
    ///
    /// - Parameters:
    ///   - viewController: The view controller to display over the current view controller’s content.
    ///   - animationType: The type of the animation for the modal transition.
    @objc public func presentViewController(_ viewController: UIViewController, usingAnimation animationType: SDOSHeroAnimationType) {
        presentViewController(viewController, usingAnimation: animationType, completion: nil)
    }
    
    /// Presents a view controller modall using the passed animation for the transition.
    ///
    /// - Parameters:
    ///   - viewController: The view controller to display over the current view controller’s content.
    ///   - animationType: The type of the animation for the modal transition.
    ///   - completion: The block to execute after the presentation finishes. This block has no return value and takes no parameters. You may specify nil for this parameter.
    @objc public func presentViewController(_ viewController: UIViewController, usingAnimation animationType: SDOSHeroAnimationType, completion: (() -> Void)?) {
        let currentAnimationType = viewController.hero.modalAnimationType
        viewController.hero.modalAnimationType = animationType.heroDefaultAnimationType
        present(viewController, animated: true, completion: completion)
        viewController.hero.modalAnimationType = currentAnimationType
    }
    
    
    //MARK: - Dismiss methods
    
    /// Dismisses the view controller that was presented modally by the view controller.
    ///
    /// - Parameter animationType: The type of the animation for the modal transition.
    @objc public func dismissViewControllerUsingAnimation(_ animationType: SDOSHeroAnimationType) {
        dismissViewControllerUsingAnimation(animationType, completion: nil)
    }
    
    /// Dismisses the view controller that was presented modally by the view controller.
    ///
    /// - Parameter animationType: The type of the animation for the modal transition.
    /// - completion: The block to execute after the view controller is dismissed. This block has no return value and takes no parameters. You may specify nil for this parameter.
    @objc public func dismissViewControllerUsingAnimation(_ animationType: SDOSHeroAnimationType, completion: (() -> Void)?) {
        
        // Only change the hero.modalAnimationType for the controller that is going to be dismissed
        let lastPresentedViewController = self.lastPresentedViewController()
        let currentAnimationType = lastPresentedViewController.hero.modalAnimationType
        lastPresentedViewController.hero.modalAnimationType = animationType.heroDefaultAnimationType
        dismiss(animated: true, completion: completion)
        lastPresentedViewController.hero.modalAnimationType = currentAnimationType
    }
    
    
    /// Dismisses at once all the modally presented view controllers in the stack using Hero.
    /// This method can be called on any of the view controllers in the modal stack
    @objc public func dismissAllPresentedViewControllers() {
        guard lastPresentedViewController().presentingViewController != nil else {
            NSLog("Attempted to dismiss a view controller that has no presenting view controller: \(self). Nothing will happen")
            return
        }
        hero.unwindToRootViewController()
    }
    
    
    /// Dismisses at once all the modally presented view controllers in the stack using the passed animation.
    /// This method can be called on any of the view controllers in the modal stack
    ///
    /// - Parameter type: The animation used to dismiss all the presented view controllers
    @objc public func dismissAllViewControllersUsingAnimation(_ type: SDOSHeroAnimationType) {
        let lastPresentedViewController = self.lastPresentedViewController()
        guard lastPresentedViewController.presentingViewController != nil else {
            NSLog("Attempted to dismiss a view controller that has no presenting view controller: \(self). Nothing will happen")
            return
        }
        let heroAnimationType = type.heroDefaultAnimationType
        
        // The animation type of lastPresentedViewController is only changed for this transition
        let currentAnimationType = lastPresentedViewController.hero.modalAnimationType
        
        lastPresentedViewController.hero.modalAnimationType = HeroDefaultAnimationType.autoReverse(presenting: heroAnimationType.oppositeAnimationType)
        lastPresentedViewController.hero.unwindToRootViewController()
        
        // After the transition, the animation type of lastPresentedViewController is set to its original value
        lastPresentedViewController.hero.modalAnimationType = currentAnimationType
    }

    
    //MARK: - Enabling/Disabling Hero
    
    /// **sdosHeroIsEnabled** allows to specify whether a view controller should be considered for animations.
    /// If YES, Hero will search through all the subviews for heroIds and modifiers. Defaults to NO
    @objc public var sdosHeroIsEnabled: Bool {
        get {
            return hero.isEnabled
        }
        set {
            hero.isEnabled = newValue
        }
    }
    
    
    //MARK: - Helper methods
    
    fileprivate func lastPresentedViewController() -> UIViewController {
        var presented = self
        while let nextPresented = presented.presentedViewController {
            presented = nextPresented
        }
        
        return presented
    }
    
}
