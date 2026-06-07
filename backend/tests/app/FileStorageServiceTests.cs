using CampusConnect.Infrastructure.Helpers;
using CampusConnect.Infrastructure.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Hosting;
using Moq;
using System.IO;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace CampusConnect.Tests.App
{
    public class FileStorageServiceTests
    {
        [Fact]
        public void FileUploadHelper_ValidPdf_ReturnsTrue()
        {
            var content = "%PDF-1.4...";
            var stream = new MemoryStream(Encoding.UTF8.GetBytes(content));
            var file = new Mock<IFormFile>();
            file.Setup(f => f.FileName).Returns("test.pdf");
            file.Setup(f => f.Length).Returns(content.Length);
            file.Setup(f => f.OpenReadStream()).Returns(stream);

            var isValid = FileUploadHelper.IsValidFile(file.Object, out var errorMessage);
            Assert.True(isValid, errorMessage);
        }

        [Fact]
        public void FileUploadHelper_InvalidSignature_ReturnsFalse()
        {
            // Renamed .exe to .jpg to test magic number validation
            var content = "MZ\x90\x00..."; 
            var stream = new MemoryStream(Encoding.UTF8.GetBytes(content));
            var file = new Mock<IFormFile>();
            file.Setup(f => f.FileName).Returns("malicious.jpg");
            file.Setup(f => f.Length).Returns(content.Length);
            file.Setup(f => f.OpenReadStream()).Returns(stream);

            var isValid = FileUploadHelper.IsValidFile(file.Object, out var errorMessage);
            Assert.False(isValid);
            Assert.Equal("Invalid file signature (magic number mismatch).", errorMessage);
        }

        [Fact]
        public void FileUploadHelper_UnsupportedExtension_ReturnsFalse()
        {
            var file = new Mock<IFormFile>();
            file.Setup(f => f.FileName).Returns("script.sh");
            file.Setup(f => f.Length).Returns(100);

            var isValid = FileUploadHelper.IsValidFile(file.Object, out var errorMessage);
            Assert.False(isValid);
            Assert.Equal("Unsupported file type.", errorMessage);
        }
    }
}
