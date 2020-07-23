﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace UnderSea.DAL.Models
{
    public class Game
    {
        public int Id { get; set; }
        public IEnumerable<User> Users { get; set; }
        public List<Attack> Attacks { get; set; }
        public int Round { get; set; }
        public string CoralPictureUrl { get; set; }
        public string PearlPictureUrl { get; set; }

        public Game()
        {
            CoralPictureUrl = "/images/coral.png";
            PearlPictureUrl = "/images/shell.png";
        }

        public void CalculateAttacks()
        {
            foreach (var attack in Attacks)
            {
                double defenderScore = 0;
                double attackerScore = 0;

                double defenderScoreModifier = 0;
                double attackerScoreModifier = 0;

                var defUserCountry = attack.DefenderUser.Country;
                var attUserCountry = attack.AttackerUser.Country;

                //calculationg defender base score
                foreach (var unit in defUserCountry.DefendingArmy.Units)
                {
                    defenderScore += unit.Type.DefenseScore * unit.Count;
                }

                //calculating defender modifier
                foreach (var upgrade in defUserCountry.Upgrades)
                {
                    if (upgrade.State == Upgrades.UpgradeState.Researched)
                        defenderScoreModifier += upgrade.Type.DefenseBonusPercentage;
                }
                defenderScore *= 1 + defenderScoreModifier / 100;

                //calculating attacker base score
                foreach (var unit in attack.UnitList)
                {
                    attackerScore += unit.Type.AttackScore * unit.Count;
                }

                //calculating attacker modifier
                foreach (var upgrade in attUserCountry.Upgrades)
                {
                    if (upgrade.State == Upgrades.UpgradeState.Researched)
                        attackerScoreModifier += upgrade.Type.AttackBonusPercentage;
                }
                attackerScore *= 1 + attackerScoreModifier / 100;

                //calculating random for attacker                
                attackerScore *= 1 + (new Random().NextDouble() * 10 - 5) / 100;

                //if the defender wins
                if (defenderScore > attackerScore)
                {
                    //levonjuk az egységeket az attacking armyból
                    foreach (var unit in attack.UnitList)
                    {
                        foreach (var attackingUnit in attUserCountry.AttackingArmy.Units)
                        {
                            if (unit.Type.Id == attackingUnit.Type.Id)
                                attackingUnit.Count -= unit.Count;
                        }
                    }

                    //hozzáadjuk a defender armyhoz 10%osan csökkentve
                    foreach (var unit in attack.UnitList)
                    {
                        foreach (var defendingUnit in attUserCountry.DefendingArmy.Units)
                        {
                            if (unit.Type.Id == defendingUnit.Type.Id)
                                defendingUnit.Count += Convert.ToInt32(Math.Floor(unit.Count * 0.9));
                        }
                    }
                }
                //if the attacker wins
                else if (attackerScore > defenderScore)
                {
                    //levonjuk az egységeket az attacking armyból
                    foreach (var unit in attack.UnitList)
                    {
                        foreach (var attackingUnit in attUserCountry.AttackingArmy.Units)
                        {
                            if (unit.Type.Id == attackingUnit.Type.Id)
                                attackingUnit.Count -= unit.Count;
                        }
                    }

                    //hozzáadjuk a defender armyhoz
                    foreach (var unit in attack.UnitList)
                    {
                        foreach (var defendingunit in attUserCountry.DefendingArmy.Units)
                        {
                            if (unit.Type.Id == defendingunit.Type.Id)
                                defendingunit.Count += unit.Count;
                        }
                    }

                    //csökkentjük a deffender armyját 10%al
                    foreach (var defendingUnit in defUserCountry.DefendingArmy.Units)
                    {
                        defendingUnit.Count = Convert.ToInt32(Math.Floor(defendingUnit.Count * 0.9));
                    }

                    //nyereség jóváírása
                    attUserCountry.Pearl += Convert.ToInt32(Math.Ceiling(defUserCountry.Pearl * 0.5));
                    defUserCountry.Pearl -= Convert.ToInt32(Math.Ceiling(defUserCountry.Pearl * 0.5));

                    attUserCountry.Coral += Convert.ToInt32(Math.Ceiling(defUserCountry.Coral * 0.5));
                    defUserCountry.Coral -= Convert.ToInt32(Math.Ceiling(defUserCountry.Coral * 0.5));
                }
            }

            //Attacks.Clear();
            //Attacks = new List<Attack>();
        }
    }
}