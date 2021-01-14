from click import secho


def log(message, kind="message"):

    if kind == "whisper":

        bold, dim, fg, bg, err = False, True, None, None, False

    elif kind == "message":

        bold, dim, fg, bg, err = True, False, "bright_green", "black", False

    elif kind == "code":

        bold, dim, fg, bg, err = True, False, "bright_white", "black", False

    elif kind == "warn":

        bold, dim, fg, bg, err = True, False, "bright_yellow", "black", False

    elif kind == "error":

        bold, dim, fg, bg, err = True, False, "bright_red", "black", True

    secho(message, bold=bold, dim=dim, fg=fg, bg=bg, err=err)
