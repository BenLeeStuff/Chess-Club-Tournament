//
//  DeletePlayerViewController.swift
//  Chess Club Tournament
//
//  Created by Ben Lee on 2/10/19.
//  Copyright © 2019 Ben Lee. All rights reserved.
//

import UIKit

class DeletePlayerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
   // var addPlayersViewController = AddPlayersViewController()
    
    var deletePlayerCellId = "DeletePLayerCellId"
    var names: [String] = []
    var players: [Player] = []
    
    let descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Select a Player To Sit Out"
        lbl.font = UIFont(name: "Roboto-Regular", size: 16)
        lbl.textAlignment = .center
        lbl.textColor = UIColor.TEXTCOLOR()
        return lbl
    }()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //self.players = addPlayersViewController.players
        setupUI()
        registerCells()
        print("PLAYERS COUNT: \(players.count)")
    }
    
    func setupUI() {
        navigationController?.navigationBar.topItem?.title = "Delete Player"
        navigationItem.title = "Select Player To Remove"
        view.backgroundColor = UIColor.GRAY()
        
        view.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: navigationController?.navigationBar.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
        
        view.addSubview(collectionView)
        collectionView.anchor(top: descriptionLabel.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        registerCells()
    }
    
    func registerCells(){
        collectionView.register(PlayerCell.self, forCellWithReuseIdentifier: deletePlayerCellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: deletePlayerCellId, for: indexPath) as! PlayerCell
        //let name = players[indexPath.item].name
        cell.nameLabel.text = names[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return names.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected")
        //showAlert(name: names[indexPath.item], index: indexPath.item, indexPath: indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func showAlert(name: String, index: Int, indexPath: IndexPath) {
        let alert = UIAlertController(title: "\(name) Selected", message: "Are you sure you want \(name) to sit out?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .default) { (action) in
            // implement yes action
//            self.addPlayersViewController.playerSittingOutIndex = index
//            self.navigationController?.popViewController(animated: true)
//            self.players[index].isSittingOut = true
//            self.addPlayersViewController.players = self.players
//            self.addPlayersViewController.collectionView.reloadItems(at: [indexPath])
//            //self.addPlayersViewController.collectionView.reloadData()
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(yes)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    

    
}
