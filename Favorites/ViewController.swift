//
//  ViewController.swift
//  Favorites
//
//  Created by Kalybay Nurdaulet  on 14.10.2026.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var imageFood: UIImageView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var receptLabel: UILabel!
    @IBOutlet weak var innerView: UIView!

    private var currentIndex: Int?
    private let backgroundImage = UIImageView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGlass()
        show(favorites[0])
        
        guard let startIndex = favorites.indices.randomElement() else { return}
        
        currentIndex = startIndex
        
        mainView.layer.cornerRadius = 14
        innerView.layer.cornerRadius = 14
        
    }

    @IBAction func spinButton(_ sender: UIButton) {
        let other = favorites.indices.filter {
            $0 != currentIndex
        }
        
        guard let newIndex = other.randomElement() else {
            return
        }
        currentIndex = newIndex
        show(favorites[newIndex])
        
        let food = favorites[newIndex]
        
        UIView.transition(with:mainLabel, duration: 0.5, options: .transitionCrossDissolve){
            self.mainLabel.text = food.title
        }
        
        UIView.transition(with: backgroundImage, duration: 0.5, options: .transitionCrossDissolve){
            self.backgroundImage.image = UIImage(named: food.imageName)
        }
        
        UIView.transition(with: innerView, duration: 0.5 , options: .transitionFlipFromLeft){
            self.imageFood.image = UIImage(named: food.imageName)
            self.receptLabel.text = food.recept
        }
        
        
        
    }
    
    
    
    
    
    func show(_ food: Favorite){
        mainLabel.text = food.title
        receptLabel.text = food.recept
        imageFood.image = UIImage(named: food.imageName)
        backgroundImage.image = UIImage(named: food.imageName)
    }
    
    
    
    
    private func setupGlass(){
        backgroundImage.frame = view.bounds
        backgroundImage.autoresizingMask = [.flexibleHeight,.flexibleHeight]
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.clipsToBounds = true
        
        view.insertSubview(backgroundImage, at: 0)
        
        let effect: UIVisualEffect
        
        if #available(iOS 26.0, *){
            effect = UIGlassEffect()
        } else {
            effect = UIBlurEffect(style: .systemMaterialLight)
        }
        
        let glassView = UIVisualEffectView(effect: effect)
        
        glassView.frame = mainView.bounds
        glassView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        glassView.layer.cornerRadius = 24
        glassView.clipsToBounds = true
        
        mainView.backgroundColor = .clear
        mainView.insertSubview(glassView, at: 0)
        
    }
    
    
}
