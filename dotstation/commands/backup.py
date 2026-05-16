import tarfile
import datetime
from pathlib import Path

import click
from rich.console import Console
from rich.table import Table

from dotstation.constants import BACKUP_TARGETS, DEFAULT_BACKUP_DIR
from dotstation.utils import ensure_dir, path_exists

console = Console()


def _timestamp() -> str:
    return datetime.datetime.now().strftime("%Y-%m-%d_%H%M%S")


def _backup_items(items: dict[str, Path], output_dir: Path, encrypt: bool) -> None:
    ensure_dir(output_dir)
    archive_name = f"dotstation-backup-{_timestamp()}.tar.gz"
    archive_path = output_dir / archive_name

    missing = []
    included = []

    with tarfile.open(archive_path, "w:gz") as tar:
        for label, path in items.items():
            if path_exists(path):
                tar.add(path, arcname=str(path.relative_to(Path.home())) if path.is_relative_to(Path.home()) else label)
                included.append((label, str(path)))
                console.print(f"  [green][OK][/green]    Backed up [bold]{label}[/bold]  ({path})")
            else:
                missing.append((label, str(path)))
                console.print(f"  [yellow][SKIP][/yellow]  {label} — not found ({path})")

    if encrypt:
        _gpg_encrypt(archive_path)
        archive_path.unlink()
        archive_path = Path(str(archive_path) + ".gpg")

    console.print(f"\n  [bold green]Archive saved:[/bold green] {archive_path}")
    if missing:
        console.print(f"  [yellow]Skipped {len(missing)} missing path(s).[/yellow]")


def _gpg_encrypt(path: Path) -> None:
    import subprocess
    console.print("  [dim]Encrypting archive (you will be prompted to set a passphrase)...[/dim]")
    result = subprocess.run(
        ["gpg", "--symmetric", "--cipher-algo", "AES256", str(path)]
    )
    if result.returncode != 0:
        console.print("  [red][FAIL][/red]  GPG encryption failed — keeping unencrypted archive.")


@click.group()
def backup():
    """Backup GPG keys, SSH keys, dotfiles, and configs."""


@backup.command("gpg")
@click.option("--output", "-o", default=str(DEFAULT_BACKUP_DIR), help="Output directory.")
@click.option("--encrypt/--no-encrypt", default=False, help="GPG-encrypt the archive.")
def backup_gpg(output, encrypt):
    """Backup GPG keys (~/.gnupg)."""
    console.print("\n[bold]Backing up GPG keys...[/bold]")
    _backup_items({"gpg": BACKUP_TARGETS["gpg"]}, Path(output), encrypt)


@backup.command("ssh")
@click.option("--output", "-o", default=str(DEFAULT_BACKUP_DIR), help="Output directory.")
@click.option("--encrypt/--no-encrypt", default=True, help="GPG-encrypt the archive.")
def backup_ssh(output, encrypt):
    """Backup SSH keys and config (~/.ssh)."""
    console.print("\n[bold]Backing up SSH keys...[/bold]")
    _backup_items({"ssh": BACKUP_TARGETS["ssh"]}, Path(output), encrypt)


@backup.command("dotfiles")
@click.option("--output", "-o", default=str(DEFAULT_BACKUP_DIR), help="Output directory.")
@click.option("--encrypt/--no-encrypt", default=False, help="GPG-encrypt the archive.")
def backup_dotfiles(output, encrypt):
    """Backup dotfiles (.gitconfig, fish config, etc.)."""
    console.print("\n[bold]Backing up dotfiles...[/bold]")
    targets = {k: v for k, v in BACKUP_TARGETS.items() if k in ("gitconfig", "fish", "hosts")}
    _backup_items(targets, Path(output), encrypt)


@backup.command("configs")
@click.option("--output", "-o", default=str(DEFAULT_BACKUP_DIR), help="Output directory.")
@click.option("--encrypt/--no-encrypt", default=False, help="GPG-encrypt the archive.")
def backup_configs(output, encrypt):
    """Backup i3 and Polybar configs."""
    console.print("\n[bold]Backing up i3 and Polybar configs...[/bold]")
    targets = {k: v for k, v in BACKUP_TARGETS.items() if k in ("i3", "polybar")}
    _backup_items(targets, Path(output), encrypt)


@backup.command("all")
@click.option("--output", "-o", default=str(DEFAULT_BACKUP_DIR), help="Output directory.")
@click.option("--encrypt/--no-encrypt", default=True, help="GPG-encrypt the archive.")
def backup_all(output, encrypt):
    """Backup everything — GPG, SSH, dotfiles, and configs."""
    console.print("\n[bold]Backing up everything...[/bold]")
    _backup_items(BACKUP_TARGETS, Path(output), encrypt)
