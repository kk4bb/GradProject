using CampusConnect.Application.Interfaces;
using Microsoft.AspNetCore.Http;
using System;
using System.IO;
using System.Threading.Tasks;

namespace CampusConnect.Infrastructure.Services
{
    public class LocalFileStorageService : IFileStorageService
    {
        private readonly string _uploadFolder;

        public LocalFileStorageService(Microsoft.AspNetCore.Hosting.IWebHostEnvironment env)
        {
            _uploadFolder = Path.Combine(env.WebRootPath, "uploads");
        }

        public async Task<string> SaveFileAsync(IFormFile file)
        {
            if (!Directory.Exists(_uploadFolder)) Directory.CreateDirectory(_uploadFolder);

            var fileName = $"{Guid.NewGuid()}{Path.GetExtension(file.FileName)}";
            var filePath = Path.Combine(_uploadFolder, fileName);

            using var stream = new FileStream(filePath, FileMode.Create);
            await file.CopyToAsync(stream);

            return $"/uploads/{fileName}";
        }
    }
}
