//
//  Hero+Autolayout.swift
//  SDOSHero
//
//  Created by Antonio Jesús Pallares on 30/11/17.
//  Copyright © 2017 SDOS. All rights reserved.
//


// https://github.com/lkzhao/Hero/issues/305

import Hero

extension HeroModifier {
    static var autolayout: HeroModifier {
        return HeroModifier { targetState in
            targetState[HeroAutolayoutFixPlugin.modifier] = true
        }
    }
}

fileprivate class HeroAutolayoutFixPlugin: HeroPlugin {
    static let modifier = "turnOnTranslatedAutoresizingMaskWhileAnimation"
    
    override func process(fromViews: [UIView], toViews: [UIView]) {
        let modifier = type(of: self).modifier
        
        fromViews
            .filter { context[$0]?[modifier] as? Bool == true }
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = true }
        
        toViews
            .filter { context[$0]?[modifier] as? Bool == true }
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = true }
    }
    
    override func clean() {
        let modifier = type(of: self).modifier
        
        context.fromViews
            .filter { context[$0]?[modifier] as? Bool == false }
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        context.toViews
            .filter { context[$0]?[modifier] as? Bool == false }
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    }
}
