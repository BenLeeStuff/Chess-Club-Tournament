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
    var namesAfterAddPlayer: [String] = []
    var didAddPlayer: Bool = false
    
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
        lbl.font = UIFont(name: "Roboto-Regular", size: 14)
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
        
        view.addSubview(collectionView)
        collectionView.anchor(top: addPlayerButton.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        registerCells()
    }
    
    fileprivate func registerCells() {
        collectionView.register(AddPlayerCollectionViewCell.self, forCellWithReuseIdentifier: addPlayerCellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let addPlayerCell = collectionView.dequeueReusableCell(withReuseIdentifier: addPlayerCellId, for: indexPath) as! AddPlayerCollectionViewCell
        
//        if didAddPlayer {
//           // addPlayerCell.nameLabel.text = namesAfterAddPlayer[indexPath.item]
//        }
        addPlayerCell.number = String(indexPath.item + 1)
        addPlayerCell.nameTextField.delegate = self
        
        //addPlayerCell.nameLabel.text = names[indexPath.item]
        return addPlayerCell
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
        return 0
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.text != "") || (textField.text != "Add Player Name") {
            currentTextFieldName = textField.text!
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("ended")
        if textField.text != "" || textField.text != "Add Player Name" {
            let playerName = textField.text ?? ""
            if playerNames.contains(textField.text!) {
                print("name already in use ")
            } else {
                if let index = playerNames.index(of: currentTextFieldName) {
                    playerNames[index] = playerName
                    print("hot here")
                } else {
                    playerNames.append(playerName)
                }
            }
        } else if textField.text == "" {
        }
        print(playerNames)
        print("playerNames: \(playerNames)")
        print("player Count: \(playerNames.count)")
        
        return true
    }

    func setPlayerNames() {
        
        for index in 0...numberOfPlayers! - 1 {
            
        }
        
        for name in playerNames {
            names.append(name)
        }
    }
    
    func toTournamentViewController() {
        let tournamentVC = TournamentViewController()
        tournamentVC.names = names
        tournamentVC.numberOfRounds = numberOfRounds
        print("didsetttt \(numberOfRounds)")
        navigationController?.pushViewController(tournamentVC, animated: true)
    }
    
    func addPlayerToTournament(player: Player) {
        playersList.append(player)
        collectionView.reloadData()
    }
    
    func shiftValues() {
        namesAfterAddPlayer.removeAll()
        namesAfterAddPlayer.append("")
        for name in names {
            namesAfterAddPlayer.append(name)
        }
        names = namesAfterAddPlayer
        print("NEW \(namesAfterAddPlayer)")
    }
    
    func checkValidNames() {
        for index in 0...names.count - 1 {
            if names[index] == "" {
                names.remove(at: index)
            }
        }
    }
    
    
    
    @objc func addPlayerButtonPressed() {
        numberOfPlayers! += 1
        didAddPlayer = true
        shiftValues()
        collectionView.reloadData()
    }
    
    @objc func startTournament() {
        setPlayerNames()
        toTournamentViewController()
    }
}
