//
//  TournamentViewController.swift
//  Chess Club Tournament
//
//  Created by Ben Lee on 1/30/19.
//  Copyright © 2019 Ben Lee. All rights reserved.
//

import UIKit

class TournamentViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, MatchupResultsDelegate{
    
    let cellId = "cellId"
    let matchupCellId = "matchupCellId"
    
    var names: [String] = []
    var numberOfPairs = 0
    var players: [Player] = []
    var matchPairs: [MatchPair] = []
    var allMatchesComplete = false
    var isOddPairs = false

    var currentRound: Int? {
        didSet {
            roundLabel.text = "Round: \(currentRound!)/\(String(describing: numberOfRounds!))"
        }
    }
    
    var results: [Player] = []
    var playersListWithSameWins: [[Player]] = [[]]
    var playersInSameGroup: [[Player]] = [[]]

    var numberOfRounds: Int? {
        didSet {
            roundLabel.text = "Round: \(currentRound)/\(String(describing: numberOfRounds!))"
        }
    }
    
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
    
    let roundLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Round: 1"
        lbl.font = UIFont(name: "Roboto-Regular", size: 18)
        lbl.textAlignment = .left
        lbl.textColor = UIColor.TEXTCOLOR()
        return lbl
    }()
    
    var nextRoundButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(startNextRound), for: .touchUpInside)
        button.setTitle("Start Next Round", for: .normal)
        button.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 15)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.BLACKCOLOR()
        button.layer.cornerRadius = 5
        button.isEnabled = false
        button.alpha = 0.5
        return button
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Tournament"
        view.backgroundColor = UIColor.GRAY()
        currentRound = 1
        registerCells()
        setupPlayers()
        setupMatchPairs(players: players)
        setColors()
        listMatchUps()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupUI()
    }
    
    func setupUI() {
        view.addSubview(roundLabel)
        roundLabel.anchor(top: navigationController?.navigationBar.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width/3, height: 50)
        
        view.addSubview(nextRoundButton)
        nextRoundButton.anchor(top:roundLabel.topAnchor, left: roundLabel.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 100, width: 0, height: 50)
        
        view.addSubview(collectionView)
        collectionView.anchor(top: roundLabel.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    func registerCells() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(MatchupCollectionViewCell.self, forCellWithReuseIdentifier: matchupCellId)
    }
    
    func setupPlayers() {
        for name in names {
            let player = Player(name: name, boardColor: nil, didWin: nil, didLose: nil, didDraw: nil, place: nil, totalWins: 0, totalLosses: 0, totalDraws: 0, totalScore:0, scores: nil, previousColor: nil, lastPlayed: nil, opponentsPlayed: nil)
            players.append(player)
        }
    }
    
    func setupMatchPairs(players: [Player]) {
        if players.count > 0 {
            var playerList = players
            var pairs: [MatchPair] = []
            
            let totalNumberOfPairs =  playerList.count / 2
            for index in 1...totalNumberOfPairs { // looping through the number of pairs
                var pair : [Player] = []
                for ind in 1...2 { // loop through twice to pick 2 people
                    let randomIndex = Int(arc4random_uniform(UInt32(playerList.count))) // getting a random index
                    let player = playerList[randomIndex]
                    pair.append(player)
                    playerList.remove(at: randomIndex)
                }
                var matchPair = MatchPair(player1: nil, player2: nil, players: nil,  matchComplete: nil)
                matchPair.player1 = pair[0]
                matchPair.player2 = pair[1]
                matchPairs.append(matchPair)
                
                pair.removeAll()
            }
        }
        if matchPairs.count % 2 != 0 {
            isOddPairs = true
        }
    }

    func setColors() { // setting the colors for the players
        for matchPair in matchPairs {
            var player1Color = matchPair.player1!.boardColor!
            var player2Color = matchPair.player2!.boardColor!
            
            
            if player1Color == player2Color {
                matchPair.player1!.boardColor = "White"
                matchPair.player2!.boardColor! = "Black"
            } else {
                if player1Color == "White" {
                    matchPair.player1!.boardColor! = "Black"
                    matchPair.player2!.boardColor! = "White"
                } else if player1Color == "Black" {
                    matchPair.player1!.boardColor! = "White"
                    matchPair.player2!.boardColor! = "Black"
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: matchupCellId, for: indexPath) as! MatchupCollectionViewCell
        cell.setAttributedText(matchPair: matchPairs[indexPath.item])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let matchupResultViewController = MatchupResultsViewController()
        let pairs = matchPairs
        matchupResultViewController.matchPair = pairs[indexPath.item]
        matchupResultViewController.delegate = self
        matchupResultViewController.currentIndex = indexPath.item
        
        let player1Color = pairs[indexPath.item].player1!.boardColor!
        
        if player1Color == "White" {
            matchupResultViewController.whiteWinButton.setTitle("\(pairs[indexPath.item].player1!.name!) Won", for: .normal)
            matchupResultViewController.whiteWinButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 18)
            matchupResultViewController.whiteWinButton.setTitleColor(UIColor.BLACKCOLOR(), for: .normal)
            
            matchupResultViewController.blackWinButton.setTitle("\(pairs[indexPath.item].player2!.name!) Won", for: .normal)
            matchupResultViewController.blackWinButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 18)
            matchupResultViewController.blackWinButton.setTitleColor(UIColor.white, for: .normal)
            print("JJJJJJJJJ")
        } else if player1Color == "Black" {
            matchupResultViewController.whiteWinButton.setTitle("\(pairs[indexPath.item].player2!.name!) Won", for: .normal)
            matchupResultViewController.whiteWinButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 18)
            matchupResultViewController.whiteWinButton.setTitleColor(UIColor.BLACKCOLOR(), for: .normal)
            
            matchupResultViewController.blackWinButton.setTitle("\(pairs[indexPath.item].player1!.name!) Won", for: .normal)
            matchupResultViewController.blackWinButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 18)
            matchupResultViewController.blackWinButton.setTitleColor(UIColor.white, for: .normal)
            print("LLLLLLLLLL")
        } else {
            print("Player 1 color: \(player1Color)")
        }
        
       
        
        print(matchPairs[indexPath.item].player1!.name, matchPairs[indexPath.item].player1!.boardColor!, matchPairs[indexPath.item].player2!.name, matchPairs[indexPath.item].player2!.boardColor!)
        navigationController?.pushViewController(matchupResultViewController, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Matchpairs: \(matchPairs.count)")
        listMatchUps()
        return matchPairs.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 130)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func updatePlayerResults(matchPair: MatchPair, index: Int) {
        matchPairs[index] = matchPair
        matchPairs[index].matchComplete = true
        checkIfAllMatchComplete()
        //collectionView.reloadData()
    
    }
    
    func checkIfAllMatchComplete() {
        let numberOfMatchPairs = matchPairs.count
        var counter = 0
        for pair in matchPairs {
            if pair.matchComplete! {
                counter += 1
            }
        }
        
        if counter == numberOfMatchPairs {
            allMatchesComplete = true
            enableNextRoundButton()
        }
    }
    
    func enableNextRoundButton() {
        nextRoundButton.isEnabled = true
        nextRoundButton.alpha = 1
    }
    
    func disableNextRoundButton() {
        nextRoundButton.isEnabled = false
        nextRoundButton.alpha = 0.5
    }
    
    func resetForNewRound() {
        allMatchesComplete = false
        results.removeAll()
        playersInSameGroup.removeAll()
        playersListWithSameWins.removeAll()
        
        disableNextRoundButton()
        currentRound? += 1
        collectionView.reloadData()
    }
    
    @objc func startNextRound() {
        
        setResults()
        setPlayersWithSameWins()
        sortPlayersInSameGroup()
        setColors()
        resetForNewRound()
    }
    
    func setResults() {

        results.removeAll()
        for pair in matchPairs {
            let player1 = pair.player1
            let player2 = pair.player2
            results.append(player1!)
            results.append(player2!)
        }
        matchPairs.removeAll()
    }
    
    func setPlayersWithSameWins() {
        var playersWithSameWins: [[Player]] = []
        
        for score in 0...currentRound! {
            var sameSection: [Player] = []
            for result in results {
                let player = result
                if player.totalWins! == score {
                    sameSection.append(player)
                }
            }
            playersWithSameWins.append(sameSection)
        }
        
        playersListWithSameWins = playersWithSameWins
    }
    
    func sortPlayersInSameGroup() {
        if isOddPairs {
            for index in 0...currentRound! {
                var group =  playersListWithSameWins[index]
                if group.count % 2 != 0 { // Odd number of players in the group
                    let oddPlayer = group[0]
                    group.remove(at: 0)
                    playersListWithSameWins[index] = group
                    if index < currentRound! {
                        playersListWithSameWins[index + 1].append(oddPlayer)
                    }
                    setupMatchPairs(players: group)
                } else { // Even number of players in the group
                    setupMatchPairs(players: group)
                }
            }
        } else { // Even number of pairs
            for index in 0...currentRound! {
                var group =  playersListWithSameWins[index]
                setupMatchPairs(players: group)
            }
        }
        listMatchUps()
    }
    
    func listMatchUps() {
        for matchPair in matchPairs {
            var player1 = matchPair.player1
            var player2 = matchPair.player2
            print()
            print("MATCHUPS: " + player1!.boardColor! + ": " + player1!.name!, "(\(String(player1!.totalWins!))W \(String(player1!.totalLosses!))L \(String(player1!.totalDraws!))D )" + "   VS   " + player2!.boardColor! + ": " + player2!.name!, "(\(String(player2!.totalWins!))W \(String(player2!.totalLosses!))L \(String(player2!.totalDraws!))D )")
        }
        print("")
    }
    
    
}
