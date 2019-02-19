//
//  SitOutCollectionViewCell.swift
//  Chess Club Tournament
//
//  Created by Ben Lee on 2/8/19.
//  Copyright © 2019 Ben Lee. All rights reserved.
//

import UIKit

class SitOutCollectionViewCell: UICollectionViewCell {
    
    var player: Player? {
        didSet {
            setAttributedText(player: player!)
        }
    }
    var isInWaitingMode: Bool? {
        didSet {
            if isInWaitingMode == true {
                backgroundColor = UIColor.CHESSORANGE()
                titleLabel.text = "Waiting For Next Round"
            } else {
                backgroundColor = UIColor.CHESSRED()
                titleLabel.text = "Sitting Out"
            }
        }
    }
    
    func setAttributedText(player: Player) -> NSMutableAttributedString {
        let name = player.name!
        let wins = player.totalWins!
        let losses = player.totalLosses!
        let statsString = "\n(" + String(describing: wins) + "W - " + String(describing: losses) + "L)"
        let attributedText = NSMutableAttributedString(string: name + "  ", attributes: [NSAttributedStringKey.font : UIFont(name: "Roboto-Regular", size: 20)])
        
        attributedText.append(NSAttributedString(string: statsString , attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15), NSAttributedStringKey.foregroundColor: UIColor.gray]))
        
        nameLabel.attributedText = attributedText
        return attributedText
    }
    
    
    let midBar: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Sitting Out"
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Roboto-Medium", size: 16)
        lbl.textColor = UIColor.white
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Sitting Out"
        lbl.font = UIFont(name: "Roboto-Regular", size: 13)
        lbl.textAlignment = .left
        lbl.textColor = UIColor.TEXTCOLOR()
        lbl.adjustsFontSizeToFitWidth = true
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let outImageView: UIImageView = {
        let v = UIImageView(image: #imageLiteral(resourceName: "Out").withRenderingMode(.alwaysOriginal))
        v.clipsToBounds = true
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func setupUI() {
        
        layer.cornerRadius = 5
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 2
        backgroundColor = UIColor.CHESSRED()
        
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
        
        addSubview(midBar)
        midBar.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        midBar.addSubview(outImageView)
        outImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 20, width: 50, height: 50)
        outImageView.centerYAnchor.constraint(equalTo: midBar.centerYAnchor).isActive = true
        
        midBar.addSubview(nameLabel)
        nameLabel.anchor(top: midBar.topAnchor, left: outImageView.rightAnchor, bottom: midBar.bottomAnchor, right: midBar.rightAnchor, paddingTop: 0, paddingLeft: 30, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        outImageView.centerYAnchor.constraint(equalTo: midBar.centerYAnchor).isActive = true
        
        midBar.addSubview(nameLabel)
        nameLabel.anchor(top: midBar.topAnchor, left: outImageView.rightAnchor, bottom: midBar.bottomAnchor, right: midBar.rightAnchor, paddingTop: 0, paddingLeft: 30, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
