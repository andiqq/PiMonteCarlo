//
//  ViewController.swift
//  PiMonteCarlo
//
//  Created by Dr. Andreas Plagens on 15/04/18.
//  Copyright © 2018 Dr. Andreas Plagens. All rights reserved.
//

import UIKit

var screenHeight: CGFloat?
var screenWidth: CGFloat?

var x = 0.0
var y = 0.0
var radius: Double { return sqrt (x * x + y * y) }
var innen = 0
var isIn = false
var cycles = 0

var piIteration = 0.0
var maxIterations = 20000
var maxRandom = UInt32.max


class ViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    
    
    @IBOutlet weak var maxIter: UITextField!
    @IBOutlet weak var piDisplay: UILabel!
    @IBOutlet weak var actualIterations: UILabel!
    @IBOutlet weak var Container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.isEnabled = true
        maxIter.text = String(maxIterations)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        screenWidth = Container.bounds.width
        screenHeight = Container.bounds.height
        // iteration()
    }
    
    func iteration(current: Int = 1) {
        guard current <= maxIterations else {
            button.isEnabled = true  // re-enable the button at the end
            return
        }
        
        // Generate random points on the fly
        //  x = Double(arc4random_uniform(maxRandom)) / Double(maxRandom)
        // y = Double(arc4random_uniform(maxRandom)) / Double(maxRandom)
        x = Double.random(in: 0...1)
        y = Double.random(in: 0...1)
        
        if radius <= 1.0 {
            innen += 1
            isIn = true
        } else {
            isIn = false
        }
        
        
        
            self.plot(x1: x, y1: y)
            
            // Calculate pi
            piIteration = Double(innen) / Double(current) * 4.0
            self.actualIterations.text = String(current)
            self.piDisplay.text = String(piIteration)
            
       
        
        
        // Schedule next iteration on the main thread.
        DispatchQueue.main.async {
            self.iteration(current: current + 1)
        }
    }
    
    func plot (x1: Double, y1: Double) {
        
        let screenX = Double(screenWidth!) * x1
        let screenY = Double(screenHeight!) - Double(screenHeight!) * y1
        
        
        DispatchQueue.main.async {
            let point = UIView(frame: CGRect(x: screenX, y: screenY, width: 1, height: 1))
            
            
            
            if isIn {
                point.backgroundColor = UIColor.red
            } else {
                point.backgroundColor = UIColor.blue
            }
            
            self.Container.addSubview(point)
            //  self.Container.setNeedsDisplay()
        }
        
        
        
        //let n = CGRect()
        // Container.draw(n)
        // Container.setNeedsDisplay()
        // Container.setNeedsLayout()
        // Container.setNeedsFocusUpdate()
        // sleep(1)
    }
    
    @IBAction func StartButton(_ sender: UIButton) {
        button.isEnabled = false
        maxIterations = Int(maxIter.text!) ?? 10000
        innen = 0
        iteration()
    }
}

