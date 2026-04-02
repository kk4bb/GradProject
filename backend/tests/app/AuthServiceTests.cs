using CampusConnect.Application.Dtos.Auth;
using CampusConnect.Infrastructure.Context;
using CampusConnect.Infrastructure.Services;
using FluentAssertions;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Configuration;
using Moq;
using Xunit;
using System.Collections.Generic;
using System.Threading.Tasks;
using System;

namespace app.tests
{
    public class AuthServiceTests
    {
        private readonly Mock<UserManager<ApplicationUser>> _userManagerMock;
        private readonly Mock<RoleManager<IdentityRole>> _roleManagerMock;
        private readonly Mock<IConfiguration> _configurationMock;
        private readonly AuthService _authService;

        public AuthServiceTests()
        {
            var userStoreMock = new Mock<IUserStore<ApplicationUser>>();
            _userManagerMock = new Mock<UserManager<ApplicationUser>>(
                userStoreMock.Object, null, null, null, null, null, null, null, null);

            var roleStoreMock = new Mock<IRoleStore<IdentityRole>>();
            _roleManagerMock = new Mock<RoleManager<IdentityRole>>(
                roleStoreMock.Object, null, null, null, null);

            _configurationMock = new Mock<IConfiguration>();

            // Setup JWT configuration
            _configurationMock.Setup(c => c.GetSection("JwtSettings")["Key"]).Returns("SuperSecretKey12345678901234567890123456789012");
            _configurationMock.Setup(c => c.GetSection("JwtSettings")["Issuer"]).Returns("CampusConnect");
            _configurationMock.Setup(c => c.GetSection("JwtSettings")["Audience"]).Returns("CampusConnectUsers");
            _configurationMock.Setup(c => c.GetSection("JwtSettings")["DurationInMinutes"]).Returns("60");

            _authService = new AuthService(
                _userManagerMock.Object,
                _roleManagerMock.Object,
                _configurationMock.Object);
        }

        [Fact]
        public async Task RegisterAsync_ShouldReturnToken_WhenUserIsSuccessfullyCreated()
        {
            // Arrange
            var registerDto = new RegisterDto
            {
                Email = "test@example.com",
                FirstName = "Test",
                LastName = "User",
                Faculty = "Science",
                Password = "Password123!",
                Role = "Student"
            };

            _userManagerMock.Setup(x => x.FindByEmailAsync(registerDto.Email))
                .ReturnsAsync((ApplicationUser)null);

            _userManagerMock.Setup(x => x.CreateAsync(It.IsAny<ApplicationUser>(), registerDto.Password))
                .ReturnsAsync(IdentityResult.Success);

            _roleManagerMock.Setup(x => x.RoleExistsAsync(registerDto.Role))
                .ReturnsAsync(true);

            _userManagerMock.Setup(x => x.AddToRoleAsync(It.IsAny<ApplicationUser>(), registerDto.Role))
                .ReturnsAsync(IdentityResult.Success);

            _userManagerMock.Setup(x => x.GetRolesAsync(It.IsAny<ApplicationUser>()))
                .ReturnsAsync(new List<string> { "Student" });

            // Act
            var result = await _authService.RegisterAsync(registerDto);

            // Assert
            result.Should().NotBeNull();
            result.Email.Should().Be(registerDto.Email);
            result.Token.Should().NotBeNullOrEmpty();
        }

        [Fact]
        public async Task RegisterAsync_ShouldThrowException_WhenFirstNameHasSpecialCharacters()
        {
            // Arrange
            var registerDto = new RegisterDto 
            { 
                Email = "test@example.com", 
                FirstName = "Test123", 
                LastName = "User" 
            };

            // Act & Assert
            var ex = await Assert.ThrowsAsync<Exception>(() => _authService.RegisterAsync(registerDto));
            ex.Message.Should().Be("First name can only contain letters.");
        }

        [Fact]
        public async Task RegisterAsync_ShouldThrowException_WhenEmailAlreadyExists()
        {
            // Arrange
            var registerDto = new RegisterDto 
            { 
                Email = "existing@example.com",
                FirstName = "Test",
                LastName = "User"
            };
            _userManagerMock.Setup(x => x.FindByEmailAsync(registerDto.Email))
                .ReturnsAsync(new ApplicationUser { Email = registerDto.Email });

            // Act & Assert
            await Assert.ThrowsAsync<Exception>(() => _authService.RegisterAsync(registerDto));
        }

        [Fact]
        public async Task LoginAsync_ShouldReturnToken_WhenCredentialsAreValid()
        {
            // Arrange
            var loginDto = new LoginDto
            {
                Email = "test@example.com",
                Password = "Password123!"
            };

            var user = new ApplicationUser 
            { 
                Email = loginDto.Email, 
                Id = "user-id",
                FirstName = "Test",
                LastName = "User"
            };

            _userManagerMock.Setup(x => x.FindByEmailAsync(loginDto.Email))
                .ReturnsAsync(user);

            _userManagerMock.Setup(x => x.CheckPasswordAsync(user, loginDto.Password))
                .ReturnsAsync(true);

            _userManagerMock.Setup(x => x.GetRolesAsync(user))
                .ReturnsAsync(new List<string> { "Student" });

            // Act
            var result = await _authService.LoginAsync(loginDto);

            // Assert
            result.Should().NotBeNull();
            result.Email.Should().Be(loginDto.Email);
            result.Token.Should().NotBeNullOrEmpty();
        }
    }
}
