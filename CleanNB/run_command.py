from subprocess import PIPE, Popen, run


def run_command(command, stdin=None):

    return Popen(
        command,
        stdin=stdin,
        stdout=PIPE,
        stderr=PIPE,
        universal_newlines=True,
    )


def run_command2(command, stdin=None):

    return run(
        command,
        stdin=stdin,
        capture_output=True,
        universal_newlines=True,
        check=True,
    )
