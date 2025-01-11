# Script that rebases and autosquashes the staged changes into the specified commit.
#
# Usage: git autofixup <target-commit-identifier>

{ pkgs }:
pkgs.writeShellScriptBin "git-autofixup" ''
  # Ensure we're in a git repository
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "error: not a git repository" >&2
    exit 1
  fi

  # Assert that a target commit identifier is provided
  if [[ -z "$1" ]]; then
    echo "error: target commit identifier not provided" >&2
    echo "usage: git autofixup <target>" >&2
    exit 1
  fi

  # Check that there are staged changes
  if git diff --cached --quiet; then
    echo "error: no changes staged for commit" >&2
    exit 1
  fi

  # Assert that the target commit exists.
  #
  # git rev-parse is used to turn mutable commit aliases like HEAD into static SHAs.
  HOTFIX_TARGET="$(git rev-parse --verify --quiet "$1")" || {
    echo "error: no commit found for identifier '$1'" >&2
    exit 1
  }

  # Create the fixup commit
  if ! git commit --fixup "$HOTFIX_TARGET"; then
    echo "error: failed to create fixup commit" >&2
    exit 1
  fi

  # Perform rebase with autosquash
  #
  # Rebase is performed with an "empty" sequence editor to allow the use of
  # interactive rebase without actual interaction. Interactive rebase is needed
  # to actually execute the autosquash.
  if ! git -c sequence.editor=: rebase --interactive --autostash --autosquash "$HOTFIX_TARGET~1"; then
    echo "error: failed to apply fixup commit" >&2
    git rebase --abort
    git reset --soft HEAD~1
    exit 1
  fi

  echo "Successfully applied fixup commit"
''
