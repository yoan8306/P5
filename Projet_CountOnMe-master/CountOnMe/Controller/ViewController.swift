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
    @IBOutlet weak var resetButton: UIButton!
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

    @IBAction func resetCalcul(_ sender: UIButton) {
        calculator.resetCalculation()
        resetButton.setTitle("AC", for: .normal)
        textView.text = calculator.formatCalculToText()
    }

    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        calculator.resetCalculationIfNeed()
        calculator.addNumber(number: numberText)
        textView.text = calculator.formatCalculToText()
        resetButton.setTitle("C", for: .normal)
    }

    @IBAction func tappedOperatorButton(_ sender: UIButton) {
        guard let textOperator = sender.title(for: .normal), calculator.canAddOperator() else {
            presentAlert_Alert(alertMessage: "Veuillez inscrire un nombre avant")
            return
        }
            calculator.addOperator(newOperator: textOperator)
            textView.text = calculator.formatCalculToText()
    }

    @IBAction func tappedEqualButton(_ sender: UIButton) {

        guard !calculator.calculationIsFinish else {
            presentAlert_Alert(alertMessage: "Le calcule est terminé."
                               + "\nPressez un nombre pour commencer un nouveau calcule.")
            return
        }

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
