﻿using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using UnderSea.BLL.DTO;
using UnderSea.BLL.Services;
using UnderSea.BLL.ViewModels;

namespace UnderSea.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UpgradesController : ControllerBase
    {
        private IUpgradesService upgradesService;
        private readonly ILogger logger;
        public UpgradesController(IUpgradesService upgradesService, ILogger<UpgradesController> logger)
        {
            this.upgradesService = upgradesService;
            this.logger = logger;
        }

        [HttpGet]
        public async Task<IEnumerable<UpgradeViewModel>> Get()
        {
            int userId = 1;
            return await upgradesService.GetUpgradesAsync(userId);
        }

        [HttpPost("research")]
        public async Task<UpgradeViewModel> Research([FromBody] int id)
        {
            int userId = 1;
            return await upgradesService.ResearchByIdAsync(userId, id);
        }
    }
}
