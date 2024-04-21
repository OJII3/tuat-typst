#let tuatTemplate(
  title: "実験報告書", // タイトル(上部)
  date1: "", // 日付1
  date2: "", // 日付2
  date3: "", // 日付3
  date4: "", // 日付4
  date5: "", // 日付5
  collaborator1: "", // 共同作業者1
  collaborator2: "", // 共同作業者2
  collaborator3: "", // 共同作業者3
  collaborator4: "", // 共同作業者4
  collaborator5: "", // 共同作業者5
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
  set text(font: "Noto Serif CJK JP")
  // 本文のフォント指定
  
  let mixed(body) = {
    set text(weight: "extrabold")
    show regex("[\p{scx:Han}\p{scx:Hira}\p{scx:Kana}]"): set text(font: "Noto Sans CJK JP", weight: "bold")
    body
  }
  // 和欧混植のフォント別々指定
  
  set page(header: mixed[])
  // 柱へ応用
  
  set text(font: "Noto Serif CJK JP", size: 12pt)
  
  let rows = {
    let n = 0; while n < 18 {
      n += 1; (36pt,)
    }
  }
  let columns = (32pt, 3fr, 2fr, 1fr, 1fr, 1fr)
  let pattern1(col1) = (table.cell(colspan: 3, [#col1]), table.cell(colspan: 3, []))
  let pattern2(col1, col2) = (table.cell(colspan: 3, [#col1]), table.cell(colspan: 3, [#col2]))
  let pattern3(col1, col2, col3) = ([#col1], [#col2], [#col3], table.cell(colspan: 3, []))
  let pattern4(col1, col2, col3) = (
    table.cell(colspan: 2, [#col1]),
    [#col2],
    table.cell(colspan: 3, [#col3]),
  )
  let pattern5(col1, col2, col3, col4, col5) = (table.cell(colspan: 2, [#col1]), [#col2], [#col3], [#col4], [#col5])
  
  let table_header = table.header(..pattern2([*実験演習記録*], [*判定・指示*]))
  
  align((center + horizon), [= #title])
  align(horizon, table(
    rows: rows,
    columns: columns,
    align: (center + horizon),
    stroke: (x: 1pt, y: 1pt),
    ..(for i in (2, 7, 8, 9) {
      (
        table.hline(y: i, start: 0, end: 6, stroke: 1pt),
        table.hline(y: i, start: 3, end: 6, stroke: none),
      )
    }),
    ..(for i in (3, 4, 5, 6) {
      (
        table.hline(y: i, start: 0, end: 2, stroke: (dash: "dashed")),
        table.hline(y: i, start: 3, end: 6, stroke: none),
      )
    }),
    ..(for i in (10, 11, 12, 13) {
      (
        table.hline(y: i, start: 0, end: 3, stroke: (dash: "dashed")),
        table.hline(y: i, start: 3, end: 6, stroke: none),
      )
    }),
    table_header,
    ..pattern3([], [年月日時], [共同作業者]),
    ..pattern3(1, [#date1], [#collaborator1]),
    ..pattern3(2, [#date2], [#collaborator2]),
    ..pattern3(3, [#date3], [#collaborator3]),
    ..pattern3(4, [#date4], [#collaborator4]),
    ..pattern3([], [#date5], [#collaborator5]),
    ..pattern1([*レポート提出記録*]),
    ..pattern3([], [提出年月日], [期限年月日]),
    ..pattern3([初], [#submitDate], [#deadline]),
    ..pattern3([再], [#resubmitDate], [#redeadline]),
    ..pattern3([], [], []),
    ..pattern3([], [], []),
    ..pattern3([], [], []),
    ..pattern5([*科目名*], [*テーマ指導教員*], [*学年*], [*学期*], [*単位*]),
    ..pattern5([#subject], [#teacher], [#grade], [#semester], [#credit]),
    ..pattern4([*テーマ番号・テーマ名*], [*学籍番号*], [*名前*]),
    ..pattern4([#theme], [#studentId], [#author]),
  ))
  
  align((center + horizon), [東京農工大学 工学部 知能情報システム工学科])
  doc
}
