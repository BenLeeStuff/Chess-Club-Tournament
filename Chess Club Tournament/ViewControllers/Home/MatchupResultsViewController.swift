//
//  MatchupResultsViewController.swift
//  Chess Club Tournament
//
//  Created by Ben Lee on 1/31/19.
//  Copyright © 2019 Ben Lee. All rights reserved.
//

import UIKit

protocol MatchupResultsDelegate: class {
    func updatePlayerResults(matchPair: MatchPair, index: Int)
}

class MatchupResultsViewController: UIViewController {
    
    var matchupCollectionViewCell = MatchupCollectionViewCell()
    weak var delegate: MatchupResultsDelegate?
    
    var currentIndexPath: IndexPath?
    var currentIndex: Int?
    var whitePlayer: Player?
    var blackPlayer: Player?

    var matchPair: MatchPair? {
        didSet {
            
        }
    }
    
    let blackImageView: UIImageView = {
        let iv =  UIImageView(image: #imageLiteral(resourceName: "blackColor"))
        iv.clipsToBounds = true
        return iv
    }()
    
    let whiteImageView: UIImageView = {
        let iv =  UIImageView(image: #imageLiteral(resourceName: "whiteColor"))
        iv.clipsToBounds = true
        return iv
    }()
    
    let whiteColorLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "White"
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Roboto-Regular", size: 12)
        lbl.textColor = UIColor.gray
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    let blackColorLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Black"
        lbl.font = UIFont(name: "Roboto-Regular", size: 12)
        lbl.textAlignment = .center
        lbl.textColor = UIColor.gray
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    let player1NameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Player1"
        lbl.font = UIFont(name: "Roboto-Regular", size: 13)
        lbl.textColor = UIColor.TEXTCOLOR()
        lbl.adjustsFontSizeToFitWidth = true
        lbl.numberOfLines = 0
        
        return lbl
    }()
    
    let player2NameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Player2"
        lbl.font = UIFont(name: "Roboto-Regular", size: 13)
        lbl.textAlignment = .right
        lbl.textColor = UIColor.TEXTCOLOR()
        lbl.adjustsFontSizeToFitWidth = true
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let whiteWinButton: UIButton = {
        let button = UIButton(type: .system)
        //button.setImage(#imageLiteral(resourceName: "whiteColor"), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleWhiteWin), for: .touchUpInside)

        return button
    }()
    
    let blackWinButton: UIButton = {
        let button = UIButton(type: .system)
        //button.setImage(#imageLiteral(resourceName: "blackColor"), for: .normal)
        button.backgroundColor = UIColor.CHESSLIGHTBLACK()
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleBlackWin), for: .touchUpInside)
        return button
    }()
    
    let drawButon: UIButton = {
        let button = UIButton(type: .system)
        //button.setImage(#imageLiteral(resourceName: "blackColor"), for: .normal)
        button.backgroundColor = UIColor.rgb(red: 203, green: 205, blue: 211)
        button.layer.cornerRadius = 5
        button.setTitle("Draw", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 18)
        button.addTarget(self, action: #selector(handleDraw), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.GRAY()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupUI()
    }
    
    func setupUI() {
        //setupButtonTitle()
        let stackView = UIStackView(arrangedSubviews: [whiteWinButton, blackWinButton, drawButon])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 25
        
        view.addSubview(stackView)
        stackView.anchor(top: navigationController?.navigationBar.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 25, paddingBottom: -30, paddingRight: 25, width: 0, height: 0)
    }
    
    func setupButtonTitle() {

        if matchPair!.player1!.boardColor! == "White" {
            whiteWinButton.setTitle("\(matchPair!.player1!.name!) Won", for: .normal)
            whiteWinButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 18)
            whiteWinButton.setTitleColor(UIColor.BLACKCOLOR(), for: .normal)
            
            blackWinButton.setTitle("\(matchPair!.player2!.name!) Won", for: .normal)
            blackWinButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 18)
            blackWinButton.setTitleColor(UIColor.white, for: .normal)
            
            
        } else if matchPair!.player2!.boardColor! == "Black" {
            whiteWinButton.setTitle("\(matchPair!.player2!.name!) Won", for: .normal)
            whiteWinButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 18)
            whiteWinButton.setTitleColor(UIColor.BLACKCOLOR(), for: .normal)
            
            blackWinButton.setTitle("\(matchPair!.player1!.name!) Won", for: .normal)
            blackWinButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 18)
            blackWinButton.setTitleColor(UIColor.white, for: .normal)
        }
        
    }
    
    func setupWhiteAndBlackPlayers() {
        
    }
    
    @objc func handleWhiteWin() {        
        guard let index = currentIndex else {return}
  
        matchPair?.player1?.totalWins? += 1
        matchPair?.player1?.totalScore? += 1
        matchPair?.player2?.totalLosses? += 1
        matchPair?.winner = matchPair?.player1
        matchPair?.loser = matchPair?.player2
        
        delegate?.updatePlayerResults(matchPair: matchPair!, index: index)
        //delegate?.animateCellOverlay(indexPath: currentIndexPath!)
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleBlackWin() {
        guard let index = currentIndex else {return}
        
        matchPair?.player2?.totalWins? += 1
        matchPair?.player2?.totalScore? += 1
        matchPair?.player1?.totalLosses? += 1
        
        matchPair?.winner = matchPair?.player2
        matchPair?.loser = matchPair?.player1
        
        delegate?.updatePlayerResults(matchPair: matchPair!, index: index)
        //delegate?.animateCellOverlay(indexPath: currentIndexPath!)
        
        navigationController?.popViewController(animated: true)

    }
    
    @objc func handleDraw() {
        guard let index = currentIndex else {return}
        
        matchPair?.player1?.totalDraws? += 1
        matchPair?.player2?.totalDraws? += 1
        matchPair?.player1?.totalScore? += 0.5
        matchPair?.player2?.totalScore? += 0.5
        matchPair?.draw = true
        delegate?.updatePlayerResults(matchPair: matchPair!, index: index)
        //delegate?.animateCellOverlay(indexPath: currentIndexPath!)

        navigationController?.popViewController(animated: true)

    }

}
