# 📘 Assignments Feature Restoration Report

This document tracks the re-implementation of the Assignments feature for the BNU LMS app, ensuring it matches the premium design reference and strictly follows Clean Architecture.

## 🎯 Main Goal
Re-incorporate the Assignments feature with a "World Class" UI/UX, fixing previous integration issues and aligning with the official BNU Design System.

## 🎨 Design Rules & Guidelines
- **Visual Language:** Sleek, premium academic mobile-first layout.
- **Typography:** Poppins (via Google Fonts).
- **Colors:** Vibrant primary colors, sleek dark modes, HSL tailored palettes.
- **Components:** 16px rounded corners, glassmorphism, smooth gradients, and micro-animations.
- **Rules:**
    - Use `ScreenUtil` for all dimensions (w, h, sp, r).
    - No Floating Action Buttons (FAB).
    - strictly use `ColorsManager` for consistency.

## 🏗️ Technical Architecture
- **Layering:** Clean Architecture (Data, Domain, Presentation).
- **State Management:** Bloc/Cubit.
- **Dependency Injection:** GetIt + Injectable.
- **Networking:** Dio + ApiConstants.

## 📂 Naming Convention (Required Components)
| Role | Component Name | Description |
| :--- | :--- | :--- |
| **Student** | `StudentAssignmentsTab` | List of Upcoming, Submitted, Graded. |
| **Student** | `SubmitAssignmentScreen` | File upload and Drag & Drop UI. |
| **Student** | `AssignmentResultScreen` | Grade, Feedback, and Originality score. |
| **Instructor** | `InstructorAssignmentsTab` | Management of created assignments. |
| **Instructor** | `CreateAssignmentBottomSheet` | Form for new assignments. |
| **Instructor** | `SubmissionsListScreen` | List of student submissions. |
| **Instructor** | `GradingBottomSheet` | Grading and feedback action sheet. |
| **Shared** | `AssignmentCard` | Standardized card for assignments. |
| **Shared** | `AssignmentStatisticsCard`| Mastery progress and completion rates. |

## ✅ Progress Tracking
- [x] Create Folder Structure (`lib/features/assignments/`)
- [x] Implement Domain Entities (`AssignmentEntity`, `SubmissionEntity`)
- [/] Implement Data Layer (Models, Data Sources, Repositories)
- [ ] Implement Presentation Layer (Cubit, States)
- [ ] Implement UI Screens (Matching Screenshots)
- [ ] Backend Integration & Verification

---
*Created by Antigravity AI Coding Assistant*
