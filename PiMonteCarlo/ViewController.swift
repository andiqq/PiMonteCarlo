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
    
    @MainActor
    func iteration(current: Int = 1) async {
        guard current <= maxIterations else { return }
        
        // Generate random points on the fly
        let xLocal = Double.random(in: 0...1)
        let yLocal = Double.random(in: 0...1)
        let r = sqrt(xLocal * xLocal + yLocal * yLocal)
        let pointInCircle = r <= 1.0
        if pointInCircle {
            innen += 1
        }
        
        // Plot the point (make sure plot is run on the main actor)
        await plot(x1: xLocal, y1: yLocal, inCircle: pointInCircle)
        
        // Calculate pi and update UI labels
        piIteration = Double(innen) / Double(current) * 4.0
        self.actualIterations.text = String(current)
        self.piDisplay.text = String(piIteration)
        
        // Optionally await a minimal delay to yield control
        try? await Task.sleep(nanoseconds: 1_000)  // 1,000 nanoseconds
        
        await iteration(current: current + 1)
    }

    @MainActor
    func plot(x1: Double, y1: Double, inCircle: Bool) async {
        guard let sWidth = screenWidth, let sHeight = screenHeight else { return }
        let screenX = Double(sWidth) * x1
        let screenY = Double(sHeight) - Double(sHeight) * y1
        
        let point = UIView(frame: CGRect(x: screenX, y: screenY, width: 1, height: 1))
        point.backgroundColor = inCircle ? UIColor.red : UIColor.blue
        self.Container.addSubview(point)
    }
    
    @IBAction func StartButton(_ sender: UIButton) {
        button.isEnabled = false
           maxIterations = Int(maxIter.text!) ?? 10000
           innen = 0
           Task {
               await iteration(current: 1)
               // Re-enable button when done.
               await MainActor.run {
                   self.button.isEnabled = true
               }
           }
    }
}

