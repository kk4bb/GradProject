using CampusConnect.Application.Dtos.AI;
using CampusConnect.Application.Interfaces;
using CampusConnect.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

namespace CampusConnect.Infrastructure.Services
{
    public class AIService : IAIService
    {
        private readonly ApplicationDbContext _context;
        private readonly IConfiguration _configuration;
        private readonly HttpClient _httpClient;

        public AIService(ApplicationDbContext context, IConfiguration configuration, HttpClient httpClient)
        {
            _context = context;
            _configuration = configuration;
            _httpClient = httpClient;
        }

        public async Task<List<ChatSessionDto>> GetUserSessionsAsync(string userId)
        {
            return await _context.ChatSessions
                .Where(s => s.StudentId == userId)
                .OrderByDescending(s => s.UpdatedAt)
                .Select(s => new ChatSessionDto
                {
                    Id        = s.Id,
                    Title     = s.Title,
                    CreatedAt = s.CreatedAt,
                    UpdatedAt = s.UpdatedAt,
                })
                .ToListAsync();
        }

        public async Task<List<ChatMessageDto>> GetSessionMessagesAsync(int sessionId, string userId)
        {
            var session = await _context.ChatSessions.FindAsync(sessionId);
            if (session == null || session.StudentId != userId)
                throw new UnauthorizedAccessException("Session not found or access denied.");

            return await _context.ChatMessages
                .Where(m => m.SessionId == sessionId)
                .OrderBy(m => m.CreatedAt)
                .Select(m => new ChatMessageDto
                {
                    Id        = m.Id,
                    Sender    = m.Sender,
                    Content   = m.Content,
                    CreatedAt = m.CreatedAt,
                })
                .ToListAsync();
        }

        public async Task<string> SendMessageAsync(string userId, SendMessageRequest request)
        {
            // 1. Resolve or create a session
            ChatSession session;
            if (request.SessionId == null || request.SessionId == 0)
            {
                var title = request.Content.Length > 30
                    ? request.Content[..30] + "..."
                    : request.Content;

                session = new ChatSession
                {
                    StudentId = userId,
                    Title     = title,
                    CreatedAt = DateTime.UtcNow,
                    UpdatedAt = DateTime.UtcNow,
                };
                _context.ChatSessions.Add(session);
                await _context.SaveChangesAsync();
            }
            else
            {
                session = await _context.ChatSessions.FindAsync(request.SessionId);
                if (session == null || session.StudentId != userId)
                    throw new UnauthorizedAccessException("Session not found or access denied.");
            }

            // 2. Save the user's message
            var userMessage = new ChatMessage
            {
                SessionId = session.Id,
                Sender    = "User",
                Content   = request.Content,
                CreatedAt = DateTime.UtcNow,
            };
            _context.ChatMessages.Add(userMessage);
            await _context.SaveChangesAsync();

            // 3. Fetch full conversation history for context
            var history = await _context.ChatMessages
                .Where(m => m.SessionId == session.Id)
                .OrderBy(m => m.CreatedAt)
                .ToListAsync();

            var contents = history.Select(m => {
                var partsList = new List<object> { new { text = m.Content } };
                
                // Attach the image only to the newly sent user message
                if (m.Id == userMessage.Id && !string.IsNullOrEmpty(request.Base64Image))
                {
                    partsList.Add(new { inline_data = new { mime_type = "image/jpeg", data = request.Base64Image } });
                }

                return new
                {
                    role  = m.Sender == "User" ? "user" : "model",
                    parts = partsList.ToArray()
                };
            }).ToList();

            var payload = new
            {
                system_instruction = new
                {
                    parts = new[]
                    {
                        new { text = "You are the official CampusConnect AI Teaching Assistant for BNU (Badr University). Help students understand concepts clearly. Do not give direct answers to assignments; guide them instead. Speak in the user's language." }
                    }
                },
                contents
            };

            // 5. Call Gemini API
var apiKey = _configuration["GeminiApiKey"];
// الرابط ده هو المسار الصحيح والمستقر حالياً لموديلات Gemini Flash
var url = $"https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key={apiKey}";
var json = JsonSerializer.Serialize(payload);
var content = new StringContent(json, Encoding.UTF8, "application/json");
var response = await _httpClient.PostAsync(url, content);
var responseBody = await response.Content.ReadAsStringAsync();

// السطر السحري اللي هيطبع رسالة جوجل الحقيقية في التيرمينال
if (!response.IsSuccessStatusCode)
{
    Console.WriteLine("\n========== GEMINI ERROR ==========");
    Console.WriteLine(responseBody);
    Console.WriteLine("==================================\n");
}

// 6. Parse Gemini response
string aiText;
try
{
    using var doc = JsonDocument.Parse(responseBody);
    aiText = doc.RootElement
        .GetProperty("candidates")[0]
        .GetProperty("content")
        .GetProperty("parts")[0]
        .GetProperty("text")
        .GetString() ?? "I'm sorry, I couldn't generate a response.";
}
catch
{
    aiText = "I'm sorry, something went wrong while processing your request.";
}

            // 7. Save the AI's response
            var aiMessage = new ChatMessage
            {
                SessionId = session.Id,
                Sender    = "AI",
                Content   = aiText,
                CreatedAt = DateTime.UtcNow,
            };
            _context.ChatMessages.Add(aiMessage);

            // 8. Update session timestamp
            session.UpdatedAt = DateTime.UtcNow;
            await _context.SaveChangesAsync();

            return aiText;
        }

        public async Task DeleteSessionAsync(int sessionId, string userId)
        {
            var session = await _context.ChatSessions
                .Include(s => s.Messages)
                .FirstOrDefaultAsync(s => s.Id == sessionId);

            if (session == null || session.StudentId != userId)
                throw new UnauthorizedAccessException("Session not found or access denied.");

            _context.ChatMessages.RemoveRange(session.Messages);
            _context.ChatSessions.Remove(session);
            await _context.SaveChangesAsync();
        }
    }
}
