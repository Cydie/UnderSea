﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace UnderSea.API.DTO
{
    public class AttackDTO
    {
        public int CountryId { get; set; }
        public List<AvailableUnitDTO> AttackingUnits { get; set; }
    }
}