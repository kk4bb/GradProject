# Backend Implementation Plan: Material Deletion API

## Objective
Implement a secure API endpoint to allow Instructors and TAs to delete uploaded educational materials from courses.

## Technical Requirements

### 1. Service Interface (`ICourseService.cs`)
Add the following method definition:
```csharp
Task DeleteContentAsync(int contentId, string userId, bool isTA = false);
```

### 2. Service Implementation (`CourseService.cs`)
Implement the method `DeleteContentAsync`:
- **Step 1:** Retrieve the content record using Entity Framework, including the lesson, module, and course entities to perform authorization.
- **Step 2:** Validate authorization:
  - Throw `UnauthorizedAccessException` if the user is not the instructor of the course and not a TA.
- **Step 3:** Use `IFileStorageService` to delete the physical file associated with the `fileUrl`.
- **Step 4:** Remove the `EducationalContent` entity from the `ApplicationDbContext`.
- **Step 5:** Save changes to the database.

### 3. Controller (`CourseController.cs`)
Add the following endpoint:
```csharp
[HttpDelete("content/{id}")]
[Authorize(Roles = "Instructor,TA")]
public async Task<IActionResult> DeleteContent(int id)
{
    try
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        var isTA = User.IsInRole("TA") || User.IsInRole("TeachingAssistant");
        
        await _courseService.DeleteContentAsync(id, userId, isTA);
        return NoContent();
    }
    catch (UnauthorizedAccessException ex) { return Forbid(ex.Message); }
    catch (Exception ex) { return BadRequest(ex.Message); }
}
```

## Security & Reliability Checklist
- [ ] Ensure Authorization (Roles: Instructor, TA).
- [ ] Validate course ownership/TA assignment before deletion.
- [ ] Ensure physical file deletion is successful before database record removal (or handle cleanup).
- [ ] Handle potential errors (file not found, database errors) gracefully and return appropriate status codes (404, 400).
