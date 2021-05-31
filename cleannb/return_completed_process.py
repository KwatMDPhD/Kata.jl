from .log import log


def return_completed_process(pr, co):

    ou, er = pr.communicate()

    if er[:5].lower() == "error":

        log("Skipped cleaning cell:", ty="warn")

        log(co, ty="code")

        print()

        return co

    else:

        return ou.strip()
