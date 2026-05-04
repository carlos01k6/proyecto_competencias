import zlib

STUDENT_CODE_YEAR = "2026"


def generar_codigo_estudiante(*valores):
    base = "|".join(str(valor) for valor in valores if valor)
    if not base:
        base = "estudiante"

    numero = zlib.crc32(base.encode("utf-8")) % 10000
    return f"{STUDENT_CODE_YEAR}-{numero:04d}"
