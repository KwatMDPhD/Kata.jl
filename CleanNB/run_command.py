from subprocess import PIPE, Popen, run


def run_command(command, stdin=None):

    return Popen(
        command,
        stdin=stdin,
        stdout=PIPE,
        stderr=PIPE,
        universal_newlines=True,
    )
