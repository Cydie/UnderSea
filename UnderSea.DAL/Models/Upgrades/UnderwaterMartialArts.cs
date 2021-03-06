﻿using System;
using System.Collections.Generic;
using System.Text;

namespace UnderSea.DAL.Models.Upgrades
{
    public class UnderwaterMartialArts : UpgradeType
    {
        public UnderwaterMartialArts()
        {
            Name = "Vízalatti harcművészetek";
            Description = "növeli a védelmi és támadóerőt 10%-kal";
            ImageUrl = "/images/upgrades/underwatermartialarts.png";
            AttackBonusPercentage = 10;
            DefenseBonusPercentage = 10;
        }
    }
}
