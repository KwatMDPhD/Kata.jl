from subprocess import PIPE, Popen


def clean_julia_code(code):

    completed_process = Popen(
        (
            "julia",
            "--eval",
            'using JuliaFormatter: format_text; text = """{}"""; print(format_text(text))'.format(
                code
            ),
        ),
        stdout=PIPE,
        stderr=PIPE,
        universal_newlines=True,
    )

    cleaned_code = completed_process.communicate()[0].strip()

    if code and not cleaned_code:

        print("======== Failed ========")

        print(code)

        return code

    return cleaned_code
