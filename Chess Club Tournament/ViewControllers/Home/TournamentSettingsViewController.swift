//
//  TournamentSettingsViewController.swift
//  Chess Club Tournament
//
//  Created by Ben Lee on 2/8/19.
//  Copyright © 2019 Ben Lee. All rights reserved.
//

import UIKit
class TournamentSettingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, AddPlayersCardDelegate{
    
    var tournamentViewController = TournamentViewController()
    
    let addPlayersCellId = "addPlayersCellId"
    let removePlayersCellId = "removePlayersCellId" // need to implement
    let endTournamentCellId = "endTournamentCellId" // need to implement
    let addRoundsCellId = "addRoundsCellId" // need to implement
    
    let cellId = "CellId"

    var players: [Player] = []
    
    var currentRound: Int = 0
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.clear
        cv.dataSource = self
        cv.delegate = self
        cv.isPagingEnabled = false
        // cv.layer.shadowRadius = 40
        return cv
    }()
    
    let overlay: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black
        v.alpha = 0.5
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        view.backgroundColor = UIColor.GRAY()
        navigationItem.title = "Settings"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupUI()
    }
    
    func setupUI() {
        view.addSubview(collectionView)
        overlay.isHidden = true

        collectionView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 1, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(overlay)
        overlay.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        registerCells()
        
    }
    
    func registerCells() {
        collectionView.register(AddPlayerToTournamentCollectionViewCell.self, forCellWithReuseIdentifier: addPlayersCellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: addPlayersCellId, for: indexPath) as! AddPlayerToTournamentCollectionViewCell
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UICollectionViewCell
            return cell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            let addPlayersCardViewController = AddPlayerCardViewController()
            addPlayersCardViewController.modalPresentationStyle = .overCurrentContext
            addPlayersCardViewController.tournamentSettingsViewController = self
            addPlayersCardViewController.delegate = self
            showOverlay()
            navigationController?.present(addPlayersCardViewController, animated: true, completion: nil)
        default:
            break
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height/5)
    }
    
    func showOverlay() {
        self.overlay.isHidden = false
        UIView.animate(withDuration: 0.35, animations: {
            self.overlay.alpha = 0.5
        }) { (true) in
            self.overlay.isHidden = false
        }
    }
    
    func hideOverlay() {
        UIView.animate(withDuration: 0.35, animations: {
            self.overlay.alpha = 0
        }) { (true) in
            self.overlay.isHidden = true
        }
    }
    
    func addPlayerToTournament(player: Player) {
        navigationController?.popViewController(animated: true)
        tournamentViewController.addPlayerToTournament(player: player)

    }
    
}

