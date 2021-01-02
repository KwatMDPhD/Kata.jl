from subprocess import run

def run_command(command, stdin):

    return run(
        command,
        stdin=stdin,
        capture_output=True,
        universal_newlines=True,
        check=True,
    )
