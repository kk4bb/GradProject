using CampusConnect.Application.Dtos.AiChat;
using CampusConnect.Application.Interfaces;
using Microsoft.Extensions.Configuration;
using System.Net.Http;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

namespace CampusConnect.Infrastructure.Services
{
    public class AiChatService : IAiChatService
    {
        private readonly HttpClient _httpClient;
        private readonly IConfiguration _configuration;

        public AiChatService(HttpClient httpClient, IConfiguration configuration)
        {
            _httpClient = httpClient;
            _configuration = configuration;
        }

        public async Task<AiChatResponseDto> GetChatResponseAsync(AiChatRequestDto request)
        {
            var apiKey = _configuration["Gemini:ApiKey"];
            var model = _configuration["Gemini:Model"] ?? "gemini-1.5-flash";
            var url = $"https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent?key={apiKey}";

            var geminiRequest = new
            {
                contents = new[]
                {
                    new
                    {
                        parts = new[]
                        {
                            new { text = request.Message }
                        }
                    }
                }
            };

            var jsonContent = JsonSerializer.Serialize(geminiRequest);
            var content = new StringContent(jsonContent, Encoding.UTF8, "application/json");

            var response = await _httpClient.PostAsync(url, content);
            
            if (!response.IsSuccessStatusCode)
            {
                var error = await response.Content.ReadAsStringAsync();
                throw new System.Exception($"Gemini API error: {response.StatusCode} - {error}");
            }

            var responseJson = await response.Content.ReadAsStringAsync();
            using var doc = JsonDocument.Parse(responseJson);
            
            var aiText = doc.RootElement
                .GetProperty("candidates")[0]
                .GetProperty("content")
                .GetProperty("parts")[0]
                .GetProperty("text")
                .GetString();

            return new AiChatResponseDto { Response = aiText };
        }
    }
}
