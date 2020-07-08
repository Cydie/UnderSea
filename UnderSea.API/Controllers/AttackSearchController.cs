﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using UnderSea.API.ViewModels;

namespace UnderSea.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AttackSearchController : ControllerBase
    {
        [HttpPost]
        public ActionResult<string> Search([FromQuery]string searchPhrase)
        {
            return NotFound("post error");
        }

        [HttpGet]
        public ActionResult<List<PlayerViewModel>> Get()
        {
            return Ok(new List<PlayerViewModel>());
        }
    }
}
