//
//  AddPlayerCardViewController.swift
//  Chess Club Tournament
//
//  Created by Ben Lee on 2/8/19.
//  Copyright © 2019 Ben Lee. All rights reserved.
//

import UIKit

protocol AddPlayersCardDelegate: class {
    func addPlayerToTournament(player: Player)
}


class AddPlayerCardViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    var tournamentSettingsViewController = TournamentSettingViewController()
    weak var delegate: AddPlayersCardDelegate?

    var wins: [String] = []
    var losses: [String] = []
    var draws: [String] = []
    
    var data: [String] = []
    
    var maxPossibleWins: Int = 0
    var maxPossibleLosses: Int = 0
    var maxPossibleDraws: Int = 0
    var currentRound: Int = 0
    
    var playerToAdd: Player?
    
    let mainView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.GRAY()
        v.layer.cornerRadius = 8
        return v
    }()
    
    let cancelButton : UIButton = {
        let button = UIButton(type: .system)
//        let font = UIFont(name: "Roboto-Regular", size: 13)
//        let attributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: UIColor.rgb(red: 252, green: 63, blue: 75)]
//        let attributedString = NSAttributedString(string: "Cancel", attributes: attributes)
        //button.setTitle("Cancel", for: .normal)
        //button.setAttributedTitle(attributedString, for: .normal)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(UIColor.rgb(red: 252, green: 63, blue: 75), for: .normal)
        button.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 15)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    let titleLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont(name: "Roboto-Regular", size: 22)
        l.textColor = UIColor.TEXTCOLOR()
        l.text = "Add Player"
        l.textAlignment = .left
        return l
    }()
    
    let nameLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 16)
        l.textColor = UIColor.CHESSLIGHTBLACK()
        l.text = "Player Name"
        l.textAlignment = .left
        return l
    }()
    
    let winsLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 16)
        l.textColor = UIColor.CHESSLIGHTBLACK()
        l.text = "Total Wins"
        l.textAlignment = .left
        return l
    }()
    
    let lossesLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 16)
        l.textColor = UIColor.CHESSLIGHTBLACK()
        l.text = "Total Losses"
        l.textAlignment = .left
        return l
    }()
    
    let drawsLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 16)
        l.textColor = UIColor.CHESSLIGHTBLACK()
        l.text = "Total Draws"
        l.textAlignment = .left
        return l
    }()
    
    let nameTextField: TextField = {
        let tf = TextField()
        tf.placeholder = "Add Player Name"
        tf.textAlignment = .right
        tf.textColor = UIColor.TEXTCOLOR()
        tf.backgroundColor = UIColor.GRAY()
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.layer.cornerRadius = 5
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.lightGray.cgColor
        return tf
    }()
    
    let winsTextField: TextField = {
        let tf = TextField()
        tf.text = "0"
        tf.textAlignment = .right
        tf.textColor = UIColor.TEXTCOLOR()
        tf.backgroundColor = UIColor.GRAY()
        tf.layer.cornerRadius = 5
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.lightGray.cgColor
        return tf
    }()
    
    let lossesTextField: TextField = {
        let tf = TextField()
        tf.text = "0"
        tf.textAlignment = .right
        tf.textColor = UIColor.TEXTCOLOR()
        tf.backgroundColor = UIColor.GRAY()
        tf.layer.cornerRadius = 5
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.lightGray.cgColor

        return tf
    }()
    
    let drawsTextField: TextField = {
        let tf = TextField()
        tf.text = "0"
        tf.textAlignment = .right
        tf.textColor = UIColor.TEXTCOLOR()
        tf.backgroundColor = UIColor.GRAY()
        tf.layer.cornerRadius = 5
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.lightGray.cgColor
        return tf
    }()
    
    let addButton: UIButton = {
        let button = UIButton(type: .system)
        let font = UIFont(name: "Roboto-Medium", size: 15)
        let attributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: UIColor.white]
        let attributedString = NSAttributedString(string: "Add", attributes: attributes)
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(self, action: #selector(handleAddPlayer), for: .touchUpInside)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.rgb(red: 41, green:203 , blue: 152)
        button.isEnabled = false
        button.alpha = 0.5
        return button
    }()
    
    var totalWinsPicker = UIPickerView()
    var totalLossesPicker = UIPickerView()
    var totalDrawsPicker = UIPickerView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Add Player"
        setArrays()
        disableAddButton()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    func setupUI() {
        
        totalWinsPicker.delegate = self
        totalWinsPicker.dataSource = self
        totalLossesPicker.dataSource = self
        totalLossesPicker.delegate = self
        
        let labelStackView = UIStackView(arrangedSubviews: [nameLabel, winsLabel, lossesLabel, drawsLabel])
        labelStackView.distribution = .equalSpacing
        labelStackView.axis = .vertical
        
        view.addSubview(mainView)
        mainView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 80, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: view.frame.height * 0.65)
        
        mainView.addSubview(cancelButton)
        cancelButton.anchor(top: nil, left: nil, bottom: nil, right: mainView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 25, width: 60, height: 45)
        
        mainView.addSubview(titleLabel)
        titleLabel.anchor(top: mainView.topAnchor, left: mainView.leftAnchor, bottom: nil, right: mainView.rightAnchor, paddingTop: 25, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        cancelButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        
        mainView.addSubview(addButton)
        addButton.anchor(top: nil, left: mainView.leftAnchor, bottom: mainView.bottomAnchor, right: mainView.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: -30, paddingRight: 20, width: 0, height: 50)
        
        mainView.addSubview(labelStackView)
        labelStackView.anchor(top: titleLabel.bottomAnchor, left: mainView.leftAnchor, bottom: addButton.topAnchor, right: nil, paddingTop: 40, paddingLeft: 20, paddingBottom: -40, paddingRight: 30, width: mainView.frame.width / 2.2, height: 0)
        
        mainView.addSubview(nameTextField)
        mainView.addSubview(winsTextField)
        mainView.addSubview(lossesTextField)
        mainView.addSubview(drawsTextField)
        
        nameTextField.anchor(top: nil, left: labelStackView.rightAnchor, bottom: nil, right: mainView.rightAnchor, paddingTop: 0, paddingLeft: 10 , paddingBottom: 0, paddingRight: 20, width: 0, height: 40)
         nameTextField.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
        
        winsTextField.anchor(top: nil, left: labelStackView.rightAnchor, bottom: nil, right: mainView.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 20, width: 0, height: 40)
        winsTextField.centerYAnchor.constraint(equalTo: winsLabel.centerYAnchor).isActive = true

        lossesTextField.anchor(top: nil, left: labelStackView.rightAnchor, bottom: nil, right: mainView.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 20, width: 0, height: 40)
        lossesTextField.centerYAnchor.constraint(equalTo: lossesLabel.centerYAnchor).isActive = true
        
        drawsTextField.anchor(top: nil, left: labelStackView.rightAnchor, bottom: nil, right: mainView.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 20, width: 0, height: 40)
        drawsTextField.centerYAnchor.constraint(equalTo: drawsLabel.centerYAnchor).isActive = true
        
        winsTextField.inputView = totalWinsPicker
        winsTextField.delegate = self
        
        lossesTextField.inputView = totalLossesPicker
        lossesTextField.delegate = self
        
        drawsTextField.inputView = totalDrawsPicker
        drawsTextField.delegate = self
        
        
    }
    
    func setArrays() {
        let num = tournamentSettingsViewController.currentRound
        for index in 0...num {
            let val = String(index)
            wins.append(val)
            losses.append(val)
            draws.append(val)
        }
        
        print(wins)
        print(losses)
        print(draws)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        switch textField {
        case winsTextField:
            self.data = self.wins
            self.totalWinsPicker.reloadAllComponents()
        case lossesTextField:
            self.data = self.losses
            self.totalLossesPicker.reloadAllComponents()
        case drawsTextField:
            self.data = self.draws
            self.totalDrawsPicker.reloadAllComponents()
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if nameTextField.text != "" {
            enableAddButton()
        } else {
            disableAddButton()
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView {
        case totalWinsPicker:
            winsTextField.text = data[row]
        case totalLossesPicker:
            lossesTextField.text = data[row]
        case totalDrawsPicker:
            drawsTextField.text = data[row]
        default:
            break
        }

        self.view.endEditing(true)
    }
    
    func enableAddButton() {
        addButton.isEnabled = true
        addButton.alpha = 1
    }
    
    func disableAddButton() {
        addButton.isEnabled = false
        addButton.alpha = 0.5
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    
    @objc func handleCancel() {
        //self.delegate?.hideOverlay()
        tournamentSettingsViewController.hideOverlay()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleAddPlayer() {
        guard let name = nameTextField.text else {return}
        guard let totalWins = winsTextField.text else {return}
        guard let totalLosses = lossesTextField.text else {return}
        guard let totalDraws = drawsTextField.text else {return}
        
        let winScore = Double(totalWins)
        let lossScore = Double(totalWins)
        let drawScore = Double(totalWins)! / 2
        
        var totalScore = winScore! + lossScore! + drawScore
        
        if totalScore <= 0 {
            totalScore = 0
        }

        playerToAdd = Player(name: name, boardColor: "White", didWin: false, didLose: false, didDraw: false, place: nil, totalWins: Int(totalWins), totalLosses: Int(totalLosses), totalDraws: Int(totalDraws), totalScore: totalScore, scores: [], previousColor: nil, lastPlayed: nil, opponentsPlayed: nil, isSittingOut: false)
        
        self.dismiss(animated: true, completion: nil)
        delegate?.addPlayerToTournament(player: playerToAdd!)
    }
    

}
