#include "tuat-template.typ"

#set text(font: "Noto Serif CJK JP")
// 本文のフォント指定

#let mixed(body) = {
  set text(weight: "extrabold")
  show regex("[\p{scx:Han}\p{scx:Hira}\p{scx:Kana}]"): set text(font: "Noto Sans CJK JP", weight: "bold")
  body
}
// 和欧混植のフォント別々指定

#set page(header: mixed[])
// 柱へ応用

#set text(font: "Noto Serif CJK JP", size: 12pt)

#let title = [実験報告書]
#let rows = { let n = 0; while n < 18 {
  n += 1; (36pt, )
} }
#let columns = (32pt, 3fr, 3fr, 1fr, 1fr, 1fr)
#let pattern1(col1) = (table.cell(colspan: 3, [#col1]), table.cell(colspan: 3, []))
#let pattern2(col1, col2) = (table.cell(colspan: 3, [#col1]), table.cell(colspan: 3, [#col2]))
#let pattern3(col1, col2, col3) = ([#col1], [#col2], [#col3], table.cell(colspan: 3, []))
#let pattern4(col1, col2, col3) = (table.cell(colspan: 2, [#col1]), [#col2], table.cell(colspan: 3, [#col3]))
#let pattern5(col1, col2, col3, col4, col5) = (table.cell(colspan: 2, [#col1]), [#col2], [#col3], [#col4], [#col5])

#let table_header = table.header(..pattern2([*実験演習記録*], [*判定・指示*]))

#align((center + horizon), [= #title])
#align(horizon, table(
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
  ..pattern3(1, "2021-01-01", "John Doe"),
  ..pattern3(2, "2021-01-02", "Jane Doe"),
  ..pattern3(3, "2021-01-03", "John Smith"),
  ..pattern3(4, "2021-01-04", "Jane Smith"),
  ..pattern3([], [], []),
  ..pattern1([*レポート提出記録*]),
  ..pattern3([], [提出年月日], [期限年月日]),
  ..pattern3([初], "2021-01-06", "2021-01-07"),
  ..pattern3([再], "2021-01-08", "2021-01-09"),
  ..pattern3([], [], []),
  ..pattern3([], [], []),
  ..pattern3([], [], []),
  ..pattern5([*科目名*], [*テーマ指導教員*], [*学年*], [*学期*], [*単位*]),
  ..pattern5([情報工学実験], [John Doe], [2], [後期], [2]),
  ..pattern4([*テーマ番号・テーマ名*], [*学籍番号*], [*名前*]),
  ..pattern4([テーマ], [学籍番号], [名前]),
))

#align((center + horizon), [東京農工大学 工学部 知能情報システム工学科])
