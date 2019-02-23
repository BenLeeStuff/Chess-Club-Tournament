//
//  SwissTournamentCollectionViewCell.swift
//  Chess Club Tournament
//
//  Created by Ben Lee on 2/22/19.
//  Copyright © 2019 Ben Lee. All rights reserved.
//

import UIKit

class SwissTournamentCollectionViewCell: UICollectionViewCell {
    let containerView = UIView()
    
    let mainView: RoundShadowView = {
        let v = RoundShadowView()
        return v
    }()
    
    let swissTournamentIcon: UIImageView = {
        let iv = UIImageView()
        iv.setImage(image: #imageLiteral(resourceName: "SwissTIcon"))
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.setSemiBoldFont(fontSize: 16)
        label.text = "Swiss Tournament"
        label.textAlignment = .left
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.setRegularFont(fontSize: 14)
        label.numberOfLines = 0
        label.text = "Players with similar scores are paired and nobody is eliminated!"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 10.0
        layer.shadowOpacity = 0.1
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        containerView.layer.masksToBounds = true
        
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        attributes(shadowColor: .black, shadowRadius: 7, opacity: 0.07, yOffset: 3, cornerRadius: 10, backgroundColor: .white)
        
        containerView.addSubview(swissTournamentIcon)
        swissTournamentIcon.anchor(top: containerView.topAnchor, left: nil, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 144, height: 0)
        
        containerView.addSubview(titleLabel)
        titleLabel.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: swissTournamentIcon.leftAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 19)
        
        containerView.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: titleLabel.bottomAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: swissTournamentIcon.leftAnchor, paddingTop: 11, paddingLeft: 20, paddingBottom: -35, paddingRight: 13, width: 0, height: 0)

        

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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
