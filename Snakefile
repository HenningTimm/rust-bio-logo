
logos = [
    "bioferris",
    "bioferris_thin_strand",
    "bioferris_thick_strand",
    "bioferris_light_strand",
    "bioferris_curly_back",
    "bioferris_curly_front",
]

resolutions = [
    32,
    128,
    256,
    512,
    "full",
]



rule all:
    input:
        "png/overview.png"


rule export_png:
    input:
        "svg/{logo}.svg"
    output:
        "png/{logo}_{resolution}.png"
    params:
        resolution=lambda w: "" if w.resolution == "full" else f"export-width:{w.resolution};"
    shell:
        # Tested with inkscape 1.0 installed on ubunto 20.04 via snap
        "inkscape --export-filename {output} --export-type png --actions='{params.resolution}export-do;' {input}"


rule assemble_line:
    input:
        expand(
            "png/{{logo}}_{resolution}.png",
            resolution=[res for res in resolutions if res != "full"],
        ),
    output:
        "png/row_{logo}_all.png"
    shell:
        "convert -background transparent {input} +append {output}"

rule assemble_overview:
    input:
        expand(
            "png/row_{logo}_all.png",
            logo=logos,
        ),
    output:
        "png/overview.png",
    shell:
        "convert -background transparent {input} -append {output}"
