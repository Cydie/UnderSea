﻿using Microsoft.AspNetCore.Identity;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;

namespace UnderSea.DAL.Models
{
    public class User : IdentityUser<int>
    {
        public virtual Country Country { get; set; }
        public int Place { get; set; }
        public int Score { get; set; }
        [ForeignKey("Game")]
        public int GameId { get; set; }
        public string RefreshToken { get; set; }
    }
}
