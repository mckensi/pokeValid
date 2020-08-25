//
//  PokemonStatsTableViewCell.swift
//  PokeDeskApp
//
//  Created by Daniel Steven Murcia Almanza on 25/08/20.
//  Copyright © 2020 selvamatic. All rights reserved.
//

import UIKit
import GradientProgress

class PokemonStatsTableViewCell: UITableViewCell {

    @IBOutlet weak var firtsProgressBar: GradientProgressBar!
    
    @IBOutlet weak var secondProgressBar: GradientProgressBar!
    
    @IBOutlet weak var thirdProgressBar: GradientProgressBar!
    
    @IBOutlet weak var fourthProgressBar: GradientProgressBar!
    
    @IBOutlet weak var fivethProgressBar: GradientProgressBar!
    
    @IBOutlet weak var sixthProgressBar: GradientProgressBar!
    
    
    @IBOutlet weak var lblHpTitle: UILabel!
    @IBOutlet weak var lblAttackTitle: UILabel!
    @IBOutlet weak var lblDefTitle: UILabel!
    @IBOutlet weak var lblSuperAttackTitle: UILabel!
    @IBOutlet weak var lblSuperDefTitle: UILabel!
    @IBOutlet weak var lblSpeedTitle: UILabel!
    
    
    @IBOutlet weak var lblHpStat: UILabel!
    @IBOutlet weak var lblAtackStack: UILabel!
    @IBOutlet weak var lblDefStack: UILabel!
    @IBOutlet weak var lblSuperAtackStat: UILabel!
    @IBOutlet weak var lblSuperDefStat: UILabel!
    @IBOutlet weak var lblSpeedStat: UILabel!
    
    
    private var firtStat : Int?
    private var secondStat : Int?
    private var thirdStar : Int?
    private var fourthStat : Int?
    private var fivethStat : Int?
    private var sixthStat : Int?
    
    var colors : [CGColor]? {
        didSet{
            guard let colors = self.colors else {return}
            firtsProgressBar?.gradientColors = colors
            secondProgressBar?.gradientColors = colors
            thirdProgressBar?.gradientColors = colors
            fourthProgressBar?.gradientColors = colors
            fivethProgressBar?.gradientColors = colors
            sixthProgressBar?.gradientColors = colors
            
            lblHpTitle.textColor = UIColor(cgColor: colors.first!)
            lblAttackTitle.textColor = UIColor(cgColor: colors.first!)
            lblDefTitle.textColor = UIColor(cgColor: colors.first!)
            lblSuperAttackTitle.textColor = UIColor(cgColor: colors.first!)
            lblSuperDefTitle.textColor = UIColor(cgColor: colors.first!)
            lblSpeedTitle.textColor = UIColor(cgColor: colors.first!)
        }
    }

    var stats : [String:Int]? {
        didSet {
                firtsProgressBar?.progress = Float((Double(stats?["hp"] ?? 0) / 100))
                secondProgressBar?.progress = Float((Double(stats?["attack"] ?? 0) / 100))
                thirdProgressBar?.progress = Float((Double(stats?["defense"] ?? 0) / 100))
                fourthProgressBar?.progress = Float((Double(stats?["special-attack"] ?? 0) / 100))
                fivethProgressBar?.progress = Float((Double(stats?["special-defense"] ?? 0) / 100))
                sixthProgressBar?.progress = Float((Double(stats?["speed"] ?? 0) / 100))
                
                lblHpStat?.text = "\(stats?["hp"] ?? 0)"
                lblAtackStack?.text = "\(stats?["attack"] ?? 0)"
                lblDefStack?.text = "\(stats?["defense"] ?? 0)"
                lblSuperAtackStat?.text = "\(stats?["special-attack"] ?? 0)"
                lblSuperDefStat?.text = "\(stats?["special-defense"] ?? 0)"
                lblSpeedStat?.text = "\(stats?["speed"] ?? 0)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        firtsProgressBar.cornerRadius = 4
        secondProgressBar.cornerRadius = 4
        thirdProgressBar.cornerRadius = 4
        fourthProgressBar.cornerRadius = 4
        fivethProgressBar.cornerRadius = 4
        sixthProgressBar.cornerRadius = 4
    }
    
    func setStats(first: Int, second: Int, third: Int, fourth: Int, fiveth: Int, sixth: Int){
        self.firtStat = first
        self.secondStat = second
        self.thirdStar = third
        self.fourthStat = fourth
        self.fivethStat = fiveth
        self.sixthStat = sixth

    }
}
