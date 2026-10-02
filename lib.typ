#let tuatTemplate(
  title: "実験報告書", // タイトル(上部)
  records: (),
  submitDate: "", // 提出日
  resubmitDate: "", // 再提出日
  deadline: "", // 期限日
  redeadline: "", // 再提出期限日
  subject: "", // 科目名
  teacher: "", // テーマ指導教員
  grade: "", // 学年
  semester: "", // 学期
  credit: "", // 単位
  theme: "", // テーマ
  studentId: "", // 学籍番号
  author: "", // 名前
  doc,
) = {
  if type(records) != array {
    panic("records は配列で指定してください")
  }
  if records.len() > 5 {
    panic("records は5件まで指定できます")
  }

  let rows = (36pt,)
  let pattern1(col1) = (
    table.cell(colspan: 3, [#col1]),
    [],
  )
  let pattern2(col1, col2) = (
    table.cell(colspan: 3, [#col1]),
    [#col2],
  )
  let pattern3(col1, col2, col3) = (
    [#col1],
    [#col2],
    [#col3],
    [],
  )

  align((center + horizon), heading(numbering: none, title))
  grid(
    table(
      rows: rows,
      columns: (0.7fr, 3fr, 3fr, 3fr),
      align: (center + horizon),
      stroke: (x: 1pt, y: 1pt),
      ..(
        for i in (2, 7, 8, 9) {
          (
            table.hline(y: i, start: 0, end: 6, stroke: 1pt),
            table.hline(y: i, start: 3, end: 6, stroke: none),
          )
        }
      ),
      ..(
        for i in (3, 4, 5, 6) {
          (
            table.hline(y: i, start: 0, end: 2, stroke: (dash: "dashed")),
            table.hline(y: i, start: 3, end: 6, stroke: none),
          )
        }
      ),
      ..(
        for i in (10, 11, 12, 13) {
          (
            table.hline(y: i, start: 0, end: 3, stroke: (dash: "dashed")),
            table.hline(y: i, start: 3, end: 6, stroke: none),
          )
        }
      ),
      table.header(..pattern2([*実験演習記録*], [*判定・指示*])),
      ..pattern3([], [年月日時], [共同作業者]),
      ..for i in range(5) {
        let record = if i < records.len() { records.at(i) } else {
          (date: "", collaborators: "")
        }
        if type(record) != dictionary {
          panic(
            "records の各要素は date と collaborators を持つ辞書で指定してください",
          )
        }
        let number = if i < 4 { str(i + 1) } else { "" }
        pattern3(number, record.at("date", default: ""), record.at(
          "collaborators",
          default: "",
        ))
      },
      ..pattern1([*レポート提出記録*]),
      ..pattern3([], [提出年月日], [期限年月日]),
      ..pattern3([初], submitDate, deadline),
      ..pattern3([再], resubmitDate, redeadline),
      ..pattern3([], [], []),
      ..pattern3([], [], []),
      ..pattern3([], [], []),
    ),
    table(
      rows: rows,
      columns: (3.7fr, 3fr, 1fr, 1fr, 1fr),
      align: (center + horizon),
      stroke: (x: 1pt, y: 1pt),
      [*科目名*], [*テーマ指導教員*], [*学年*], [*学期*], [*単位*],
      subject, teacher, grade, semester, credit,
    ),
    table(
      rows: rows,
      stroke: (x: 1pt, y: 1pt),
      columns: (3.7fr, 3fr, 3fr),
      align: (horizon + center),
      [*テーマ番号・テーマ名*], [*学籍番号*], [*名前*],
      theme, studentId, author,
    ),
  )

  align((center + horizon), [東京農工大学　工学部　知能情報システム工学科])
  doc
}
