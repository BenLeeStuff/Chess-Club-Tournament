//
//  MatchupCollectionViewCell.swift
//  Chess Club Tournament
//
//  Created by Ben Lee on 1/30/19.
//  Copyright © 2019 Ben Lee. All rights reserved.
//

import UIKit

class MatchupCollectionViewCell: UICollectionViewCell {
    
    
    func setAttributedText(player: Player) -> NSMutableAttributedString {
        let name = player.name
        let wins = player.totalWins
        let losses = player.totalLosses
        let statsString = "\n(" + String(describing: wins) + "W - " + String(describing: losses) + "L)"
        let attributedText = NSMutableAttributedString(string: name! + "  ", attributes: [NSAttributedStringKey.font : UIFont(name: "Roboto-Regular", size: 20)])
        
        attributedText.append(NSAttributedString(string: statsString , attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15), NSAttributedStringKey.foregroundColor: UIColor.gray]))
        return attributedText
    }
    
    
    func setAttributedText(matchPair: MatchPair)  {
        
        var whitePlayer: Player?
        var blackPlayer: Player?
        
        if matchPair.player1!.boardColor! == "White" && matchPair.player2!.boardColor! == "Black" {
            whitePlayer = matchPair.player1!
            blackPlayer = matchPair.player2!
        } else if matchPair.player1!.boardColor! == "Black" && matchPair.player2!.boardColor! == "White" {
            whitePlayer = matchPair.player2!
            blackPlayer = matchPair.player1!
            
        } else {
            print("Something went wrong with the colors")
        }
        
        
        let player1Name = whitePlayer!.name!
        let player1Wins = whitePlayer!.totalWins!
        let player1Losses = whitePlayer!.totalLosses!
        let player1StatsString = "\n(" + String(describing: player1Wins) + "W - " + String(describing: player1Losses) + "L)"
        let player1AttributedText = NSMutableAttributedString(string: player1Name + "  ", attributes: [NSAttributedStringKey.font : UIFont(name: "Roboto-Regular", size: 20)])
        
        player1AttributedText.append(NSAttributedString(string: player1StatsString , attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15), NSAttributedStringKey.foregroundColor: UIColor.gray]))
        
        let player2Name = blackPlayer!.name!
        let player2Wins = blackPlayer!.totalWins!
        let player2Losses = blackPlayer!.totalLosses!
        let player2StatsString = "\n(" + String(describing: player2Wins) + "W - " + String(describing: player2Losses) + "L)"
        let player2AttributedText = NSMutableAttributedString(string: player2Name + "  ", attributes: [NSAttributedStringKey.font : UIFont(name: "Roboto-Regular", size: 20)])
        
        player2AttributedText.append(NSAttributedString(string: player2StatsString , attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15), NSAttributedStringKey.foregroundColor: UIColor.gray]))
        
        player1NameLabel.attributedText = player1AttributedText
        player2NameLabel.attributedText = player2AttributedText
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
    
    let vsLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "VS"
        lbl.font = UIFont(name: "Roboto-Regular", size: 15)
        lbl.textAlignment = .center
        lbl.textColor = UIColor.gray
        return lbl
    }()
    
//    let overlay: UIView = {
//        let v = UIView()
//
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    func setupUI() {
        backgroundColor = .white
        
        addSubview(whiteImageView)
        whiteImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        whiteImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(blackImageView)
        blackImageView.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        blackImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(whiteColorLabel)
        whiteColorLabel.anchor(top: nil, left: nil, bottom: whiteImageView.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: -5, paddingRight: 0, width: 0, height: 20)
        whiteColorLabel.centerXAnchor.constraint(equalTo: whiteImageView.centerXAnchor).isActive = true
        
        addSubview(blackColorLabel)
        blackColorLabel.anchor(top: nil, left: nil, bottom: blackImageView.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: -5, paddingRight: 0, width: 0, height: 20)
        blackColorLabel.centerXAnchor.constraint(equalTo: blackImageView.centerXAnchor).isActive = true
        
        addSubview(vsLabel)
        vsLabel.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 40, height: 0)
        vsLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        vsLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(player1NameLabel)
        player1NameLabel.anchor(top: whiteImageView.topAnchor, left: whiteImageView.rightAnchor, bottom: whiteImageView.bottomAnchor, right: vsLabel.leftAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        
        addSubview(player2NameLabel)
        player2NameLabel.anchor(top: blackImageView.topAnchor, left: vsLabel.rightAnchor, bottom: blackImageView.bottomAnchor, right: blackImageView.leftAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 120, height: 0)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
