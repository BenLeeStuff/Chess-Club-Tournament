//
//  TournamentViewController.swift
//  Chess Club Tournament
//
//  Created by Ben Lee on 1/30/19.
//  Copyright © 2019 Ben Lee. All rights reserved.
//

import UIKit

protocol TournamentViewControllerDelegate: class {
    func showOverlay()
    func clearResultsView()
}

class TournamentViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, MatchupResultsDelegate, SittingOutDelegate, PlayersViewControllerDelegate {
    weak var delegate: TournamentViewControllerDelegate?
    
    let cellId = "cellId"
    let matchupCellId = "matchupCellId"
    let sitOutCellId = "SitOutcellId"
    var selectedIndexPath : IndexPath?
    
    var names: [String] = []
    var numberOfPairs = 0
    var players: [Player] = []
    var playersSittingOut: [Player] = []
    var allPairsAndPlayersSittingOut = [] as [Any]
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
    
    let topBar: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        v.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        v.layer.shadowOpacity = 1
        v.layer.shadowOffset = CGSize.zero
        v.layer.shadowRadius = 2
        return v
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
    
    let optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(optionsButtonPressed), for: .touchUpInside)
        button.setTitle("Settings", for: .normal)
        button.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 15)
        //button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    let leaderBoardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Leaderboard", for: .normal)
        button.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 15)
        //button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    let playersButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Players", for: .normal)
        button.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 15)
        //button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    let overlay: UIView = {
        let v = UIView()
        v.backgroundColor = .black
        v.alpha = 0.5
        v.isHidden = true
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        navigationItem.title = "Tournament"
        view.backgroundColor = UIColor.GRAY()
        currentRound = 1
        registerCells()
        setupUI()
        //setupPlayers()
        print("PlayerCount: \(players.count)")
        setPlayersSittingOut()
        setupMatchPairs(players: players)
        updateAllPairsAndPlayersSittingOut()
        setColors()
        listMatchUps()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    func setupUI() {
        //self.navigationItem.hidesBackButton = true
        let margins = view.layoutMarginsGuide

        view.addSubview(topBar)
        topBar.anchor(top: margins.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 1, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 55)
        
        let topStackView = UIStackView(arrangedSubviews: [playersButton, leaderBoardButton, optionsButton])
        topStackView.distribution = .equalSpacing
        topStackView.axis = .horizontal
        topStackView.backgroundColor = UIColor.white
        
        view.addSubview(topStackView)
        topStackView.anchor(top: topBar.topAnchor, left: view.leftAnchor, bottom: topBar.bottomAnchor, right: view.rightAnchor, paddingTop: 1, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)

        view.addSubview(roundLabel)
        roundLabel.anchor(top: topStackView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width/3, height: 50)
        
        view.addSubview(nextRoundButton)
        nextRoundButton.anchor(top:roundLabel.topAnchor, left: roundLabel.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 100, width: 0, height: 50)
    
        
        view.addSubview(collectionView)
        collectionView.anchor(top: roundLabel.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(overlay)
        overlay.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        //collectionView.contentInset = UIEdgeInsets(top: ,left: 0, bottom: 0,right: 0)

        
    }
    
    func registerCells() {
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(MatchupCollectionViewCell.self, forCellWithReuseIdentifier: matchupCellId)
        collectionView.register(SitOutCollectionViewCell.self, forCellWithReuseIdentifier: sitOutCellId)
    }
    
    func showTournamentOverlay() {
        self.overlay.isHidden = false
        UIView.animate(withDuration: 0.35, animations: {
            self.overlay.alpha = 0.5
        }) { (true) in
            self.overlay.isHidden = false
        }
    }
    
    func hideTournamentOverlay() {
        UIView.animate(withDuration: 0.35, animations: {
            self.overlay.alpha = 0
        }) { (true) in
            self.overlay.isHidden = true
        }
    }
    
    func setPlayersSittingOut() {
        for index in stride(from: (players.count - 1), to: -1, by: -1) {
            print("Index; \(index)")
            if players[index].isSittingOut == true {
                players[index].name = players[index].name!.replacingOccurrences(of: " (Sitting Out)", with: "")
                playersSittingOut.append(players[index])
                players.remove(at: index)
            }
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
                var matchPair = MatchPair(player1: nil, player2: nil, players: nil,  matchComplete: nil, winner: nil, loser: nil, draw: nil)
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

        if playersSittingOut.count > 0 {
            if indexPath.item <= (matchPairs.count - 1) {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: matchupCellId, for: indexPath) as! MatchupCollectionViewCell
                cell.matchPair = matchPairs[indexPath.item]
                cell.setAttributedText(matchPair: matchPairs[indexPath.item])
                cell.titleLabel.text = "Match In Progress"
                return cell

            } else if indexPath.item > (matchPairs.count - 1) {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: sitOutCellId, for: indexPath) as! SitOutCollectionViewCell
                cell.player = playersSittingOut[indexPath.item - (matchPairs.count)] as! Player
                    //cell.setAttributedText(player: playersSittingOut[indexPath.item - (matchPairs.count) ] as! Player)
                
                return cell
            } else {
                return UICollectionViewCell()
            }
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: matchupCellId, for: indexPath) as! MatchupCollectionViewCell
            cell.matchPair = matchPairs[indexPath.item]
            cell.setAttributedText(matchPair: matchPairs[indexPath.item])
            cell.titleLabel.text = "Match in progress"
            return cell
        }
    
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? MatchupCollectionViewCell {
            self.delegate = cell
            
            let matchupResultViewController = MatchupResultsViewController()
            matchupResultViewController.currentIndexPath = indexPath
            selectedIndexPath = indexPath
            matchupResultViewController.matchPair = matchPairs[indexPath.item]
            matchupResultViewController.delegate = self
            matchupResultViewController.currentIndex = indexPath.item
            
            let pairs = matchPairs
            let player1Color = pairs[indexPath.item].player1!.boardColor!
            
            if player1Color == "White" {
                matchupResultViewController.whiteWinButton.setTitle("\(pairs[indexPath.item].player1!.name!) Won", for: .normal)
                matchupResultViewController.whiteWinButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 18)
                matchupResultViewController.whiteWinButton.setTitleColor(UIColor.BLACKCOLOR(), for: .normal)
                
                matchupResultViewController.blackWinButton.setTitle("\(pairs[indexPath.item].player2!.name!) Won", for: .normal)
                matchupResultViewController.blackWinButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 18)
                matchupResultViewController.blackWinButton.setTitleColor(UIColor.white, for: .normal)
            } else if player1Color == "Black" {
                matchupResultViewController.whiteWinButton.setTitle("\(pairs[indexPath.item].player2!.name!) Won", for: .normal)
                matchupResultViewController.whiteWinButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 18)
                matchupResultViewController.whiteWinButton.setTitleColor(UIColor.BLACKCOLOR(), for: .normal)
                
                matchupResultViewController.blackWinButton.setTitle("\(pairs[indexPath.item].player1!.name!) Won", for: .normal)
                matchupResultViewController.blackWinButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 18)
                matchupResultViewController.blackWinButton.setTitleColor(UIColor.white, for: .normal)
            } else {
                print("Player 1 color: \(player1Color)")
            }
            
            print(matchPairs[indexPath.item].player1!.name, matchPairs[indexPath.item].player1!.boardColor!, matchPairs[indexPath.item].player2!.name, matchPairs[indexPath.item].player2!.boardColor!)
            navigationController?.pushViewController(matchupResultViewController, animated: true)
        } else {
            if let cell = collectionView.cellForItem(at: indexPath) as?  SitOutCollectionViewCell {
                let sittingOutViewController = SittingOutViewController()
                
                sittingOutViewController.modalPresentationStyle = .overCurrentContext
                sittingOutViewController.tournamentViewController = self
                sittingOutViewController.player = cell.player!
                sittingOutViewController.numberOfRounds = self.numberOfRounds!
                sittingOutViewController.currentRound = self.currentRound
                sittingOutViewController.numberOfPlayersSittingOut = self.playersSittingOut.count
                sittingOutViewController.playerIndexInAllPlayersAndPairs = indexPath.item
                sittingOutViewController.playersSittingOut = playersSittingOut

                sittingOutViewController.playersSittingOut = self.playersSittingOut
                sittingOutViewController.delegate = self
                self.showTournamentOverlay()
                navigationController?.present(sittingOutViewController, animated: true, completion: {
                    
                })
                print("Player Sitting Out selected")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Matchpairs: \(matchPairs.count)")
        listMatchUps()
        return matchPairs.count + playersSittingOut.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item <= matchPairs.count - 1{
            return CGSize(width: collectionView.frame.width - 20, height: 135)
        } else {
            return CGSize(width: collectionView.frame.width - 20, height: 115)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func updatePlayerResults(matchPair: MatchPair, index: Int) {
        matchPairs[index] = matchPair
        matchPairs[index].matchComplete = true
        checkIfAllMatchComplete()
        delegate?.showOverlay()
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
    
    @objc func playersButtonPressed() {
        
    }
    
    @objc func optionsButtonPressed() {
        let settingsViewController = TournamentSettingViewController()
        settingsViewController.currentRound = self.currentRound!
        settingsViewController.tournamentViewController = self
        navigationController?.pushViewController(settingsViewController, animated: true)
    }

    @objc func startNextRound() {
        setResults()
        setPlayersWithSameWins()
        sortPlayersInSameGroup()
        setColors()
        hideMatchupResults()
        resetForNewRound()
        
        
    }
    
    func hideMatchupResults() {
        //let index = matchPairs.count - 1
        
        for index in 0...matchPairs.count - 1 {
            let indexPath = IndexPath(item: index, section: 0)
            let cell = collectionView.cellForItem(at: indexPath) as! MatchupCollectionViewCell
            cell.hideOverlay()
        }
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
    
  
    func addPlayerToTournament(player: Player) {
        players.append(player)
        allPairsAndPlayersSittingOut.append(player)        
        playersSittingOut.append(player)
        
        let index = matchPairs.count + playersSittingOut.count - 1
        let indexPath = IndexPath(item: index, section: 0)
        
        collectionView.insertItems(at: [indexPath])
    }
    
    func updateAllPairsAndPlayersSittingOut() {
        allPairsAndPlayersSittingOut.removeAll()
        for index in 0...matchPairs.count - 1  {
            allPairsAndPlayersSittingOut.append(matchPairs[index])
        }
        if playersSittingOut.count != 0 {
            for index in 0...playersSittingOut.count - 1 {
                allPairsAndPlayersSittingOut.append(playersSittingOut[index])
                
            }
        }
        updatePlayers()
    }
    
    func updatePlayers() {
        players.removeAll()
        for pair in matchPairs {
            let player1 = pair.player1
            let player2 = pair.player2
            players.append(player1!)
            players.append(player2!)
        }
        
        for player in playersSittingOut {
            players.append(player)
        }
    }
    
    func addPairToTournament(pair: MatchPair, playerToMatch: Player, opponent: Player) {
        hideTournamentOverlay()
        matchPairs.append(pair)

        let playerToMatchName = playerToMatch.name!
        let opponentName = opponent.name!
        let plyrsSittingOut = self.playersSittingOut.filter {$0.name != playerToMatchName && $0.name != opponentName }
        self.playersSittingOut = plyrsSittingOut
        
        for player in players {
            if player.name == playerToMatchName || player.name == opponentName {
                player.isSittingOut = false
            }
        }
        collectionView.reloadData()
        //let playerToMatchIndexPath =
//        let index = matchPairs.count - 1
//        let indexPath = IndexPath(item: index, section: 0)
//
        //collectionView.insertItems(at: [indexPath])
        print("Pair \(pair) \(playerToMatch) \(opponent)")
    }
    
    func deletePlayerSittingOut(player: Player, indexPath: IndexPath) {
        let playerNameToDelete = player.name!
        for index in 0...playersSittingOut.count - 1 {
            if playersSittingOut[index].name! == playerNameToDelete {
                playersSittingOut.remove(at: index)
                
            }
        }
        //let indexPah = IndexPath(row: 1, section: 0)
        collectionView.deleteItems(at: [indexPath])
        let alert = UIAlertController(title: "Success!", message: "\(playerNameToDelete) has been removed!", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
    }

    func showPlayerAddedAlert(player: Player) {
        let name = player.name!
        let alert = UIAlertController(title: "Success!", message: "\(name) has been added!", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
    }
    
    func showOddPlayerAlert(player: Player, numberOfPlayers: Int) {
        let name = player.name!
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        let number = formatter.string(from: NSNumber(value: numberOfPlayers))
        let alert = UIAlertController(title: "Odd Number Of Players!", message: "Warning \(name) is the \(number!) player. By default, \(name) sits out, but you can pick the by in settings.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            // handle Ok
            self.showPlayerAddedAlert(player: player)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) in
            // handle cancel
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showSitOutAlert(player: Player) {
        let numberOfPlayersSittingOut = playersSittingOut.count
        let name = player.name!

        if numberOfPlayersSittingOut == 1 {
            let alert = UIAlertController(title: "Put!", message: "\(name) has been added!", preferredStyle: .alert)
            alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    
    
}
