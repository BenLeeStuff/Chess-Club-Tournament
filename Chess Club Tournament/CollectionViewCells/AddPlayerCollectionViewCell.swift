//
//  AddPlayerCollectionViewCell.swift
//  Chess Club Tournament
//
//  Created by Ben Lee on 1/30/19.
//  Copyright © 2019 Ben Lee. All rights reserved.
//

import UIKit

class AddPlayerCollectionViewCell: UICollectionViewCell {
    
    var number: String? {
        didSet {
            numberLabel.text = number!
        }
    }
    
    let numberView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 5
        v.backgroundColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        return v
    }()
    
    let numberLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Roboto-Regular", size: 15)
        lbl.textColor = UIColor.white
        lbl.textAlignment = .center
        lbl.text = "hi"
        return lbl
    }()
    
    let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Roboto-Regular", size: 19)
        lbl.textColor = UIColor.TEXTCOLOR()
        return lbl
    }()
    
    let nameTextField: TextField = {
        let tf = TextField()
        tf.placeholder = "Add Player Name"
        tf.font = UIFont(name: "Roboto-Regular", size: 15)
        return tf
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        
    }
    
    func randomizeColor() {
        var mainColor = Int(arc4random_uniform(UInt32(3))) + 1
        var secondaryColor = 0
        var red = 0
        var green = 0
        var blue = 0
        var color = UIColor.rgb(red: 0, green: 0, blue: 0)
        
        switch mainColor {
        case 1:
            red = Int(arc4random_uniform(UInt32(55)))+200
            secondaryColor = Int(arc4random_uniform(UInt32(2))) + 1
            
            if secondaryColor == 1 {
                green = Int(arc4random_uniform(UInt32(75)))+75
                blue = Int(arc4random_uniform(UInt32(50)))
            } else if secondaryColor == 2 {
                green = Int(arc4random_uniform(UInt32(50)))
                blue = Int(arc4random_uniform(UInt32(75)))+75
            }
            color = UIColor.rgb(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue))
        case 2:
            green = Int(arc4random_uniform(UInt32(55)))+200
            secondaryColor = Int(arc4random_uniform(UInt32(2))) + 1
            
            if secondaryColor == 1 {
                red = Int(arc4random_uniform(UInt32(75)))+75
                blue = Int(arc4random_uniform(UInt32(50)))
            } else if secondaryColor == 2 {
                red = Int(arc4random_uniform(UInt32(50)))
                blue = Int(arc4random_uniform(UInt32(75)))+75
            }
            color = UIColor.rgb(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue))
            
        case 3:
            blue = Int(arc4random_uniform(UInt32(55))) + 200
            secondaryColor = Int(arc4random_uniform(UInt32(2))) + 1
            
            if secondaryColor == 1 {
                red = Int(arc4random_uniform(UInt32(75)))+75
                green = Int(arc4random_uniform(UInt32(50)))
            } else if secondaryColor == 2 {
                red = Int(arc4random_uniform(UInt32(50)))
                green = Int(arc4random_uniform(UInt32(75)))+75
            }
            color = UIColor.rgb(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue))
            
        default:
            break
        }
        print("red: \(red) green: \(green) blue: \(blue) color: \(color)")
        numberView.backgroundColor = color
        
    }
    
    func setupViews() {
        addSubview(numberView)
        numberView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
        numberView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(numberLabel)
        numberLabel.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
        numberLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(nameTextField)
        nameTextField.anchor(top: topAnchor, left: numberView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
