from . import SO
from .pipe_command import pipe_command
from .return_completed_process import return_completed_process


def clean_jl(co):

    pr = pipe_command(
        None,
        [
            "julia",
            "--sysimage",
            SO,
            "--eval",
            'using JuliaFormatter: format_text; print(format_text("""{}"""))'.format(
                co
            ),
        ],
    )

    return return_completed_process(pr, co)
