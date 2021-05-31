from click import secho


def log(me, ty="message"):

    if ty == "whisper":

        bo, di, fg, bg, er = False, True, None, None, False

    elif ty == "message":

        bo, di, fg, bg, er = True, False, "bright_green", "black", False

    elif ty == "code":

        bo, di, fg, bg, er = True, False, "bright_white", "black", False

    elif ty == "warn":

        bo, di, fg, bg, er = True, False, "bright_yellow", "black", False

    elif ty == "error":

        bo, di, fg, bg, er = True, False, "bright_red", "black", True

    secho(me, bold=bo, dim=di, fg=fg, bg=bg, err=er)
