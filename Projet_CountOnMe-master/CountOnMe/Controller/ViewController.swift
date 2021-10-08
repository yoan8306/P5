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
    var calculator = LogicCalculation()

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
        if calculator.resetCalculationIfNeed() {
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

        if calculator.canAddOperator() {
            calculator.addOperator(newOperator: textOperator)
            switch textOperator {
            case "+":
                textView.text.append(" + ")
            case "÷":
                textView.text.append(" ÷ ")
            case "x":
                textView.text.append(" x ")
            case "-":
                textView.text.append(" - ")
            default:
                presentAlert_Alert(alertMessage: "Erreur inconnu")
            }

        } else {
            presentAlert_Alert(alertMessage: "Veuillez inscrire un nombre avant")
        }
    }

    @IBAction func tappedEqualButton(_ sender: UIButton) {

        if calculator.isCalculationValid() {
            textView.text.append(" = " + calculator.equal())
        } else {
            presentAlert_Alert(alertMessage: "Veuillez entrer une expression correcte")
        }
    }

    private func presentAlert_Alert (alertTitle title: String = "Erreur",
                                     alertMessage message: String,
                                     buttonTitle titleButton: String = "Ok",
                                     alertStyle style: UIAlertAction.Style = .cancel) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: titleButton, style: style, handler: nil)
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }
}
