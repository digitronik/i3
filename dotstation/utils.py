import subprocess
from pathlib import Path
from rich.console import Console

console = Console()


def run(cmd: list[str], check: bool = True, silent: bool = False) -> subprocess.CompletedProcess:
    """Run a shell command, optionally silencing output."""
    result = subprocess.run(cmd, capture_output=silent, text=True)
    if check and result.returncode != 0:
        err = result.stderr.strip() if result.stderr else ""
        console.print(f"  [red][FAIL][/red]  {' '.join(cmd)}" + (f"\n  {err}" if err else ""))
    return result


def path_exists(p: Path) -> bool:
    return p.exists()


def ensure_dir(p: Path) -> None:
    p.mkdir(parents=True, exist_ok=True)


def is_command_available(cmd: str) -> bool:
    return subprocess.run(["which", cmd], capture_output=True).returncode == 0
