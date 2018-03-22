//
//  SDOSHero.swift
//  SDOSHero
//
//  Created by Antonio Jesús Pallares on 6/6/17.
//  Copyright © 2017 SDOS. All rights reserved.
//

import Foundation
import UIKit
import Hero

@objc public enum SDOSHeroAnimationType: Int {
    case auto = 0
    case pushLeft
    case pushRight
    case pushUp
    case pushDown
    case pullLeft
    case pullRight
    case pullUp
    case pullDown
    case coverLeft
    case coverRight
    case coverUp
    case coverDown
    case uncoverLeft
    case uncoverRight
    case uncoverUp
    case uncoverDown
    case slideLeft
    case slideRight
    case slideUp
    case slideDown
    case zoomSlideLeft
    case zoomSlideRight
    case zoomSlideUp
    case zoomSlideDown
    case pageInLeft
    case pageInRight
    case pageInUp
    case pageInDown
    case pageOutLeft
    case pageOutRight
    case pageOutUp
    case pageOutDown
    case fade
    case zoom
    case zoomOut
    case none
}


internal extension SDOSHeroAnimationType {
    var heroDefaultAnimationType: HeroDefaultAnimationType {
        let animationType: HeroDefaultAnimationType
        switch self {
        case .auto:
            animationType = .auto
        case .pushLeft:
            animationType = .push(direction: .left)
        case .pushRight:
            animationType = .push(direction: .right)
        case .pushUp:
            animationType = .push(direction: .up)
        case .pushDown:
            animationType = .push(direction: .down)
        case .pullLeft:
            animationType = .pull(direction: .left)
        case .pullRight:
            animationType = .pull(direction: .right)
        case .pullUp:
            animationType = .pull(direction: .up)
        case .pullDown:
            animationType = .pull(direction: .down)
        case .coverLeft:
            animationType = .cover(direction: .left)
        case .coverRight:
            animationType = .cover(direction: .right)
        case .coverUp:
            animationType = .cover(direction: .up)
        case .coverDown:
            animationType = .cover(direction: .down)
        case .uncoverLeft:
            animationType = .uncover(direction: .left)
        case .uncoverRight:
            animationType = .uncover(direction: .right)
        case .uncoverUp:
            animationType = .uncover(direction: .up)
        case .uncoverDown:
            animationType = .uncover(direction: .down)
        case .slideLeft:
            animationType = .slide(direction: .left)
        case .slideRight:
            animationType = .slide(direction: .right)
        case .slideUp:
            animationType = .slide(direction: .up)
        case .slideDown:
            animationType = .slide(direction: .down)
        case .zoomSlideLeft:
            animationType = .zoomSlide(direction: .left)
        case .zoomSlideRight:
            animationType = .zoomSlide(direction: .right)
        case .zoomSlideUp:
            animationType = .zoomSlide(direction: .up)
        case .zoomSlideDown:
            animationType = .zoomSlide(direction: .down)
        case .pageInLeft:
            animationType = .pageIn(direction: .left)
        case .pageInRight:
            animationType = .pageIn(direction: .right)
        case .pageInUp:
            animationType = .pageIn(direction: .up)
        case .pageInDown:
            animationType = .pageIn(direction: .down)
        case .pageOutLeft:
            animationType = .pageOut(direction: .left)
        case .pageOutRight:
            animationType = .pageOut(direction: .right)
        case .pageOutUp:
            animationType = .pageOut(direction: .up)
        case .pageOutDown:
            animationType = .pageOut(direction: .down)
        case .fade:
            animationType = .fade
        case .zoom:
            animationType = .zoom
        case .zoomOut:
            animationType = .zoomOut
        case .none:
            animationType = .none
        }
        return animationType
    }
}


internal extension HeroDefaultAnimationType {
    
    var sdosHeroAnimationTypeForPresenting: SDOSHeroAnimationType {
        
        let sdosHeroAnimationType: SDOSHeroAnimationType
        if case HeroDefaultAnimationType.selectBy(presenting: let presenting, dismissing: _) == self {
            return HeroDefaultAnimationType.sdosHeroAnimationTypeFrom(basicHeroDefaultAnimationType: presenting)
        } else {
            return HeroDefaultAnimationType.sdosHeroAnimationTypeFrom(basicHeroDefaultAnimationType: self)
        }
    }
    
    var sdosHeroAnimationTypeForDismissing: SDOSHeroAnimationType {
        let sdosHeroAnimationType: SDOSHeroAnimationType
        if case HeroDefaultAnimationType.selectBy(presenting: _, dismissing: let dismissing) == self {
            return HeroDefaultAnimationType.sdosHeroAnimationTypeFrom(basicHeroDefaultAnimationType: dismissing)
        } else {
            return HeroDefaultAnimationType.sdosHeroAnimationTypeFrom(basicHeroDefaultAnimationType: self)
        }
    }
    
    // This method only works for the HeroDefaultAnimationType that is not of the case .selectBy. If type is of case .selectBy, it returns SDOSHeroAnimationType.auto
    private static func sdosHeroAnimationTypeFrom(basicHeroDefaultAnimationType type: HeroDefaultAnimationType) -> SDOSHeroAnimationType {
        let animationType: SDOSHeroAnimationType
        switch type {
        case .push(direction: .left)
            animationType = .pushLeft:
        case .push(direction: .right):
            animationType = .pushRight
        case .push(direction: .up):
            animationType = .pushUp
        case .push(direction: .down):
            animationType = .pushDown
        case .pull(direction: .left):
            animationType = .pullLeft
        case .pull(direction: .right):
            animationType = .pullRight
        case .pull(direction: .up):
            animationType = .pullUp
        case .pull(direction: .down):
            animationType = .pullDown
        case .cover(direction: .left):
            animationType = .coverLeft
        case .cover(direction: .right):
            animationType = .coverRight
        case .cover(direction: .up):
            animationType = .coverUp
        case .cover(direction: .down):
            animationType = .coverDown
        case .uncover(direction: .left):
            animationType = .uncoverLeft
        case .uncover(direction: .right):
            animationType = .uncoverRight
        case .uncover(direction: .up):
            animationType = .uncoverUp
        case .uncover(direction: .down):
            animationType = .uncoverDown
        case .slide(direction: .left)
            animationType = .slideLeft:
        case .slide(direction: .right):
            animationType = .slideRight
        case .slide(direction: .up):
            animationType = .slideUp
        case .slide(direction: .down):
            animationType = .slideDown
        case .zoomSlide(direction: .left):
            animationType = .zoomSlideLeft
        case .zoomSlide(direction: .right):
            animationType = .zoomSlideRight
        case .zoomSlide(direction: .up):
            animationType = .zoomSlideUp
        case .zoomSlide(direction: .down):
            animationType = .zoomSlideDown
        case .pageIn(direction: .left):
            animationType = .pageInLeft
        case .pageIn(direction: .right):
            animationType = .pageInRight
        case .pageIn(direction: .up):
            animationType = .pageInUp
        case .pageIn(direction: .down):
            animationType = .pageInDown
        case .pageOut(direction: .left):
            animationType = .pageOutLeft
        case .pageOut(direction: .right):
            animationType = .pageOutRight
        case .pageOut(direction: .up):
            animationType = .pageOutUp
        case .pageOut(direction: .down):
            animationType = .pageOutDown
        case .fade:
            animationType = .fade
        case .zoom:
            animationType = .zoom
        case .zoomOut:
            animationType = .zoomOut
        case .none:
            animationType = .none
        default:
            animationType = .auto
        }
        return animationType
        }
    }
}

fileprivate extension HeroDefaultAnimationType.Direction {
    var oppositeDirection: HeroDefaultAnimationType.Direction {
        switch self {
        case .left:
            return .right
        case .right:
            return .left
        case .down:
            return .up
        case .up:
            return .down
        }
    }
}

internal extension HeroDefaultAnimationType {
    var oppositeAnimationType: HeroDefaultAnimationType {
        switch self {
        case .pageIn(direction: let direction):
            return .pageOut(direction: direction.oppositeDirection)
        case .pageOut(direction: let direction):
            return .pageIn(direction: direction.oppositeDirection)
        case .pull(direction: let direction):
            return .push(direction: direction.oppositeDirection)
        case .push(direction: let direction):
            return .pull(direction: direction.oppositeDirection)
        case .cover(direction: let direction):
            return .uncover(direction: direction.oppositeDirection)
        case .uncover(direction: let direction):
            return .cover(direction: direction.oppositeDirection)
        case .zoom:
            return .zoomOut
        case .zoomOut:
            return .zoom
        case .slide(direction: let direction):
            return .slide(direction: direction.oppositeDirection)
        case .zoomSlide(direction: let direction):
            return .zoomSlide(direction: direction.oppositeDirection)
        default:
            return self
        }
    }
    
}
