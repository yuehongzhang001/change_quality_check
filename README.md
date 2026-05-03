# change-quality-check

`change-quality-check` is a Codex skill for keeping code changes concise, structurally coherent, and documentation-aware.

## Repository Layout

This repository root is the skill root. Do not nest the skill inside another `change-quality-check/` directory.

Required layout:

```text
.
|-- SKILL.md
|-- agents/
|   `-- openai.yaml
|-- references/
|   |-- documentation-sync-checklist.md
|   `-- refactor-checklist.md
|-- scripts/
|   |-- install.ps1
|   `-- uninstall.ps1
`-- .gitignore
```

If you add another top-level folder and put the skill files under it, Codex will not load the skill from this repository as intended.

## Source Of Truth

This repository is the only source of truth for the skill.

- Edit files here.
- Install the skill into Codex by creating a junction at `$env:USERPROFILE\.codex\skills\change-quality-check`.
- Do not directly edit the installed junction target path under `.codex\skills`.

## Install

From the repository root:

```powershell
.\scripts\install.ps1
```

Optional parameters:

```powershell
.\scripts\install.ps1 -RepoPath D:\git\change_quality_check -SkillRoot "$env:USERPROFILE\.codex\skills"
```

Install behavior:

- Validates repository structure before touching the target path.
- Creates the target junction only when the target does not already exist.
- Refuses to overwrite a normal directory.
- Treats an existing junction to this repository as already installed.
- Refuses to overwrite a junction pointing elsewhere.

## Uninstall

```powershell
.\scripts\uninstall.ps1
```

Optional parameter:

```powershell
.\scripts\uninstall.ps1 -SkillRoot "$env:USERPROFILE\.codex\skills"
```

Uninstall behavior:

- Removes only the `change-quality-check` junction under the selected skill root.
- Refuses to delete a normal directory.
- Refuses to remove other link types.
- Never deletes the source repository.

## Update Workflow

1. Edit files in this repository.
2. If already installed through the junction, Codex reads the updated files from here.
3. If Codex does not pick up the change immediately, verify in a new session or restart Codex.
4. Commit and push this repository.

## Manual Validation

Run these checks after edits:

1. `.\scripts\install.ps1` succeeds from a valid repository root.
2. `.\scripts\install.ps1` fails without changing the target when a required file or directory is missing.
3. `.\scripts\uninstall.ps1` removes only the junction.
4. Codex can load `$change-quality-check` after install.
5. After editing visible text in this repository, Codex reflects the change. If not, validate again in a new session or after restarting Codex.
