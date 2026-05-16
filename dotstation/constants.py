import os
from pathlib import Path

# Standard XDG/home paths — always available
HOME = Path.home()
CONFIG_DIR = HOME / ".config"
LOCAL_DIR = HOME / ".local"

# Where dotstation stores its own config
_REPO_CONFIG = HOME / ".config" / "dotstation" / "repo_path"

# Backup targets — independent of repo location
BACKUP_TARGETS = {
    "gpg":       HOME / ".gnupg",
    "ssh":       HOME / ".ssh",
    "gitconfig": HOME / ".gitconfig",
    "fish":      CONFIG_DIR / "fish",
    "i3":        CONFIG_DIR / "i3",
    "polybar":   CONFIG_DIR / "polybar",
    "hosts":     Path("/etc/hosts"),
}

# Default backup output directory
DEFAULT_BACKUP_DIR = HOME / "dotstation-backups"


def get_repo_root() -> Path:
    """Return the dotstation repo root path.

    Resolution order:
      1. DOTSTATION_REPO environment variable
      2. ~/.config/dotstation/repo_path (written by `dotstation init`)
      3. Walk up from __file__ (works when running from source)
    """
    if "DOTSTATION_REPO" in os.environ:
        return Path(os.environ["DOTSTATION_REPO"]).expanduser().resolve()

    if _REPO_CONFIG.exists():
        return Path(_REPO_CONFIG.read_text().strip()).expanduser().resolve()

    # Fallback: source install (not via uv tool)
    candidate = Path(__file__).parent.parent
    if (candidate / "pyproject.toml").exists():
        return candidate

    raise RuntimeError(
        "Repo path not configured.\n"
        "Run:  dotstation init <path-to-repo>\n"
        "Or:   export DOTSTATION_REPO=<path-to-repo>"
    )


def get_repo_i3_dir() -> Path:
    return get_repo_root() / "i3"


def get_repo_polybar_dir() -> Path:
    return get_repo_root() / "polybar"


def get_repo_fonts_dir() -> Path:
    return get_repo_root() / "fonts"
