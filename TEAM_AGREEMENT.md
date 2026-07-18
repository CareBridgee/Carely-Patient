# 📜 Team Agreement

This document defines how our team works together on this project: branching strategy, architecture, code review, commit conventions, resource management, coding standards, and CI/CD.

## Table of Contents

- [🌿 Git Workflow](#-git-workflow)
- [🏛️ Architecture](#️-architecture)
- [👀 Code Review](#-code-review)
- [💬 Commit Convention](#-commit-convention)
- [🎨 Resources Management](#-resources-management)
- [🧹 Development Standards](#-development-standards)
- [🚀 CI/CD](#-cicd)
- [📝 Pull Requests](#-pull-requests)

---

## 🌿 Git Workflow

- Follow **GitFlow** as the branching strategy.
- Keep the `main` branch protected.
- Create a `feature/*` branch for each feature.
- Create `task/*` branches from their corresponding feature branch.
- Developers should work only on `task/*` branches.
- Every `task/*` branch must be merged into its corresponding `feature/*` branch through a Pull Request.
- Once all tasks are completed and approved, merge the `feature/*` branch into `main` through a Pull Request.

---

## 🏛️ Architecture

- Follow the **VIP (View – Interactor – Presenter)** architecture.
- Keep responsibilities separated between layers.
- Build the project using a modular and scalable structure.

---

## 👀 Code Review

- Every Pull Request must be reviewed before merging.
- Reviewers can either:
  - ✅ Approve
  - 🔄 Request Changes
- All requested changes must be addressed before approval.

---

## 💬 Commit Convention

Follow the **Conventional Commits** format.

```
<type>(<scope>): <description>
```

**Examples**

```
feat(login): implement Google Sign-In
feat(home): add featured products section
fix(cart): resolve quantity update issue
refactor(profile): simplify address mapping
docs(readme): update setup instructions
style(auth): format login presenter
test(payment): add checkout unit tests
chore(ci): update GitHub Actions workflow
```

**Commit Types**

| Type | Description |
|------|-------------|
| `feat` | New feature |
| `fix` | Bug fix |
| `refactor` | Code improvement without changing behavior |
| `style` | Formatting and styling |
| `docs` | Documentation |
| `test` | Tests |
| `chore` | CI/CD, dependencies, tooling, maintenance |

---

## 🎨 Resources Management

- Store all colors and images inside the **Assets** catalog.
- Do not reference asset names directly using string literals.
- Access assets only through centralized Swift extensions.
- Keep all resource extensions in a dedicated location.

**Examples**

```swift
Color.appPrimary
Color.appBackground
Color.appAccent

Image.appLogo
Image.emptyState
Image.profilePlaceholder
```

---

## 🧹 Development Standards

- Use **SwiftLint** and follow the agreed coding style.
- Follow the project's naming conventions.
- Write clean, readable, and maintainable code.
- Avoid unnecessary force unwrapping whenever possible.

---

## 🚀 CI/CD

- Use GitHub Actions for Continuous Integration.
- Every Pull Request must pass all CI checks before merging.
- Do not merge code if the build or tests fail.

---

## 📝 Pull Requests

- Use the team's standardized [Pull Request template](.github/PULL_REQUEST_TEMPLATE.md).
- Include a clear summary of the implemented changes.
- Add screenshots or screen recordings for UI changes.
- Reference the related task or issue.
- Complete the checklist before requesting a review.

> GitHub automatically loads `.github/PULL_REQUEST_TEMPLATE.md` into the description box whenever a new PR is opened, so contributors don't need to copy it manually.
