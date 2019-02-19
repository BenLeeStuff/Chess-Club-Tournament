//
//  MatchupCollectionViewCell.swift
//  Chess Club Tournament
//
//  Created by Ben Lee on 1/30/19.
//  Copyright © 2019 Ben Lee. All rights reserved.
//

import UIKit
import SimpleAnimation

class MatchupCollectionViewCell: UICollectionViewCell, TournamentViewControllerDelegate {
    
    var tournamentViewController = TournamentViewController()
    
    var matchComplete: Bool? {
        didSet {
            //showOverlay()
        }
    }
    
    var matchPair: MatchPair?

    var containerView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.CHESSBLUE()
        return v
    }()
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Match Title"
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Roboto-Medium", size: 16)
        lbl.textColor = UIColor.white
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let midBar: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.clipsToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = true
        return v
    }()
    
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
    
    let overlay: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        v.alpha = 0.5
        v.isHidden = true
        return v
    }()
    

    let resultOverlay: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.CHESSBLUE()
        v.layer.cornerRadius = 5
        v.isHidden = true
        v.layer.borderColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        v.layer.borderWidth = 1
        return v
    }()
    
    let resultLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Result"
        lbl.font = UIFont(name: "Roboto-Regular", size: 15)
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.textColor = UIColor.white
        return lbl
    }()
    
    var changeResultButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(changeResult), for: .touchUpInside)
        button.setTitle("Change Result", for: .normal)
        button.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 15)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.CHESSBLACK()
        button.layer.cornerRadius = 5
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //tournamentViewController.delegate = self
        setupUI()
    }
    
    override func prepareForReuse() {
        
    }
    
    func setupUI() {
        layer.cornerRadius = 5
        clipsToBounds = true
        backgroundColor = UIColor.CHESSBLUE()
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
        
        addSubview(midBar)
        midBar.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        midBar.addSubview(whiteImageView)
        whiteImageView.anchor(top: nil, left: midBar.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        whiteImageView.centerYAnchor.constraint(equalTo: midBar.centerYAnchor).isActive = true
        
        addSubview(blackImageView)
        blackImageView.anchor(top: nil, left: nil, bottom: nil, right: midBar.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 5, width: 50, height: 50)
        blackImageView.centerYAnchor.constraint(equalTo: midBar.centerYAnchor).isActive = true
        
        addSubview(whiteColorLabel)
        whiteColorLabel.anchor(top: nil, left: nil, bottom: whiteImageView.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: -5, paddingRight: 0, width: 0, height: 20)
        whiteColorLabel.centerXAnchor.constraint(equalTo: whiteImageView.centerXAnchor).isActive = true
        
        addSubview(blackColorLabel)
        blackColorLabel.anchor(top: nil, left: nil, bottom: blackImageView.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: -5, paddingRight: 0, width: 0, height: 20)
        blackColorLabel.centerXAnchor.constraint(equalTo: blackImageView.centerXAnchor).isActive = true
        
        addSubview(vsLabel)
        vsLabel.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 40, height: 0)
        vsLabel.centerXAnchor.constraint(equalTo: midBar.centerXAnchor).isActive = true
        vsLabel.centerYAnchor.constraint(equalTo: midBar.centerYAnchor).isActive = true
        
        addSubview(player1NameLabel)
        player1NameLabel.anchor(top: whiteImageView.topAnchor, left: whiteImageView.rightAnchor, bottom: whiteImageView.bottomAnchor, right: vsLabel.leftAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        
        addSubview(player2NameLabel)
        player2NameLabel.anchor(top: blackImageView.topAnchor, left: vsLabel.rightAnchor, bottom: blackImageView.bottomAnchor, right: blackImageView.leftAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 120, height: 0)
        
        addSubview(overlay)
        overlay.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        addSubview(resultOverlay)
        resultOverlay.anchor(top: overlay.topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 15, paddingLeft: 30, paddingBottom: -15, paddingRight: 30, width: 0, height: 0)
        
        resultOverlay.addSubview(resultLabel)
        resultLabel.anchor(top: overlay.topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: -25, paddingLeft: 30, paddingBottom: 15, paddingRight: 30, width: 0, height: 0)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func changeResult() {
        
    }
    
    func animateOverlay() {
        
        overlay.isHidden = false
        overlay.alpha = 0.5
        resultOverlay.isHidden = false
        resultOverlay.popIn(fromScale: 0, duration: 0.5, delay: 0.5, completion: nil)
        
    }
    
    func setResultText() {
        titleLabel.text = "Match complete!"
        let titleFont = UIFont(name: "Roboto-Regular", size: 17)
        let descriptionFont = UIFont(name: "Roboto-Light", size: 13)
        let textColor = UIColor.white
        let attributes = [NSAttributedStringKey.font: titleFont, NSAttributedStringKey.foregroundColor: textColor]
        
        if let winner = matchPair?.winner?.name {
            let loser = matchPair?.loser!.name!
            
        
            let attributedString = NSMutableAttributedString(string: "\(winner) won! \(loser!) lost", attributes: attributes)
            attributedString.append(NSAttributedString(string: "\n (Click to change match result)", attributes: [NSAttributedStringKey.font: UIFont(name: "Roboto-Regular", size: 12), NSAttributedStringKey.foregroundColor: textColor]))
            
            resultLabel.attributedText =  attributedString
        } else if let draw = matchPair?.draw {
            let player1 = matchPair!.player1!.name!
            let player2 = matchPair!.player2!.name!
            let attributedString = NSMutableAttributedString(string: "\(player1) and \(player2) both drew!", attributes: attributes)
            attributedString.append(NSAttributedString(string: "\n (Click to change match result)", attributes: [NSAttributedStringKey.font: UIFont(name: "Roboto-Regular", size: 12), NSAttributedStringKey.foregroundColor: textColor]))
            
            resultLabel.attributedText =  attributedString
        }
        
    }
    
    func setAttributedText(player: Player) -> NSMutableAttributedString {
        let name = player.name
        let wins = player.totalWins
        let losses = player.totalLosses
        let statsString = "\n(" + String(describing: wins) + "W - " + String(describing: losses) + "L)"
        let attributedText = NSMutableAttributedString(string: name! + "  ", attributes: [NSAttributedStringKey.font : UIFont(name: "Roboto-Regular", size: 17)])
        
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
            whitePlayer = matchPair.player1!
            blackPlayer = matchPair.player2!
            print("Something went wrong with the colors")
        }
        
        
        let player1Name = whitePlayer!.name!
        let player1Wins = whitePlayer!.totalWins!
        let player1Losses = whitePlayer!.totalLosses!
        let player1StatsString = "\n(" + String(describing: player1Wins) + "W - " + String(describing: player1Losses) + "L)"
        let player1AttributedText = NSMutableAttributedString(string: player1Name + "  ", attributes: [NSAttributedStringKey.font : UIFont(name: "Roboto-Regular", size: 17)])
        
        player1AttributedText.append(NSAttributedString(string: player1StatsString , attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 17), NSAttributedStringKey.foregroundColor: UIColor.gray]))
        
        let player2Name = blackPlayer!.name!
        let player2Wins = blackPlayer!.totalWins!
        let player2Losses = blackPlayer!.totalLosses!
        let player2StatsString = "\n(" + String(describing: player2Wins) + "W - " + String(describing: player2Losses) + "L)"
        let player2AttributedText = NSMutableAttributedString(string: player2Name + "  ", attributes: [NSAttributedStringKey.font : UIFont(name: "Roboto-Regular", size: 17)])
        
        player2AttributedText.append(NSAttributedString(string: player2StatsString , attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 17), NSAttributedStringKey.foregroundColor: UIColor.gray]))
        
        player1NameLabel.attributedText = player1AttributedText
        player2NameLabel.attributedText = player2AttributedText
    }
    
    func showOverlay() {
        print("Show overlay")
        overlay.isHidden = false
        overlay.alpha = 0.5
        resultOverlay.isHidden = false
        resultOverlay.popIn(fromScale: 0, duration: 0.5, delay: 0.5, completion: nil)
        setResultText()
    }
    
    func hideOverlay() {
        overlay.isHidden = true
        //resultOverlay.isHidden = true
        resultOverlay.popOut(toScale: 0, duration: 0.5, delay: 0.5, completion: nil)
    }
    
    func clearResultsView() {
        overlay.isHidden = true
    }
}
