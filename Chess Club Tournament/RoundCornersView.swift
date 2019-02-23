//
//  RoundCornersView.swift
//  Chess Club Tournament
//
//  Created by Ben Lee on 2/22/19.
//  Copyright © 2019 Ben Lee. All rights reserved.
//

import Foundation
import UIKit

class RoundShadowView: UIView {
    
    let containerView = UIView()
    let cornerRadius: CGFloat = 6.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutView() {
        
        // set the shadow of the view's layer
        
        // set the cornerRadius of the containerView's layer
        containerView.layer.cornerRadius = cornerRadius
        containerView.layer.masksToBounds = true
        
        addSubview(containerView)
        
        //
        // add additional views to the containerView here
        //
        
        // add constraints
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // pin the containerView to the edges to the view
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func attributes(shadowColor: UIColor, shadowRadius: CGFloat, opacity: Float, yOffset: Int, cornerRadius: Int, backgroundColor: UIColor) {
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = opacity
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = CGSize(width: 0, height: yOffset)
        layer.cornerRadius = CGFloat(cornerRadius)
        layer.backgroundColor = backgroundColor.cgColor
        containerView.layer.cornerRadius = CGFloat(cornerRadius)
        

    }
    
    func cornerRadius(radius: Int) {
        layer.cornerRadius = CGFloat(radius)
    }
    
    func setShadow(color: UIColor, opacity: Float, yOffset: Int) {
        layer.shadowOpacity = opacity
        layer.shadowColor = color.cgColor
        layer.shadowOffset = CGSize(width: 0, height: yOffset)
    }
}

