"""
Entrypoint for giantpandrna

Check out the wiki for a detailed look at customising this file:
https://github.com/beardymcjohnface/Snaketool/wiki/Customising-your-Snaketool
"""

import os
import click

from .util import (
    snake_base,
    print_version,
    default_to_output,
    copy_config,
    run_snakemake,
    OrderedCommands,
    print_citation,
)


def common_options(func):
    """Common command line args
    Define common command line args here, and include them with the @common_options decorator below.
    """
    options = [
        click.option(
            "--output",
            help="Output directory",
            type=click.Path(dir_okay=True, writable=True, readable=True),
            default="giantpandrna.out",
            show_default=True,
        ),
        click.option(
            "--configfile",
            default="config.yaml",
            show_default=False,
            callback=default_to_output,
            help="Custom config file [default: (outputDir)/config.yaml]",
        ),
        click.option(
            "--threads", help="Number of threads to use", default=1, show_default=True
        ),
        click.option(
            "--use-conda/--no-use-conda",
            default=True,
            help="Use conda for Snakemake rules",
            show_default=True,
        ),
        click.option(
            "--conda-prefix",
            default=snake_base(os.path.join("workflow", "conda")),
            help="Custom conda env directory",
            type=click.Path(),
            show_default=False,
        ),
        click.option(
            "--snake-default",
            multiple=True,
            default=[
                "--rerun-incomplete",
                "--printshellcmds",
                "--nolock",
                "--show-failed-logs",
            ],
            help="Customise Snakemake runtime args",
            show_default=True,
        ),
        click.option(
            "--log",
            default="giantpandrna.log",
            callback=default_to_output,
            hidden=True,
        ),
        click.argument("snake_args", nargs=-1),
    ]
    for option in reversed(options):
        func = option(func)
    return func


@click.group(
    cls=OrderedCommands, context_settings=dict(help_option_names=["-h", "--help"])
)
def cli():
    """For more options, run:
    giantpandrna command --help"""
    pass


help_msg_extra = """
\b
CLUSTER EXECUTION:
giantpandrna run ... --profile [profile]
For information on Snakemake profiles see:
https://snakemake.readthedocs.io/en/stable/executing/cli.html#profiles
\b
RUN EXAMPLES:
Required:           giantpandrna run --input [file]
Specify threads:    giantpandrna run ... --threads [threads]
Disable conda:      giantpandrna run ... --no-use-conda 
Change defaults:    giantpandrna run ... --snake-default="-k --nolock"
Add Snakemake args: giantpandrna run ... --dry-run --keep-going --touch
Specify targets:    giantpandrna run ... all print_targets
Available targets:
    all             Run everything (default)
    print_targets   List available targets
"""

help_msg_install = """
\b
CLUSTER EXECUTION:
giantpandrna install ... 
\b
RUN EXAMPLES:
Species:           giantpandrna install --species [Rat|Human]
referenceDir:      giantpandrna install --referenceDir 
"""

@click.command(
    epilog=help_msg_extra,
    context_settings=dict(
        help_option_names=["-h", "--help"], ignore_unknown_options=True
    ),
)
@click.option("--input", "_input", help="Input file/directory", type=str, required=True)
@click.option('--species','species',  help='Species', show_default=True,  default='Rat',type=click.Choice(['Rat', 'Human']))
@click.option('--kit','kit',  help='Kit', show_default=True,  default='DCS109',type=click.Choice(['DCS109', 'PCS109']))
@click.option('--referenceDir','referenceDir',  help='Reference Directory for Transcriptomes', show_default=True,  default='Database')
@common_options
def run(_input, output, species, referenceDir, kit, log, **kwargs):
    """Run giantpandrna"""
    # Config to add or update in configfile
    merge_config = {"input": _input, "output": output, "log": log, "species": species, 'referenceDir': referenceDir, 'kit': kit}
    # run!
    run_snakemake(
        # Full path to Snakefile
        snakefile_path=snake_base(os.path.join("workflow", "Snakefile")),
        merge_config=merge_config,
        log=log,
        **kwargs
    )


@click.command(
    epilog=help_msg_install,
    context_settings=dict(
        help_option_names=["-h", "--help"], ignore_unknown_options=True
    ))
@click.option(
            "--use-conda/--no-use-conda",
            default=True,
            help="Use conda for Snakemake rules",
            show_default=True,
        )
@click.option(
            "--snake-default",
            multiple=True,
            default=[
                "--rerun-incomplete",
                "--printshellcmds",
                "--nolock",
                "--show-failed-logs",
                "--conda-frontend conda"
            ],
            help="Customise Snakemake runtime args",
            show_default=True,
        )
@click.option('--species', 'species', help='Species', show_default=True,  default='Rat',type=click.Choice(['Rat', 'Human']))
@click.option('--referenceDir','referenceDir',  help='Reference Directory for Transcriptomes', show_default=True,  default='Database')
@click.option(
            "--configfile",
            default="config.yaml",
            show_default=False,
            callback=default_to_output,
            help="Custom config file [default: (outputDir)/config.yaml]",
        )
def install(species, referenceDir,  **kwargs):
    # Config to add or update in configfile
    merge_config = { "species": species, 'referenceDir': referenceDir }
    """Install databases"""
    run_snakemake(
        snakefile_path=snake_base(os.path.join('workflow','installDB.smk')),
        merge_config=merge_config,
        **kwargs)


@click.command()
@common_options
def config(configfile, **kwargs):
    """Copy the system default config file"""
    copy_config(configfile)


@click.command()
def citation(**kwargs):
    """Print the citation(s) for this tool"""
    print_citation()


cli.add_command(install)
cli.add_command(run)
cli.add_command(config)
cli.add_command(citation)


def main():
    print_version()
    cli()


if __name__ == "__main__":
    main()
