# Contributing to pxCommands

## Reporting Issues

- Use the issue tracker on GitHub: https://github.com/CodeMeAPixel/pxCommands
- Include reproduction steps, FXServer version, and framework (if applicable).
- For security issues, see [SECURITY.md](SECURITY.md).

## Submitting Changes

1. Fork the repository.
2. Create a feature branch: `git checkout -b feature/your-feature`.
3. Make clean, atomic commits with clear messages.
4. Ensure no debug logs or test code remains.
5. Submit a pull request with a clear description of changes.

## Code Standards

- Use 4-space indentation.
- Keep functions focused and readable.
- Avoid adding slop/bloat (excessive comments, debug output, unused code).
- Server-side validation is mandatory for security-sensitive features.
- Document breaking changes in PR description.

## Command Pack Guidelines

When contributing command packs:
- Place the pack in `commands/yourpackname.lua`.
- Use the `CommandPack()` helper from `system/server/pre.lua`.
- Include inline documentation of command parameters.
- Test thoroughly before submission (especially admin checks).
- Avoid hardcoded player IDs or resource paths in command logic.

## Testing

Before submitting:
- Test on a clean server with your target framework.
- Verify ACL/admin checks work as expected.
- Check that command help text displays correctly.
- Ensure no console errors or warnings appear.

## License

By contributing, you agree that your code will be licensed under AGPL-3.0 (same as the project).
