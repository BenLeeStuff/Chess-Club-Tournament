//
//  CreateTournamentOptionsViewController.swift
//  Chess Club Tournament
//
//  Created by Ben Lee on 1/30/19.
//  Copyright © 2019 Ben Lee. All rights reserved.
//


import Foundation
import  UIKit

protocol CreateTournamentOptionsDelegate: class {
    func hideOverlay()
    func toAddPlayersVC(numberOfPlayers: Int, numberOfRounds: Int)
}

class CreateTournamentOptionsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    weak var delegate: CreateTournamentOptionsDelegate?
    
    let rounds = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"]
    let players = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30"]
    
    var data: [String] = []
    var numberOfPlayersPicker = UIPickerView()
    var numberOfRoundsPicker = UIPickerView()
    var activeTextField: UITextField?
    
    var numberOfPlayers: Int = 0
    var numberOfRounds: Int = 0
    
    let mainView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.GRAY()
        v.layer.cornerRadius = 8
        return v
    }()
    
    let titleLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont(name: "Roboto-Regular", size: 22)
        l.textColor = UIColor.TEXTCOLOR()
        l.text = "Create Tournament"
        l.textAlignment = .left
        return l
    }()
    
    let randomLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 16)
        l.textColor = UIColor.CHESSLIGHTBLACK()
        l.text = "Pair players randomly"
        l.textAlignment = .left
        return l
    }()
    
    let basedOnRatedLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 16)
        l.textColor = UIColor.CHESSLIGHTBLACK()
        l.text = "Pair players by rating"
        l.textAlignment = .left
        return l
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
    
    let randomSwitch: UISwitch = {
        let sw = UISwitch()
        sw.setOn(false, animated: false)
        sw.addTarget(self, action: #selector(checkCriteriaCompleteForRandomSwitch), for: .valueChanged)
        return sw
    }()
    
    let ratedSwitch: UISwitch = {
        let sw = UISwitch()
        sw.setOn(false, animated: false)
        sw.addTarget(self, action: #selector(checkCriteriaCompleteForRatedSwitch), for: .valueChanged)
        return sw
    }()
    
    let numberOfPlayersLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 16)
        l.textColor = UIColor.CHESSLIGHTBLACK()
        l.text = "Number Of Players"
        l.textAlignment = .left
        return l
    }()
    
    let numberOfRoundsLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 16)
        l.textColor = UIColor.CHESSLIGHTBLACK()
        l.text = "Number of Rounds"
        l.textAlignment = .left
        return l
    }()
    
    let numberOfPlayersTextfield: TextField = {
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
    
    let numberOfRoundsTextfield: TextField = {
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
    
    let continueButton: UIButton = {
        let button = UIButton(type: .system)
        let font = UIFont(name: "Roboto-Medium", size: 15)
        let attributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: UIColor.white]
        let attributedString = NSAttributedString(string: "Continue", attributes: attributes)
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.rgb(red: 41, green:203 , blue: 152)
        return button
    }()
    
    override func viewDidLoad() {
        setupViews()
    }
    
    func setupViews() {
        numberOfPlayersPicker.delegate = self
        numberOfPlayersPicker.dataSource = self
        numberOfRoundsPicker.dataSource = self
        numberOfRoundsPicker.delegate = self
        
        view.addSubview(mainView)
        mainView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 80, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: view.frame.height * 0.6)
        
        mainView.addSubview(cancelButton)
        cancelButton.anchor(top: nil, left: nil, bottom: nil, right: mainView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 25, width: 60, height: 45)
        
        mainView.addSubview(titleLabel)
        titleLabel.anchor(top: mainView.topAnchor, left: mainView.leftAnchor, bottom: nil, right: mainView.rightAnchor, paddingTop: 25, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        cancelButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        
        numberOfPlayersTextfield.inputView = numberOfPlayersPicker
        numberOfPlayersTextfield.delegate = self
        
        numberOfRoundsTextfield.inputView = numberOfRoundsPicker
        numberOfRoundsTextfield.delegate = self
        
        let switchStackView = UIStackView(arrangedSubviews: [randomSwitch, ratedSwitch])
        switchStackView.distribution = .equalSpacing
        switchStackView.axis = .vertical
        let switchLabelStackView = UIStackView(arrangedSubviews: [randomLabel, basedOnRatedLabel])
        switchLabelStackView.distribution = .equalSpacing
        switchLabelStackView.axis = .vertical
        
        let mainSwitchStackView = UIStackView(arrangedSubviews: [switchLabelStackView, switchStackView])
        
        
        let playersRoundsStackView = UIStackView(arrangedSubviews: [numberOfPlayersLabel, numberOfRoundsLabel])
        numberOfPlayersLabel.widthAnchor.constraint(equalToConstant: view.frame.width/2).isActive = true
        numberOfRoundsLabel.widthAnchor.constraint(equalToConstant: view.frame.width/2).isActive = true
        numberOfPlayersLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        numberOfRoundsLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        playersRoundsStackView.distribution = .equalSpacing
        playersRoundsStackView.axis = .vertical
        
        
        let textfieldStackView = UIStackView(arrangedSubviews: [numberOfPlayersTextfield, numberOfRoundsTextfield])
        numberOfPlayersTextfield.heightAnchor.constraint(equalToConstant: 35).isActive = true
        numberOfRoundsTextfield.heightAnchor.constraint(equalToConstant: 35).isActive = true
        textfieldStackView.distribution = .equalSpacing
        textfieldStackView.axis = .vertical
        let mainPlayersRoundsStackView = UIStackView(arrangedSubviews: [playersRoundsStackView, textfieldStackView])
        
        mainPlayersRoundsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        mainView.addSubview(mainSwitchStackView)
        mainSwitchStackView.anchor(top: titleLabel.bottomAnchor, left: mainView.leftAnchor, bottom: nil, right: mainView.rightAnchor, paddingTop: 45, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 80)
        
        mainView.addSubview(mainPlayersRoundsStackView)
        mainPlayersRoundsStackView.anchor(top: mainSwitchStackView.bottomAnchor, left: mainView.leftAnchor, bottom: nil, right: mainView.rightAnchor, paddingTop: 45, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 90)
        
        mainView.addSubview(continueButton)
        continueButton.anchor(top: nil, left: mainView.leftAnchor, bottom: mainView.bottomAnchor, right: mainView.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: -20, paddingRight: 20, width: 0, height: 50)
        
        disableContinueButton()
        
    }
    
    @objc func handleCancel() {
        self.delegate?.hideOverlay()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleContinue() {
        let addPlayersViewController = AddPlayersViewController()
//        addPlayersViewController.numberOfPlayers = self.numberOfPlayers
//        addPlayersViewController.numberOfRounds = self.numberOfRounds
        navigationController?.pushViewController(addPlayersViewController, animated: true)
        self.dismiss(animated: true) {
            self.delegate?.hideOverlay()
            self.delegate?.toAddPlayersVC(numberOfPlayers: self.numberOfPlayers, numberOfRounds: self.numberOfRounds)
        }
        print("Number of players \(self.numberOfPlayers)")
    }
    
    @objc func checkCriteriaCompleteForRandomSwitch() {
        if randomSwitch.isOn {
            turnOffRatedSwitch()
            if (numberOfPlayersTextfield.text != "0") && (numberOfRoundsTextfield.text != "0") {
                enableContinueButton()
            } else {
                disableContinueButton()
            }
        } else {
            
        }
    }
    
    @objc func checkCriteriaCompleteForRatedSwitch() {
        if ratedSwitch.isOn {
            turnOffRandomSwitch()
            if (numberOfPlayersTextfield.text != "0") && (numberOfRoundsTextfield.text != "0") {
                enableContinueButton()
            } else {
                disableContinueButton()
            }
        } else {
            
        }
    }
    
    func checkCriteriaComplete() {
        if randomSwitch.isOn || ratedSwitch.isOn {
            if (numberOfPlayersTextfield.text != "0") && (numberOfRoundsTextfield.text != "0") {
                enableContinueButton()
            } else {
                disableContinueButton()
            }
        } else {
            disableContinueButton()
        }
    }
    
    func enableContinueButton() {
        continueButton.isEnabled = true
        continueButton.alpha = 1
    }
    
    func disableContinueButton() {
        continueButton.isEnabled = false
        continueButton.alpha = 0.5
    }
    
    func turnOffRandomSwitch() {
        randomSwitch.isOn = false
    }
    
    func turnOffRatedSwitch() {
        ratedSwitch.isOn = false
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkCriteriaComplete()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.inputView == self.numberOfPlayersPicker {
            activeTextField = numberOfPlayersTextfield
            self.numberOfPlayersPicker.reloadAllComponents()
            self.data = self.players
        } else if textField.inputView == numberOfRoundsPicker {
            activeTextField = numberOfRoundsTextfield
            self.data = self.rounds
            self.numberOfRoundsPicker.reloadAllComponents()
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == numberOfPlayersPicker {
            numberOfPlayersTextfield.text = data[row]
            guard let number = Int(data[row]) else {return}
            numberOfPlayers = number
            
        } else if pickerView == numberOfRoundsPicker {
            numberOfRoundsTextfield.text = data[row]
            guard let rounds = Int(data[row]) else {return}
            numberOfRounds = rounds
        }
        
        self.view.endEditing(true)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    
    
}

