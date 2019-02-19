//
//  TournamentPlayersViewController.swift
//  Chess Club Tournament
//
//  Created by Ben Lee on 2/8/19.
//  Copyright © 2019 Ben Lee. All rights reserved.
//

import UIKit

class TournamentPlayersViewController: UIViewController {
    
    var players: [Player] = []
    
//    lazy var collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        layout.minimumLineSpacing = 0
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        cv.backgroundColor = UIColor.clear
//        cv.dataSource = self
//        cv.delegate = self
//        cv.isPagingEnabled = false
//        // cv.layer.shadowRadius = 40
//        return cv
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Players"

    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupUI()
    }
    
    func setupUI() {
        


    }
    func registerCells() {
        
    }
}
