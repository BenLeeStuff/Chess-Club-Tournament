//
//  PlayerSittingOutViewController.swift
//  Chess Club Tournament
//
//  Created by Ben Lee on 2/15/19.
//  Copyright © 2019 Ben Lee. All rights reserved.
//

import UIKit

protocol SittingOutDelegate: class {
    func deletePlayerSittingOut(player: Player, indexPath: IndexPath)
}
class SittingOutViewController: UIViewController {
    weak var delegate: SittingOutDelegate?
    var tournamentViewController = TournamentViewController()
    var numberOfRounds: Int?
    var currentRound: Int?
    var numberOfPlayersSittingOut: Int?
    
    var playersSittingOut: [Player]?
    var playerIndexInAllPlayersAndPairs: Int? {
        didSet {
            print("IndexPath did set : \(playerIndexInAllPlayersAndPairs!)")
        }
    }

    var player: Player? {
        didSet {
            titleLabel.text = player!.name!
        }
    }
    
    let mainView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.GRAY()
        v.layer.cornerRadius = 8
        return v
    }()
    
    let titleLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont(name: "Roboto-Medium", size: 22)
        l.textColor = UIColor.TEXTCOLOR()
        l.text = "Create Tournament"
        l.textAlignment = .left
        return l
    }()
    
    let statusLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont(name: "Roboto-Regular", size: 18)
        l.textColor = UIColor.CHESSRED()
        l.text = "Currently Sitting Out"
        l.textAlignment = .left
        return l
    }()
    
    let pairDisabledLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont(name: "Roboto-Regular", size: 12)
        l.textColor = UIColor.CHESSRED()
        l.text = "No other players sitting out to pair with"
        l.textAlignment = .center
        l.isHidden = true
        return l
    }()
    
    let putInNextRoundDisabledLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont(name: "Roboto-Regular", size: 12)
        l.textColor = UIColor.CHESSRED()
        l.text = "The final round is going on"
        l.textAlignment = .center
        l.isHidden = true
        return l
    }()
    
    let pairWithAnotherPlayerButton: UIButton = {
        let button = UIButton(type: .system)
        let font = UIFont(name: "Roboto-Medium", size: 18)
        let attributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: UIColor.white]
        let attributedString = NSAttributedString(string: "Pair With A Player", attributes: attributes)
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(self, action: #selector(handlePairWithPlayer), for: .touchUpInside)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.rgb(red: 41, green:203 , blue: 152)
        return button
    }()
    
    let putInNextRoundButton: UIButton = {
        let button = UIButton(type: .system)
        let font = UIFont(name: "Roboto-Medium", size: 18)
        let attributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: UIColor.white]
        let attributedString = NSAttributedString(string: "Wait For Next Round", attributes: attributes)
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(self, action: #selector(handlePutInNextRound), for: .touchUpInside)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.CHESSBLUE()
        return button
    }()
    
    let cancelButton : UIButton = {
        let button = UIButton(type: .system)
        let font = UIFont(name: "Roboto-Regular", size: 13)
        let attributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: UIColor.rgb(red: 252, green: 63, blue: 75)]
        let attributedString = NSAttributedString(string: "Cancel", attributes: attributes)
        //button.setTitle("Cancel", for: .normal)
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()

    let removeButton: UIButton = {
        let button = UIButton(type: .system)
        let font = UIFont(name: "Roboto-Medium", size: 18)
        let attributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: UIColor.white]
        let attributedString = NSAttributedString(string: "Remove Player", attributes: attributes)
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(self, action: #selector(handleRemovePlayer), for: .touchUpInside)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.CHESSRED()
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        view.backgroundColor = .clear
        view.addSubview(mainView)
        mainView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 80, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: view.frame.height * 0.6)
        mainView.addSubview(cancelButton)
        cancelButton.anchor(top: mainView.topAnchor, left: nil, bottom: nil, right: mainView.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 25, width: 60, height: 45)
        
       
        mainView.addSubview(titleLabel)
        titleLabel.anchor(top: mainView.topAnchor, left: mainView.leftAnchor, bottom: nil, right: mainView.rightAnchor, paddingTop: 25, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        mainView.addSubview(statusLabel)
        statusLabel.anchor(top: titleLabel.bottomAnchor, left: mainView.leftAnchor, bottom: nil, right: mainView.rightAnchor, paddingTop: 25, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        mainView.addSubview(pairWithAnotherPlayerButton)
        pairWithAnotherPlayerButton.anchor(top: statusLabel.bottomAnchor, left: mainView.leftAnchor, bottom: nil, right: mainView.rightAnchor, paddingTop: 40, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 50)
        
        mainView.addSubview(pairDisabledLabel)
        pairDisabledLabel.anchor(top: pairWithAnotherPlayerButton.bottomAnchor, left: mainView.leftAnchor, bottom: nil, right: mainView.rightAnchor, paddingTop: 5, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 12)
        
        mainView.addSubview(putInNextRoundButton)
        putInNextRoundButton.anchor(top: pairWithAnotherPlayerButton.bottomAnchor, left: mainView.leftAnchor, bottom: nil, right: mainView.rightAnchor, paddingTop: 30, paddingLeft: 20, paddingBottom: -20, paddingRight: 20, width: 0, height: 50)
        
        mainView.addSubview(putInNextRoundDisabledLabel)
        putInNextRoundDisabledLabel.anchor(top: putInNextRoundButton.bottomAnchor, left: mainView.leftAnchor, bottom: nil, right: mainView.rightAnchor, paddingTop: 5, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 12)
        
        mainView.addSubview(removeButton)
        removeButton.anchor(top: putInNextRoundButton.bottomAnchor, left: mainView.leftAnchor, bottom: nil, right: mainView.rightAnchor, paddingTop: 50, paddingLeft: 20, paddingBottom: -20, paddingRight: 20, width: 0, height: 50)
        
        checkCurrentRound()
        checkPlayersSittingOut()
    }
    
    func checkPlayersSittingOut() {
        let playersSittingOut = self.numberOfPlayersSittingOut!
        
        if playersSittingOut <= 1 {
            pairWithAnotherPlayerButton.alpha = 0.3
            pairWithAnotherPlayerButton.isEnabled = false
            pairDisabledLabel.isHidden = false
        }
    }
    
    func checkCurrentRound() {
        let currentRound = self.currentRound!
        let totalRounds = self.numberOfRounds!
        
        if currentRound == totalRounds{
            putInNextRoundButton.alpha = 0.3
            putInNextRoundButton.isEnabled = false
            putInNextRoundDisabledLabel.isHidden = false
        }
    }

    
    @objc func handleCancel() {
        tournamentViewController.hideTournamentOverlay()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handlePutInNextRound() {
        
        // need to put player in waiting mode.
    }
    
    @objc func handleRemovePlayer() {
        
        let name = player!.name!
        let alert = UIAlertController(title: "Remove \(name)? ", message: "Are you sure you want to remove \(name) from the tournament? This can't be undone.", preferredStyle: .actionSheet)
        let removePlayer = UIAlertAction(title: "Remove \(name)", style: .destructive) { (action) in
            // need to implement remove action
            self.tournamentViewController.hideTournamentOverlay()
            self.dismiss(animated: true, completion: {
                let player = self.player!
                //let indexPath = self.playerIndexPath!
                let index = self.playerIndexInAllPlayersAndPairs! 
                let indexPath = IndexPath(item: index, section: 0)
                self.tournamentViewController.allPairsAndPlayersSittingOut.remove(at: index)
                self.delegate?.deletePlayerSittingOut(player: player, indexPath: indexPath)
            })
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alert.addAction(cancel)
        alert.addAction(removePlayer)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func handlePairWithPlayer() {
        let playersSittingOutHolder = playersSittingOut!.filter { $0.name != player!.name! }
        let playersViewController = PlayersViewController()
        playersViewController.sittingOutViewController = self
        playersViewController.players = playersSittingOutHolder
        playersViewController.playerToMatch = player!
        playersViewController.delegate = self.tournamentViewController
        self.present(playersViewController, animated: true, completion: nil)
    }

    
}
