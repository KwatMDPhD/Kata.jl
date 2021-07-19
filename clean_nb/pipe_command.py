from subprocess import PIPE, Popen


def pipe_command(st, co):

    return Popen(co, stdin=st, stdout=PIPE, stderr=PIPE, universal_newlines=True)
