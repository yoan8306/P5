//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var calculator = SimpleCalc()
    var expressionHaveResult: Bool {
        return textView.text.firstIndex(of: "=") != nil
    }
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!
    
    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        if expressionHaveResult {
            textView.text = ""
        }
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        calculator.addNumber(element: numberText)
//
        
        textView.text.append(numberText)
    }
    
    @IBAction func tappedOperatorButton(_ sender: UIButton) {
        
        guard let textOperator = sender.title(for: .normal) else {
            return
        }
        if calculator.addOperator(addOperation: textOperator) {

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
            presentAlert_Alert(alertTitle: "Fault", alertMessage: "Erreur inconnu", buttonTitle: "Ok", alertStyle: .cancel)
        }
        } else {
            presentAlert_Alert(alertTitle: "Erreur", alertMessage: "Veuiller inscrire un nombre en premier", buttonTitle: "Ok", alertStyle: .cancel)
        }
            
    }
    
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        if let calculTotal = calculator.equal() {
            textView.text.append(" = " + String(calculTotal))
            calculator.resetCalcul()
        } else {
            presentAlert_Alert(alertTitle: "Erreur", alertMessage: "Veuillez entrer une expression correcte", buttonTitle: "Ok", alertStyle: .cancel)
        }
    }
    
    private func presentAlert_Alert (alertTitle title: String, alertMessage message: String,buttonTitle titleButton: String, alertStyle style: UIAlertAction.Style ) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: titleButton, style: style, handler: nil)
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }
    
    
}

