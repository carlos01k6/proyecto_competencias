const STUDENT_CODE_YEAR = "2026"

function crc32(value) {
  let crc = 0 ^ -1

  for (let index = 0; index < value.length; index += 1) {
    crc ^= value.charCodeAt(index)
    for (let bit = 0; bit < 8; bit += 1) {
      crc = (crc >>> 1) ^ (0xedb88320 & -(crc & 1))
    }
  }

  return (crc ^ -1) >>> 0
}

export function getStudentCode(student) {
  if (!student) return ""
  if (student.codigo_estudiante || student.student_code) {
    return student.codigo_estudiante || student.student_code
  }

  const id = student.id || student.student_id || student.estudiante_id || ""
  if (!id) return ""

  const values = [id, student.email || student.student_email].filter(Boolean)
  const value = values.join("|")

  const hash = crc32(value) % 10000

  return `${STUDENT_CODE_YEAR}-${String(hash).padStart(4, "0")}`
}
