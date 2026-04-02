# Commit Convention Guide 📝

## Format
```
<emoji> <type>(<scope>): <subject>

[optional body]

[optional footer]
```

## Emoji & Type Reference

### Core Changes
- ✨ `feat`: New feature
- 🐛 `fix`: Bug fix
- 🔥 `remove`: Remove code/files
- ♻️ `refactor`: Code refactoring
- 🎨 `style`: Code formatting, style changes

### Documentation & Tests
- 📝 `docs`: Documentation changes
- ✅ `test`: Adding/updating tests
- 📚 `example`: Adding/updating examples

### Performance & Security
- ⚡ `perf`: Performance improvements
- 🔒 `security`: Security fixes
- 🚨 `hotfix`: Critical hotfix

### Build & Dependencies
- 📦 `build`: Build system changes
- ⬆️ `upgrade`: Upgrade dependencies
- ⬇️ `downgrade`: Downgrade dependencies
- ➕ `add-dep`: Add dependency
- ➖ `remove-dep`: Remove dependency

### DevOps & CI/CD
- 👷 `ci`: CI/CD changes
- 🐳 `docker`: Docker related
- ☸️ `k8s`: Kubernetes related
- 🚀 `deploy`: Deployment

### Project Management
- 🎉 `init`: Initial commit
- 🔖 `release`: Version tag/release
- 🔀 `merge`: Merge branches
- ⏪ `revert`: Revert changes
- 🚧 `wip`: Work in progress

### Other
- 🌐 `i18n`: Internationalization
- ♿ `a11y`: Accessibility
- 🔧 `config`: Configuration changes
- 🗑️ `deprecate`: Deprecate code
- 💄 `ui`: UI/UX improvements

## Examples

### Simple
```
✨ feat: add user authentication
🐛 fix: resolve memory leak in data processor
📝 docs: update API documentation
```

### With Scope
```
✨ feat(auth): implement JWT authentication
🐛 fix(api): handle null pointer exception
♻️ refactor(utils): simplify date formatting logic
```

### With Body
```
🐛 fix(payment): prevent duplicate transactions

- Add transaction ID validation
- Implement database-level constraints
- Add retry logic with exponential backoff

Closes #123
```

## Rules

1. **Subject line**: Max 50 characters, imperative mood
2. **Body**: Wrap at 72 characters, explain what and why
3. **Emoji**: Use only one emoji at the beginning
4. **Type**: Lowercase, from the defined list
5. **Scope**: Optional, lowercase, meaningful context
6. **Breaking changes**: Add `BREAKING CHANGE:` in footer

## Conventional Commits Compatible

This convention is compatible with Conventional Commits specification while adding visual enhancement through emojis.
