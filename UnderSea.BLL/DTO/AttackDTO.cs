﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace UnderSea.BLL.DTO
{
    public class AttackDTO
    {
        public int DefenderUserId { get; set; }
        public List<SendUnitDTO> AttackingUnits { get; set; }
    }
}
