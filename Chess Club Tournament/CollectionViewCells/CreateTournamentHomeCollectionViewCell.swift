//
//  CreateTournamentHomeCollectionViewCell
//  Chess Club Tournament
//
//  Created by Ben Lee on 2/22/19.
//  Copyright © 2019 Ben Lee. All rights reserved.
//

import UIKit

class CreateTournamentHomeCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    var homeViewController = HomeViewController()
    let swissTournamentCellId = "swissTournamentCellId"
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
        label.text = "Create a Tournament"
        return label
    }()
    
    let tempView: UIView = {
        let v = UIView()
        return v
    }()
    
    let swissTournamentButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Swiss", for: .normal)
        b.setTitleColor(UIColor.CHESSBLUE(), for: .normal)
        b.titleLabel?.setRegularFont(fontSize: 14)
        return b
    }()
    
    let singleElimButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Single Elimination", for: .normal)
        b.setTitleColor(UIColor.TEXTBLACK(), for: .normal)
        b.titleLabel?.alpha = 0.5
        b.titleLabel?.setRegularFont(fontSize: 14)
        return b
    }()
    
    let doubleElimButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Double Elimination", for: .normal)
        b.setTitleColor(UIColor.TEXTBLACK(), for: .normal)
        b.titleLabel?.alpha = 0.2
        b.titleLabel?.setRegularFont(fontSize: 14)
        return b
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
        topBar.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 25, paddingLeft: 30, paddingBottom: 0, paddingRight: 30, width: 0, height: 1.5)
        
        addSubview(kingIcon)
        kingIcon.anchor(top: topBar.bottomAnchor, left: topBar.leftAnchor, bottom: nil, right: nil, paddingTop: 18.5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 12, height: 19)
        
        addSubview(titleLabel)
        titleLabel.anchor(top: topBar.bottomAnchor, left: kingIcon.rightAnchor, bottom: nil, right: topBar.rightAnchor, paddingTop: 19.5, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 18)
        
        let buttonStackView = UIStackView(arrangedSubviews: [swissTournamentButton, singleElimButton, doubleElimButton])
        buttonStackView.distribution = .fillProportionally
        buttonStackView.axis = .horizontal
        
        addSubview(buttonStackView)
        buttonStackView.anchor(top: titleLabel.bottomAnchor, left: topBar.leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 16)


        
//        addSubview(tempView)
//        tempView.anchor(top: titleLabel.bottomAnchor, left: topBar.leftAnchor, bottom: nil, right: topBar.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 16)

        addSubview(tournamentTypesCollectionView)
        tournamentTypesCollectionView.anchor(top: buttonStackView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: -25, paddingRight: 0, width: 0, height: 0)
        tournamentTypesCollectionView.contentInset = UIEdgeInsetsMake(0, 30, 0, 0)
        registerCells()
    }
    
    func registerCells() {
        tournamentTypesCollectionView.register(SwissTournamentCollectionViewCell.self, forCellWithReuseIdentifier: swissTournamentCellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: swissTournamentCellId, for: indexPath) as! SwissTournamentCollectionViewCell
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: swissTournamentCellId, for: indexPath) as! SwissTournamentCollectionViewCell
            return cell
        default:
            return UICollectionViewCell()
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let createTournamentOptionsViewController = CreateTournamentOptionsViewController()
        createTournamentOptionsViewController.modalPresentationStyle = .overCurrentContext
        switch indexPath.item {
        case 0:
            homeViewController.toTournamentOptions()
            //homeViewController.showOverlay()
            //showOverlay()
            //homeViewController.navigationController?.setNavigationBarHidden(false, animated: true)
            //homeViewController.navigationController?.present(createTournamentOptionsViewController, animated: true, completion: nil)
            break
        default:
            break
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width - 70, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
}
