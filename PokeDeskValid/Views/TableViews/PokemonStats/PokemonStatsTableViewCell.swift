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

    
    override func awakeFromNib() {
        super.awakeFromNib()
        firtsProgressBar.cornerRadius = 4
        let colorFirst = #colorLiteral(red: 0.4120000005, green: 0.7250000238, blue: 0.8899999857, alpha: 1).cgColor
        let colorEnd = #colorLiteral(red: 0.3330000043, green: 0.6200000048, blue: 0.875, alpha: 1).cgColor
        firtsProgressBar.gradientColors = [colorFirst, colorEnd]
        
        secondProgressBar.cornerRadius = 4
        secondProgressBar.gradientColors = [colorFirst, colorEnd]
        
        thirdProgressBar.cornerRadius = 4
        thirdProgressBar.gradientColors = [colorFirst, colorEnd]
        
        fourthProgressBar.cornerRadius = 4
        fourthProgressBar.gradientColors = [colorFirst, colorEnd]
        
        fivethProgressBar.cornerRadius = 4
        fivethProgressBar.gradientColors = [colorFirst, colorEnd]
        
        sixthProgressBar.cornerRadius = 4
        sixthProgressBar.gradientColors = [colorFirst, colorEnd]
    
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
