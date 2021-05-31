from subprocess import PIPE, Popen


def pipe_command(stdin, command):

    return Popen(
        command, stdin=stdin, stdout=PIPE, stderr=PIPE, universal_newlines=True
    )
