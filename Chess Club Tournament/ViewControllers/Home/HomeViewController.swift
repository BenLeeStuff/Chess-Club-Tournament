//
//  ViewController.swift
//  Chess Club Tournament
//
//  Created by Ben Lee on 1/30/19.
//  Copyright © 2019 Ben Lee. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CreateTournamentOptionsDelegate {
    
    let createTournamentHomeCellId = "createTournamentHomeCellId"
    let tournamentHistoryId = "tournamentHistoryId"

    let createTournamentCollectionViewCellId = "createTournamentCollectionViewCellId"
    let createBracketTournamentCollectionViewCellId = "createBracketTournamentCollectionViewCellId"
    let cellId = "CellId"
    
    let navBar: UINavigationBar = {
        let nav = UINavigationBar()
        nav.prefersLargeTitles = true
        let navItem = UINavigationItem(title: "Home");
        let font = UIFont(name: "Roboto-Regular", size: 40)
        nav.titleTextAttributes = [NSAttributedStringKey.font : font, NSAttributedStringKey.foregroundColor : UIColor.TEXTCOLOR()]
        
        nav.setItems([navItem], animated: false)
        
        return nav
    }()
    
    let vr: RoundShadowView = {
        let v = RoundShadowView()
        v.backgroundColor = .blue
        v.layer.cornerRadius = 10
        return v
    }()
    
    let topImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "BgImage").withRenderingMode(.alwaysOriginal), highlightedImage: nil)
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let homeTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        let attributedString = NSMutableAttributedString(string: "Chess Tournaments ", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 25)])
        attributedString.append(NSAttributedString(string: "made easy to ", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 24)]))
        attributedString.append(NSAttributedString(string: "host", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 25)]))
        label.textColor = UIColor.BACKGROUNDCOLOR()
        label.attributedText = attributedString
        return label
    }()
    
    let optionsButton: UIButton = {
       let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "OptionsWhite").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let curvedBgView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "CurvedBG").withRenderingMode(.alwaysOriginal), highlightedImage: nil)
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let searchContainer: RoundShadowView = {
        let v = RoundShadowView()
        v.attributes(shadowColor: .black, shadowRadius: 10, opacity: 0.1, yOffset: 2, cornerRadius: 10, backgroundColor: UIColor.init(red: 250/255, green:  250/255, blue:  250/255, alpha: 0.99))
        v.alpha = 0.98
        return v
    }()
    
    let searchIconView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "SearchIconBlue").withRenderingMode(.alwaysOriginal))
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var homeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.dataSource = self
        cv.delegate = self
        cv.isPagingEnabled = false
        // cv.layer.shadowRadius = 40
        cv.backgroundColor = .clear
        return cv
    }()
    
    let overlay: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black
        v.alpha = 0.6
        return v
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("height: \(view.frame.height) width: \(view.frame.width)")
        
        setupUI()
        
        // Do any additional setup after loading the view.
    }
    
    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.BACKGROUNDCOLOR()
        view.addSubview(topImageView)
        topImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 233)
        
        topImageView.addSubview(optionsButton)
        optionsButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 30, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
        
        topImageView.addSubview(homeTitleLabel)
        homeTitleLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 88, paddingLeft: 40, paddingBottom: 0, paddingRight: 30, width: 0, height: 70)
        
        view.addSubview(curvedBgView)
        curvedBgView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(searchContainer)
        searchContainer.anchor(top: homeTitleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 15, paddingLeft: 30, paddingBottom: 0, paddingRight: 30, width: 0, height: 60)
        
        
        searchContainer.addSubview(searchIconView)
        searchIconView.anchor(top: searchContainer.topAnchor, left: searchContainer.leftAnchor, bottom: searchContainer.bottomAnchor, right: nil, paddingTop: 17, paddingLeft: 18, paddingBottom: -13, paddingRight: 0, width: 30, height: 30)

        view.addSubview(homeCollectionView)
        homeCollectionView.anchor(top: searchContainer.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
//        homeCollectionView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//        homeCollectionView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
//        homeCollectionView.alwaysBounceVertical = true
//
        view.addSubview(overlay)
        overlay.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        overlay.isHidden = true

        registerCells()
        
    }
    
    fileprivate func registerCells() {
//        homeCollectionView.register(CreateRegularTournamentCollectionViewCell.self, forCellWithReuseIdentifier: createTournamentCollectionViewCellId)
//        homeCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        homeCollectionView.register(CreateTournamentHomeCollectionViewCell.self, forCellWithReuseIdentifier: createTournamentHomeCellId)
        homeCollectionView.register(TournamentHistoryCollectionViewCell.self, forCellWithReuseIdentifier: tournamentHistoryId)

    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: createTournamentCollectionViewCellId, for: indexPath) as! CreateRegularTournamentCollectionViewCell
        switch indexPath.item {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: createTournamentHomeCellId, for: indexPath) as! CreateTournamentHomeCollectionViewCell
            cell.homeViewController = self
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tournamentHistoryId, for: indexPath) as! TournamentHistoryCollectionViewCell
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let createTournamentOptionsViewController = CreateTournamentOptionsViewController()
        createTournamentOptionsViewController.modalPresentationStyle = .overCurrentContext
        createTournamentOptionsViewController.delegate = self
        switch indexPath.item {
        case 0:
            break
        default:
            break
            
        }
        print("hhsds")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //return CGSize(width: view.frame.width, height: 150)
        if indexPath.item == 0 {
            return CGSize(width: view.frame.width, height: 294)
        } else {
            return CGSize(width: view.frame.width, height: 268)
        }
    }
    func toTournamentOptions() {
        let createTournamentOptionsViewController = CreateTournamentOptionsViewController()
        createTournamentOptionsViewController.modalPresentationStyle = .overCurrentContext
        createTournamentOptionsViewController.delegate = self
        showOverlay()
        navigationController?.present(createTournamentOptionsViewController, animated: true, completion: nil)

    }

    
    func hideOverlay() {
        UIView.animate(withDuration: 0.35, animations: {
            self.overlay.alpha = 0
        }) { (true) in
            self.overlay.isHidden = true
        }
    }
    
    func toAddPlayersVC(numberOfPlayers: Int, numberOfRounds: Int) {
        let addPlayersVC = AddPlayersViewController()
        addPlayersVC.numberOfPlayers = numberOfPlayers
        addPlayersVC.numberOfRounds = numberOfRounds
        navigationController?.setNavigationBarHidden(false, animated: true)

        navigationController?.pushViewController(addPlayersVC, animated: true)
    }

    
    func showOverlay() {
        self.overlay.isHidden = false
        UIView.animate(withDuration: 0.35, animations: {
            self.overlay.alpha = 0.5
        }) { (true) in
            self.overlay.isHidden = false
        }
    }

}

