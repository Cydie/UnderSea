﻿using System.Threading.Tasks;
using UnderSea.BLL.DTO;
using UnderSea.DAL.Models;

namespace UnderSea.BLL.Services
{
    public interface IUserService
    {
        Task<User> CreateUserAsync(RegisterDTO registerData);
    }
}