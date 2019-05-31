# BUILD

Shared library for commmon development and deployment tasks. Designed to be imported as a git submodule.

## Usage

Include *makefile.mk* into your project's *Makefile*
Set environment variables in your *Makefile*:
- **TEAM_NAME** mandatory.
- **APP_NAME** mandatory.
- **APP_PORT** mandatory.
- **LIBRARY** *true/false*, optional. If not true, the importing project is treated as a runnable and deployable application.
  If *true*, the project is treated as a "library" to be imported by other projects: all run and deploy tasks are excluded. (default: FALSE)

Available command by default are defined in common_dev.mk and ci.mk files. If the service is executable, LIBRARY variable is set to false, commands from app_dev.mk and cd.mk are added.

## Type and structure of importing projects and internal APP_ROOT vars

**APP_ROOT** relative path to project's source packages from a project's Makefile working directory (i.e, normally, from project's root)
