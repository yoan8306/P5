//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var timer: Timer?
    var counter = 0
    var calculator = SimpleCalc()
    var expressionHaveResult: Bool {
        return textView.text.firstIndex(of: "=") != nil
    }

    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!
    @IBOutlet weak var gifImage: UIImageView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gifImage.loadGif(name: "gifCalculation")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,
                                selector: #selector(progressTimer), userInfo: nil, repeats: true)
    }

    @objc func progressTimer() {
        counter += 1
        if counter == 5 {
            gifImage.isHidden = true
            timer?.invalidate()
               timer = nil
        }
    }

    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        if expressionHaveResult {
            textView.text = ""
        }
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        calculator.addNumber(number: numberText)
        textView.text.append(numberText)
    }

    @IBAction func tappedOperatorButton(_ sender: UIButton) {
        guard let textOperator = sender.title(for: .normal) else {
            return
        }

        if calculator.addOperator(newOperator: textOperator) {
            switch sender.titleLabel?.text {
            case "+":
                textView.text.append(" + ")
            case "÷":
                textView.text.append(" ÷ ")
            case "x":
                textView.text.append(" x ")
            case "-":
                textView.text.append(" - ")
            default:
                presentAlert_Alert(alertTitle: "Fault",
                                   alertMessage: "Erreur inconnu",
                                   buttonTitle: "Ok", alertStyle: .cancel)
            }

        } else {
            presentAlert_Alert(alertTitle: "Erreur",
                               alertMessage: "Veuillez inscrire un nombre avant",
                               buttonTitle: "Ok", alertStyle: .cancel)
        }
    }

    @IBAction func tappedEqualButton(_ sender: UIButton) {
        if let calculTotal = calculator.equal() {
            textView.text.append(" = " + calculTotal)
        } else {
            presentAlert_Alert(alertTitle: "Erreur",
                               alertMessage: "Veuillez entrer une expression correcte",
                               buttonTitle: "Ok", alertStyle: .cancel)
        }
    }

    private func presentAlert_Alert (alertTitle title: String,
                                     alertMessage message: String,
                                     buttonTitle titleButton: String, alertStyle style: UIAlertAction.Style ) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: titleButton, style: style, handler: nil)
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }
}
