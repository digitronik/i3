import tarfile
import subprocess
from pathlib import Path

import click
from rich.console import Console

from dotstation.constants import DEFAULT_BACKUP_DIR
from dotstation.utils import ensure_dir

console = Console()


def _fix_permissions(paths: list[Path]) -> None:
    """Fix file permissions for security-sensitive restored paths."""
    for path in paths:
        if not path.exists():
            continue

        # ~/.gnupg — strict: 700 dir, 600 all files
        if path.name == ".gnupg":
            path.chmod(0o700)
            for item in path.rglob("*"):
                item.chmod(0o700 if item.is_dir() else 0o600)

        # ~/.ssh — 700 dir, 600 keys, 644 public/known_hosts
        elif path.name == ".ssh":
            path.chmod(0o700)
            for item in path.rglob("*"):
                if item.is_dir():
                    item.chmod(0o700)
                elif item.suffix == ".pub" or item.name in ("known_hosts", "known_hosts.old", "authorized_keys"):
                    item.chmod(0o644)
                else:
                    item.chmod(0o600)

        # i3 and polybar — 755 dirs, 644 files, 755 scripts
        elif path.name in ("i3", "polybar"):
            for item in path.rglob("*"):
                if item.is_dir():
                    item.chmod(0o755)
                elif item.suffix == ".sh":
                    item.chmod(0o755)
                else:
                    item.chmod(0o644)

        # fish config — 755 dirs, 644 files
        elif path.name == "fish":
            for item in path.rglob("*"):
                item.chmod(0o755 if item.is_dir() else 0o644)

        # .gitconfig — 644
        elif path.name == ".gitconfig":
            path.chmod(0o644)

    console.print("  [dim]Permissions fixed.[/dim]")


def _list_backups(backup_dir: Path) -> list[Path]:
    if not backup_dir.exists():
        return []
    return sorted(backup_dir.glob("dotstation-backup-*.tar.gz*"), reverse=True)


def _decrypt_if_needed(archive: Path) -> Path:
    if archive.suffix == ".gpg":
        import subprocess
        decrypted = Path(str(archive).removesuffix(".gpg"))
        console.print("  [dim]Decrypting archive (you will be prompted for the passphrase)...[/dim]")
        result = subprocess.run(
            ["gpg", "--output", str(decrypted), "--decrypt", str(archive)]
        )
        if result.returncode != 0:
            raise click.ClickException("GPG decryption failed. Check your passphrase and try again.")
        return decrypted
    return archive


def _restore_archive(archive: Path, targets: list[str] | None = None) -> None:
    archive = _decrypt_if_needed(archive)

    with tarfile.open(archive, "r:gz") as tar:
        members = tar.getmembers()
        for member in members:
            if targets:
                match = any(member.name.startswith(t.lstrip("/")) for t in targets)
                if not match:
                    continue
            dest = Path.home() / member.name
            ensure_dir(dest.parent)
            # Remove existing file/dir to avoid permission conflicts
            if dest.exists() and not dest.is_dir():
                try:
                    dest.unlink()
                except PermissionError:
                    dest.chmod(0o644)
                    dest.unlink()
            try:
                tar.extract(member, path=Path.home(), filter="data")
                console.print(f"  [green][OK][/green]    Restored {member.name}")
            except PermissionError as e:
                console.print(f"  [yellow][SKIP][/yellow]  {member.name} — permission denied, skipping")


def _pick_backup(backup_dir: Path) -> Path:
    backups = _list_backups(backup_dir)
    if not backups:
        raise click.ClickException(f"No backups found in {backup_dir}")

    console.print("\n  [bold]Available backups:[/bold]")
    for i, b in enumerate(backups, 1):
        console.print(f"    {i}. {b.name}")

    choice = click.prompt("\n  Select backup number", type=int, default=1)
    if choice < 1 or choice > len(backups):
        raise click.ClickException("Invalid selection.")
    return backups[choice - 1]


@click.group()
def restore():
    """Restore GPG keys, SSH keys, dotfiles, and configs from a backup."""


@restore.command("gpg")
@click.option("--from", "source", default=str(DEFAULT_BACKUP_DIR), help="Backup directory.")
def restore_gpg(source):
    """Restore GPG keys (~/.gnupg)."""
    console.print("\n[bold]Restoring GPG keys...[/bold]")
    archive = _pick_backup(Path(source))
    _restore_archive(archive, targets=[".gnupg"])
    _fix_permissions([Path.home() / ".gnupg"])


@restore.command("ssh")
@click.option("--from", "source", default=str(DEFAULT_BACKUP_DIR), help="Backup directory.")
def restore_ssh(source):
    """Restore SSH keys and config (~/.ssh)."""
    console.print("\n[bold]Restoring SSH keys...[/bold]")
    archive = _pick_backup(Path(source))
    _restore_archive(archive, targets=[".ssh"])
    _fix_permissions([Path.home() / ".ssh"])


@restore.command("dotfiles")
@click.option("--from", "source", default=str(DEFAULT_BACKUP_DIR), help="Backup directory.")
def restore_dotfiles(source):
    """Restore dotfiles (.gitconfig, fish config, etc.)."""
    console.print("\n[bold]Restoring dotfiles...[/bold]")
    archive = _pick_backup(Path(source))
    _restore_archive(archive, targets=[".gitconfig", ".config/fish", "etc/hosts"])
    _fix_permissions([
        Path.home() / ".gitconfig",
        Path.home() / ".config" / "fish",
    ])


@restore.command("configs")
@click.option("--from", "source", default=str(DEFAULT_BACKUP_DIR), help="Backup directory.")
def restore_configs(source):
    """Restore i3 and Polybar configs."""
    console.print("\n[bold]Restoring i3 and Polybar configs...[/bold]")
    archive = _pick_backup(Path(source))
    _restore_archive(archive, targets=[".config/i3", ".config/polybar"])
    _fix_permissions([
        Path.home() / ".config" / "i3",
        Path.home() / ".config" / "polybar",
    ])


@restore.command("all")
@click.option("--from", "source", default=str(DEFAULT_BACKUP_DIR), help="Backup directory.")
def restore_all(source):
    """Restore everything from a backup archive."""
    console.print("\n[bold]Restoring everything...[/bold]")
    archive = _pick_backup(Path(source))
    _restore_archive(archive)
    _fix_permissions([
        Path.home() / ".gnupg",
        Path.home() / ".ssh",
        Path.home() / ".gitconfig",
        Path.home() / ".config" / "fish",
        Path.home() / ".config" / "i3",
        Path.home() / ".config" / "polybar",
    ])
