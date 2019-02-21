//
//  PlayersViewController.swift
//  Chess Club Tournament
//
//  Created by Ben Lee on 2/17/19.
//  Copyright © 2019 Ben Lee. All rights reserved.
//

import UIKit

protocol PlayersViewControllerDelegate: class {
    func addPairToTournament(pair: MatchPair, playerToMatch: Player, opponent: Player)
}

class PlayersViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    weak var delegate: PlayersViewControllerDelegate?
    var tournamentViewController = TournamentViewController()
    var willPickPlayerToSitOut = false
    
    let sittingOutId = "SittingOutId"
    let playerId = "playerId"

    var sittingOutViewController: SittingOutViewController? {
        didSet {
            print("Sitting out view controller did set")
        }
    }
    var playerToMatch: Player?
    var players: [Player]?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerCells()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        view.backgroundColor = UIColor.GRAY()
        let margins = view.layoutMarginsGuide
        view.addSubview(collectionView)
        collectionView.anchor(top: margins.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    func registerCells() {
        collectionView.register(PlayerCell.self, forCellWithReuseIdentifier: sittingOutId)
        collectionView.register(PlayerCell.self, forCellWithReuseIdentifier: playerId)

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if willPickPlayerToSitOut == true {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: playerId, for: indexPath) as! PlayerCell
            if let player = players?[indexPath.item] {
                cell.player = player

            }
            return cell
        }
        if let sittingOutVC = self.sittingOutViewController as? SittingOutViewController {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: sittingOutId, for: indexPath) as! PlayerCell
            cell.player = players![indexPath.item]
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if willPickPlayerToSitOut == true {
            let cell = collectionView.cellForItem(at: indexPath) as! PlayerCell
            let player = cell.player!
            
        }
        if let sitOut = sittingOutViewController {
            let opponent = players![indexPath.item]
            let plyrToMatch = self.playerToMatch!
            plyrToMatch.boardColor = "Black"
            playerToMatch?.isSittingOut = false
            opponent.isSittingOut = false
            opponent.boardColor = "White"

            let pair = MatchPair(player1: plyrToMatch, player2: opponent, players: [playerToMatch!, opponent], matchComplete: false, winner: nil, loser: nil, draw: false)
            delegate?.addPairToTournament(pair: pair, playerToMatch: plyrToMatch, opponent: opponent)
            
            dismiss(animated: true, completion: {
                self.sittingOutViewController?.dismiss(animated: true, completion: nil)
            })
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return players!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 120)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
