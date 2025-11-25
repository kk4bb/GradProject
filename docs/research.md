# LMS
## Summary
The fresh new idea, make a Learning Management System for university because the one we have is not it to say the least. This project aims to make an LMS as mobile application first using flutter for the mobile application (and maybe a website too?) with .net in the backend to deliver a highly performant and secure product to all students that actually helps you instead of feeling like an obscure piece of software that needs it's own manual.

## Problems with the current implementation
- The website has no real use case or application other than just filling paperwork for leaving much to be desired
- Lack of critical features such as storing subject material storage and assignment grading, etc...
- TLDR; if I go into a a specific section of the website I expect to press back to get back to the home page. The main buttons seem to be javascript functions if we understand correctly which make the back button ineffective which is counter-intuitive and results in an awful user experience.
- Relying on external components for functionality that's either too common to be not included (the subject registration) or too sensitive to be redirecting users to it (uploading student pictures)
- The design of the whole website is outdated and doesn't meet modern standards to say the least, here are some examples:
    - Lack of sorting/grouping options in many useful places
    - There doesn't need to be a specific box for something like uploading your picture, that should be under student data (just one quick example)
    - Adding an icon in the bottom left to change colors but having another icon for accessibilty setting when all this can be better grouped
    - The site needs to be reloaded every time you make a change such as paying tutition or registering subjects which shouldn't be a thing
    - Localization, there is no excuse to directly translating ethical hacking to and I quote "القرصنة الاخلاقية"


## Features overview

### Intuitive Dashboard / Learning Hub

- The Landing page for students that gives them all the important info at a glance
- Allows students to save multiple sessions so that they can jump right back in exactly where they left off
- Provides customizable shortucts to frequently used tools and features
- Houses all the important notifications with differnt colors and labels so as to better direct your attention to what's important

### Fully Customizable AI companion

- The AI companion can access (with the user's consent of course) each student's courses, grades, schedule, and deadlines to provide them with personalized assistance.
- Available 24/7 with different locales and dialects.
- Professors can instruct the AI companion to use specific refrences or use certain methods when explaining concepts first.
- Students also can control how the AI responds to them just like with any other AI.

### Course Management

- Instructors can create new courses, add descriptions, prerequisites, objectives, etc...
- Upload different course material such as pdfs or multimedia resources and orgainze it into modules or weekly sections for easier navigation.
- Online quizzes, assignments, and exams with automated grading for objective questions and manual grading for essays/projects.

### Alerts and Attendance System

- Allows students to take their attendance by scanning time-limited qr codes for each section / lecture that the staff can freely customize, getting rid of the old and inefficient methods
- The system alerts students through push notifications about what's next in their schedule and also makes it easier for the university's adminstration to make announcements
- Presents insightful statistics that are easy to export such as present count and who arrived late and all can be easily exported to formats like csv that are easily integratable into most workflows

### One Calendar To Rule Them All

- All classes, exams, deadlines, and office hours appear in a single calendar view that updates in real-time in case the university changes anything.
- Sync with the device calendar directly or even with online ones such as google calendar and so on without the need for immediate internet connection, just tap sync and it will automatically once you're connected
- Users can add personal study tasks (e.g., 'Review Chapter 3') and customize them with different colors for each subject, with tags like Exam, Lecture, Assignment, and Personal for quick recognition.
- Share your calendar with classmates or create Study Group Calendars for projects and revision sessions.

### Smart Notes

- Converts helpful chat conversations into organized study notes, auto-formatted with headings and key concepts
- Students can save, export, and share these notes in various formats with support to markdown for easy and quick editing

### Help Forums

- Allow the users to open different threads on different problems they face when studying
- Each student will have a badge signifying their contribution to the forums
- Professors and TAs will have their own badges to signify their position, it'll be like an admin helping with a problem

### Assignment Submission

- Allows studens to subit their assignments through the app in whatever form specified by the TA or the professor
- Customizing the assignment by changing the title, description, instructions, due date & time, file type restrictions (e.g., PDF, DOCX, ZIP), and maximum file size.
- A timestamp is stored for deadline validation, and late submissions are flagged automatically with  the ability to allow or prevent them
- Instructors can provide feedback directly through the LMS which can include grades, comments, and attached review files.

### In-app Messaging

- Students can reach out to professors and TAs with questions and the staff can opt out of such features if it bothers them
- Ability to create groups for things like graduation projects (such an awesome idea I know) so that everybody is updated

### Academic progress tracker

- Students can see grades immediately after instructors post them with the system automatically calculateing both current GPA and projected GPA
- Check how well you're doing by viewing class averages and their own ranking compared to peers (fully anonymized).
- Simulate outcomes, such as *“What grade do I need on the final exam to get an A?”* with early alerts if GPA is dropping below a set threshold.

### Student Services Center

- A centralized student profile which integrates personal, academic, and administrative records into a single digital identity
- Students can register courses digitally, with automated prerequisite checking and timetable validation
- Integrates online payment gateways for students to view outstanding fees, pay electronically, and generate receipts
- A ticketing system for students to submit administrative requests (e.g., updating data) and track their progress until resolution, increasing transparency and accountability.



## Tech Stack
**Flutter** for the mobile application

**.Net** for the backend

**SQL** for the database

**OpenAI GPT-40-mini** for the AI model


## The team
Kirollos Adel Bekheet - Mohamed Ashraf - Mohamed Ehsan - Ahmed Amin - Mazen Essam - Mazen Tamer - Abdelrahman Mostafa - Ahmed Fayez - Seif Esssam

> Last but not least, this is all a work in progress but we think it's good and we hope you think so too.

