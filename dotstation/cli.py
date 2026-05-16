import click
from rich.console import Console
from rich.panel import Panel
from rich.text import Text

from dotstation.commands.backup import backup
from dotstation.commands.restore import restore
from dotstation.commands.install import install
from dotstation.commands.deploy import deploy
from dotstation.commands.sync import sync
from dotstation.commands.init import init
from dotstation.commands.status import status

console = Console()

BANNER = Text.assemble(
    ("  dotstation", "bold magenta"),
    ("  —  ", "dim"),
    ("workstation setup, backup & restore", "dim white"),
)


@click.group()
@click.version_option(package_name="dotstation")
def cli():
    """Personal workstation setup, backup, and restore tool."""
    console.print(Panel(BANNER, border_style="magenta", padding=(0, 2)))


cli.add_command(backup)
cli.add_command(restore)
cli.add_command(install)
cli.add_command(deploy)
cli.add_command(sync)
cli.add_command(init)
cli.add_command(status)
