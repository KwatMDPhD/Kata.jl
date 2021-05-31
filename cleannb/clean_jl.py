from .pipe_command import pipe_command
from .return_completed_process import return_completed_process


def clean_jl(
    code,
):

    completed_process = pipe_command(
        None,
        (
            "julia",
            "--eval",
            'using JuliaFormatter: format_text; print(format_text("""{}"""))'.format(
                code
            ),
        ),
    )

    return return_completed_process(completed_process, code)
