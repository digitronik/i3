from pathlib import Path

import click
from rich.console import Console

from dotstation.constants import _REPO_CONFIG

console = Console()


@click.command("init")
@click.argument("repo_path", default=".", type=click.Path(exists=True, file_okay=False, resolve_path=True))
def init(repo_path):
    """Register the dotstation repo path (run once after cloning).

    REPO_PATH defaults to the current directory.
    """
    path = Path(repo_path).resolve()

    if not (path / "pyproject.toml").exists():
        raise click.ClickException(f"{path} does not look like the dotstation repo (no pyproject.toml found).")

    _REPO_CONFIG.parent.mkdir(parents=True, exist_ok=True)
    _REPO_CONFIG.write_text(str(path) + "\n")

    console.print(f"\n  [green][OK][/green]    Repo path registered: [bold]{path}[/bold]")
    console.print(f"  [dim]Stored in {_REPO_CONFIG}[/dim]")
    console.print("\n  You can now run [bold]dotstation sync[/bold], [bold]dotstation deploy[/bold], etc.")
