from subprocess import PIPE, Popen

def run_command(command, stdin):

    return Popen(
        command,
        stdin=stdin,
        stdout=PIPE,
        stderr=PIPE,
        universal_newlines=True,
    )
