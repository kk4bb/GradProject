using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace CampusConnect.Infrastructure.Helpers
{
    public static class FileUploadHelper
    {
        private static readonly Dictionary<string, byte[]> _fileSignatures = new()
        {
            { ".pdf", new byte[] { 0x25, 0x50, 0x44, 0x46 } }, // %PDF
            { ".jpg", new byte[] { 0xFF, 0xD8, 0xFF } },
            { ".jpeg", new byte[] { 0xFF, 0xD8, 0xFF } },
            { ".png", new byte[] { 0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A } },
            { ".mp4", new byte[] { 0x00, 0x00, 0x00, 0x18, 0x66, 0x74, 0x79, 0x70 } } // Often starts with ftyp
        };

        private static readonly List<string> _allowedExtensions = new() { ".pdf", ".jpg", ".jpeg", ".png", ".mp4" };
        private const long MaxFileSize = 100 * 1024 * 1024; // 100MB

        public static bool IsValidFile(IFormFile file, out string errorMessage)
        {
            errorMessage = string.Empty;

            if (file.Length == 0) { errorMessage = "File is empty."; return false; }
            if (file.Length > MaxFileSize) { errorMessage = "File exceeds 100MB limit."; return false; }

            var ext = Path.GetExtension(file.FileName).ToLowerInvariant();
            if (!_allowedExtensions.Contains(ext)) { errorMessage = "Unsupported file type."; return false; }

            // Magic Number Check
            using var reader = new BinaryReader(file.OpenReadStream());
            var signature = reader.ReadBytes(_fileSignatures[ext].Length);
            if (!_fileSignatures[ext].SequenceEqual(signature)) 
            { 
                errorMessage = "Invalid file signature (magic number mismatch)."; 
                return false; 
            }

            return true;
        }
    }
}
