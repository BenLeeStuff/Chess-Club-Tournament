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
    var name: String?
    
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
    override func prepareForReuse() {
        //setupViews()
    }

    func setupViews() {
        backgroundColor = .white
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
