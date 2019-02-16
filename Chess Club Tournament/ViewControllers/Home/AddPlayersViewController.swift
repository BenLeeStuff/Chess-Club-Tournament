//
//  AddPlayersViewController.swift
//  Chess Club Tournament
//
//  Created by Ben Lee on 1/30/19.
//  Copyright © 2019 Ben Lee. All rights reserved.
//

import UIKit
class AddPlayersViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    var cells: [UICollectionViewCell] = []
    
    var playerSittingOutIndex: Int?
    
    
    var numberOfPlayers : Int? {
        didSet {
            print("NUMBER OD PLAYERS DID SET \(numberOfPlayers!)")
        }
    }
    var numberOfRounds: Int? {
        didSet {
            print("didSet number of rounds \(numberOfRounds!)")
        }
    }
    
    var names: [String] = []
    var players: [Player] = []

    var namesAfterAddPlayer: [String] = []
    
    var collectionViewTopBar: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.rgb(red: 0, green: 0, blue: 0)
        v.alpha = 0.1
        return v
    }()
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Add Players"
        lbl.font = UIFont(name: "Roboto-Regular", size: 22)
        lbl.textAlignment = .center
        lbl.textColor = UIColor.TEXTCOLOR()
        return lbl
    }()
    
    let descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Add players to enter in the tournament."
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
        cv.alwaysBounceVertical = true
        return cv
    }()
    
    let addPlayerButton: UIButton = {
        let button = UIButton(type: .system)
        let font = UIFont(name: "Roboto-Medium", size: 15)
        let attributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: UIColor.white]
        let attributedString = NSAttributedString(string: "AddPlayer", attributes: attributes)
        button.setAttributedTitle(attributedString, for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.rgb(red: 45, green: 193, blue: 222)
        //button.imageEdgeInsets
        button.addTarget(self, action: #selector(addPlayerButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let startTournamentButton: UIButton = {
        let button = UIButton(type: .system)
        let font = UIFont(name: "Roboto-Medium", size: 15)
        let attributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: UIColor.white]
        let attributedString = NSAttributedString(string: "Start Tournament", attributes: attributes)
        button.setAttributedTitle(attributedString, for: .normal)
        button.backgroundColor = UIColor.rgb(red: 41, green:203 , blue: 152)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(startTournament), for: .touchUpInside)
        return button
    }()
    var currentTextFieldName = ""
    var playerNames: [String] = []
    var playersList: [Player] = []
    var playersListWithSameWins: [Player] = []
    var matchPairs: [MatchPair] = []
    var allMatchPairs: [MatchPair] = []
    var results: [Player] = []
    var roundWinners: [Player] = []
    var roundLosers: [Player] = []
    var playersWithSameWins: [Player] = []
    
    var currentRound = 0
    
    let white = "White"
    let black = "Black"
    let colors = ["White", "Black"]
    let cellId = "cellId"
    let noPlayerCellId = "noPlayerCellId"
    let addPlayerCellId = "addPlayerCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        print("NUMBER OD PLAYERS: \(numberOfPlayers)")
    }
    
    override func viewDidLayoutSubviews() {
        descriptionLabel.anchor(top: navigationController?.navigationBar.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        navigationController?.navigationBar.topItem?.title = "Cancel"
        navigationItem.title = "Add Players"
        view.backgroundColor = UIColor.GRAY()
        
        view.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
        
     
        
        let buttonStackView = UIStackView(arrangedSubviews: [addPlayerButton, startTournamentButton])
        addPlayerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        startTournamentButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 50
        
        view.addSubview(buttonStackView)
        buttonStackView.anchor(top: descriptionLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 25, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        
        view.addSubview(collectionViewTopBar)
        collectionViewTopBar.anchor(top: startTournamentButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 25, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
        view.addSubview(collectionView)
        collectionView.anchor(top: collectionViewTopBar.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        registerCells()
    }
    
    fileprivate func registerCells() {
        collectionView.register(AddPlayerCollectionViewCell.self, forCellWithReuseIdentifier: addPlayerCellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if players.count > 0 {
            let addPlayerCell = collectionView.dequeueReusableCell(withReuseIdentifier: addPlayerCellId, for: indexPath) as! AddPlayerCollectionViewCell
   
            addPlayerCell.number = String(indexPath.item + 1)
            addPlayerCell.nameTextField.delegate = self
            
            let player = players[indexPath.item]
            
            if players[indexPath.item].isSittingOut == true {
                let playerName = players[indexPath.item].name!

                print("got here")
                let nameAttributes = [NSAttributedStringKey.font:  UIFont(name: "Roboto-Regular", size: 16), NSAttributedStringKey.foregroundColor: UIColor.TEXTCOLOR()]
                let sitOutAttributes = [NSAttributedStringKey.font:  UIFont(name: "Roboto-Regular", size: 14), NSAttributedStringKey.foregroundColor: UIColor.CHESSRED()]
                let nameAttributedString = NSMutableAttributedString(string: "\(players[indexPath.item].name!)", attributes: nameAttributes)
                let sitOutAttributedString = NSMutableAttributedString(string: " (Sitting Out)", attributes: sitOutAttributes)
                nameAttributedString.append(sitOutAttributedString)
                playerNames[indexPath.item] = "\(playerNames[indexPath.item]) (Sitting Out)"

                addPlayerCell.nameTextField.attributedText = nameAttributedString
            } else {
                addPlayerCell.name = players[indexPath.item].name!

            }
            return addPlayerCell
        } else {
            let addPlayerCell = collectionView.dequeueReusableCell(withReuseIdentifier: addPlayerCellId, for: indexPath) as! AddPlayerCollectionViewCell
            addPlayerCell.number = String(indexPath.item + 1)
            addPlayerCell.nameTextField.delegate = self
            return addPlayerCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("SELECTED")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let number = numberOfPlayers else { return 0 }
        if number > 0 {
            return number
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.text != "") || (textField.text != "Add Player Name") {
            currentTextFieldName = textField.text!
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("ended")
        if textField.text != "" || textField.text != "Add Player Name" {
            let playerName = textField.text ?? ""
            if playerNames.contains(textField.text!) {
                print("name already in use ")
            } else {
                if let index = playerNames.index(of: currentTextFieldName) {
                    playerNames[index] = playerName
                    print("got here")
                } else {
                    playerNames.append(playerName)
                }
            }
        } else if textField.text == "" {
        }
        print(playerNames)
        print("playerNames: \(playerNames)")
        print("Names Count: \(playerNames.count)")
        print("Player Count: \(players.count)")

        setPlayerNames(blankOk: true)
    }

    func setPlayerNames(blankOk: Bool) {
        names.removeAll()
        
        if blankOk == true {
            for index in 0...playerNames.count - 1 {
                names.append(playerNames[index])
            }
        } else {
            if playerNames.count > 0 {
                for index in 0...playerNames.count - 1 {
                    if playerNames[index] != "" {
                        names.append(playerNames[index])
                    }
                }
            }
        }
        playerNames = names
    }
    
    func setPlayers() {
        if players.count == 0 {
            for name in playerNames {
                
                let player = Player(name: name, boardColor: nil, didWin: nil, didLose: nil, didDraw: nil, place: nil, totalWins: 0, totalLosses: 0, totalDraws: 0, totalScore:0, scores: nil, previousColor: nil, lastPlayed: nil, opponentsPlayed: nil, isSittingOut: false)
                players.append(player)
            }
        } else {
            var unsetPlayerNamesHolder: [String] = []
            var playerNamesHolder: [String] = []
            
            for player in players {
                playerNamesHolder.append(player.name!)
            }
            for name in playerNames {
                unsetPlayerNamesHolder.append(name)
            }
            
            for name in playerNamesHolder {
                unsetPlayerNamesHolder = unsetPlayerNamesHolder.filter { $0 != name }
            }
            
            for name in unsetPlayerNamesHolder {
                let player = Player(name: name, boardColor: nil, didWin: nil, didLose: nil, didDraw: nil, place: nil, totalWins: 0, totalLosses: 0, totalDraws: 0, totalScore:0, scores: nil, previousColor: nil, lastPlayed: nil, opponentsPlayed: nil, isSittingOut: false)
                players.append(player)
            }
        }
    }
    
    func setPlayers(blankOk: Bool) {

        players.removeAll()
        if blankOk == true {
            for name in playerNames {

                if name.range(of:"Sitting Out") != nil {
                    let player = Player(name: name, boardColor: nil, didWin: nil, didLose: nil, didDraw: nil, place: nil, totalWins: 0, totalLosses: 0, totalDraws: 0, totalScore:0, scores: nil, previousColor: nil, lastPlayed: nil, opponentsPlayed: nil, isSittingOut: true)
                    players.append(player)

                } else {
                    let player = Player(name: name, boardColor: nil, didWin: nil, didLose: nil, didDraw: nil, place: nil, totalWins: 0, totalLosses: 0, totalDraws: 0, totalScore:0, scores: nil, previousColor: nil, lastPlayed: nil, opponentsPlayed: nil, isSittingOut: false)
                    players.append(player)

                }
            }
        } else {
            for name in playerNames {
                if name != "" {
                    if name.contains("(Sitting Out)") {
                        print("YES")
                        let player = Player(name: name, boardColor: nil, didWin: nil, didLose: nil, didDraw: nil, place: nil, totalWins: 0, totalLosses: 0, totalDraws: 0, totalScore:0, scores: nil, previousColor: nil, lastPlayed: nil, opponentsPlayed: nil, isSittingOut: true)
                        players.append(player)
                        
                    } else {
                        let player = Player(name: name, boardColor: nil, didWin: nil, didLose: nil, didDraw: nil, place: nil, totalWins: 0, totalLosses: 0, totalDraws: 0, totalScore:0, scores: nil, previousColor: nil, lastPlayed: nil, opponentsPlayed: nil, isSittingOut: false)
                        players.append(player)
                        
                    }
                }
            }
        }
    }
    
    func toTournamentViewController() {
        let tournamentVC = TournamentViewController()
        tournamentVC.names = names
        tournamentVC.numberOfRounds = numberOfRounds
        tournamentVC.players = players
        print("didsetttt \(numberOfRounds)")
        navigationController?.pushViewController(tournamentVC, animated: true)
    }
    
    func checkValidNames() {
        for index in 0...names.count - 1 {
            if names[index] == "" {
                names.remove(at: index)
            }
        }
    }
    
    @objc func addPlayerButtonPressed() {
        view.endEditing(true)
        setPlayers(blankOk: true)
        if players.count > 0 {
            numberOfPlayers! += 1
            let player = Player(name: "", boardColor: nil, didWin: nil, didLose: nil, didDraw: nil, place: nil, totalWins: 0, totalLosses: 0, totalDraws: 0, totalScore: 0, scores: nil, previousColor: nil, lastPlayed: nil, opponentsPlayed: nil, isSittingOut: false)
            players.append(player)
            playerNames.append(player.name!)
            showAddPlayerButtonAlert()
            let index = numberOfPlayers! - 1
            print("INDEx: \(index)")
            let indexPath = IndexPath(item: index, section: 0)
            collectionView.insertItems(at: [indexPath])
            collectionView.reloadItems(at: [indexPath])
            collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.bottom, animated: true)

        } else {
            numberOfPlayers! += 1
            let index = numberOfPlayers! - 1
            print("INDEx: \(index)")
            let indexPath = IndexPath(item: index, section: 0)
            collectionView.insertItems(at: [indexPath])
            collectionView.reloadItems(at: [indexPath])
            collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.bottom, animated: true)
        }
    }
    
    @objc func startTournament() {
        view.endEditing(true)
        setPlayerNames(blankOk: false)
        setPlayers(blankOk: false)
        if players.count % 2 != 0 { // Odd number of players
            
            var playersSittingOut = 0
            for index in 0...players.count - 1 {
                if players[index].isSittingOut == true {
                    playersSittingOut += 1
                }
            }
            
            if (players.count - playersSittingOut) % 2 != 0 {
                showOddAlert()
            } else {
                //setPlayers(blankOk: false)
                toTournamentViewController()
            }
            
        } else if players.count == 0 {
            // need to implement alert for no players
            //toTournamentViewController()
        } else if players.count == 1 {
            toTournamentViewController()
        } else {
            setPlayers(blankOk: false)
            toTournamentViewController()
        }
    }
    
    func showOddAlert() {
        let alert = UIAlertController(title: "Odd Players!", message: "There are an odd number of players. Please select a player to sit out, or add another player.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Select Player", style: .default) { (action) in
            // need to implement selecting of player sitting out
            
            self.setPlayers(blankOk: true)
            let selectPlayerToSitOutViewController = SelectSitOutPlayerViewController()
            selectPlayerToSitOutViewController.names = self.names
            selectPlayerToSitOutViewController.addPlayersViewController = self
            selectPlayerToSitOutViewController.players = self.players
            
           
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            self.navigationItem.backBarButtonItem = backItem
            self.navigationController?.pushViewController(selectPlayerToSitOutViewController, animated: true)
            
        }
        let cancel = UIAlertAction(title: "Add Player", style: .default, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)

        self.present(alert, animated: true, completion: nil)
    }
    
    func showAddPlayerButtonAlert() {

    }
    
    func printPlayerNames() {
        for player in players {
            print("NAMES: \(player.name)")
        }
    }
}
