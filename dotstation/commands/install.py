import subprocess
from pathlib import Path

import click
from rich.console import Console

from dotstation.constants import get_repo_root

console = Console()


@click.command("install")
@click.option("--dry-run", is_flag=True, help="Show what would be installed without running.")
def install(dry_run):
    """Install all packages (runs install.sh)."""
    console.print("\n[bold]Installing packages...[/bold]")

    install_script = get_repo_root() / "install.sh"
    if not install_script.exists():
        raise click.ClickException(f"install.sh not found at {install_script}")

    if dry_run:
        console.print(f"  [dim]Would run: bash {install_script}[/dim]")
        console.print("  [yellow]Dry run — no changes made.[/yellow]")
        return

    result = subprocess.run(["bash", str(install_script)])
    if result.returncode != 0:
        raise click.ClickException("install.sh exited with errors.")
