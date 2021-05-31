from .log import log


def return_completed_process(completed_process, code):

    (output, error) = completed_process.communicate()

    if error[:5].lower() == "error":

        log("Skipped cleaning cell:", kind="warn")

        log(code, kind="code")

        print()

        return code

    else:

        return output.strip()
