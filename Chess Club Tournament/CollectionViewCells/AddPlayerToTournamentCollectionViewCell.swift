//
//  AddPlayersCollectionViewCell.swift
//  Chess Club Tournament
//
//  Created by Ben Lee on 2/8/19.
//  Copyright © 2019 Ben Lee. All rights reserved.
//

import UIKit

class AddPlayerToTournamentCollectionViewCell: UICollectionViewCell {
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Add Players To Tournament"
        lbl.font = UIFont(name: "Roboto-Medium", size: 18)
        lbl.textAlignment = .left
        lbl.textColor = UIColor.TEXTCOLOR()
        return lbl
    }()
    
    let arrowImage: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "RightArrow").withRenderingMode(.alwaysOriginal))
        iv.clipsToBounds = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let dividerView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black
        v.alpha = 0.2
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUI()
    }
    
    func setupUI() {
        addSubview(arrowImage)
        arrowImage.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 25, width: 10, height: 16)
        arrowImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: arrowImage.rightAnchor, paddingTop: 0, paddingLeft: 25, paddingBottom: 0, paddingRight: 25, width: 0, height: 0)
        
        addSubview(dividerView)
        dividerView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
