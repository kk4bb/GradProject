using Microsoft.AspNetCore.Http;
using System.Threading.Tasks;

namespace CampusConnect.Application.Interfaces
{
    public interface IFileStorageService
    {
        Task<string> SaveFileAsync(IFormFile file);
    }
}
