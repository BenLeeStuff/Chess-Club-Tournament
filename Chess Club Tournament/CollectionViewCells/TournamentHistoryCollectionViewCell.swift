//
//  TournamentHistoryCollectionViewCell.swift
//  Chess Club Tournament
//
//  Created by Ben Lee on 2/22/19.
//  Copyright © 2019 Ben Lee. All rights reserved.
//

import UIKit

class TournamentHistoryCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    let previousTournamentCellId = "previousTournamentCellId"
    let tournamentHistoryId = "thistid"
    let topBar: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.BARGRAY()
        return v
    }()
    
    let kingIcon: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "BlackKing").withRenderingMode(.alwaysOriginal))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.setBoldFont(fontSize: 18)
        label.text = "Previous Tournaments"
        return label
    }()
    
    let tempView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        return v
    }()
    
    lazy var tournamentTypesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.dataSource = self
        cv.delegate = self
        cv.isPagingEnabled = true
        // cv.layer.shadowRadius = 40
        cv.backgroundColor = .clear
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        addSubview(topBar)
        topBar.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 30, paddingBottom: 0, paddingRight: 30, width: 0, height: 1.5)
        
        addSubview(kingIcon)
        kingIcon.anchor(top: topBar.bottomAnchor, left: topBar.leftAnchor, bottom: nil, right: nil, paddingTop: 18.5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 12, height: 19)
        
        addSubview(titleLabel)
        titleLabel.anchor(top: topBar.bottomAnchor, left: kingIcon.rightAnchor, bottom: nil, right: topBar.rightAnchor, paddingTop: 19.5, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 18)
        
        addSubview(tempView)
        tempView.anchor(top: titleLabel.bottomAnchor, left: topBar.leftAnchor, bottom: nil, right: topBar.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 16)
        
        addSubview(tournamentTypesCollectionView)
        tournamentTypesCollectionView.anchor(top: tempView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: -25, paddingRight: 0, width: 0, height: 0)
        tournamentTypesCollectionView.contentInset = UIEdgeInsetsMake(0, 30, 0, 0)
        registerCells()
    }
    
    func registerCells() {
        tournamentTypesCollectionView.register(PreviousTournamentCollectionViewCell.self, forCellWithReuseIdentifier: previousTournamentCellId)
        tournamentTypesCollectionView.register(TournamentHistoryCollectionViewCell.self, forCellWithReuseIdentifier: tournamentHistoryId)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: previousTournamentCellId, for: indexPath) as! PreviousTournamentCollectionViewCell
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: previousTournamentCellId, for: indexPath) as! PreviousTournamentCollectionViewCell
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 344, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
