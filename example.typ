#import "tuat-template.typ": tuatTemplate

#show: doc => tuatTemplate(
  // title: "実験報告書",            // タイトル(上部)
  date1: "2024-01-01",               // 日付1
  date2: "2024-01-02",               // 日付2
  date3: "2024-01-03",               // 日付3
  date4: "2024-01-04",               // 日付4
  // date5: "2021-01-05",            // 日付5
  collaborator1: "John Doe",         // 共同作業者1
  collaborator2: "Jane Doe",         // 共同作業者2
  collaborator3: "John Smith",       // 共同作業者3
  collaborator4: "Jane Smith",       // 共同作業者4
  // collaborator5: "John Johnson",  // 共同作業者5
  submitDate: "2024-01-06",          // 提出日
  resubmitDate: "2024-01-08",        // 再提出日
  deadline: "2024-01-07",            // 期限日
  redeadline: "2024-01-09",          // 再提出期限日
  subject: "情報工学実験",           // 科目
  teacher: "先生",                   // テーマ指導教員
  grade: "3",                        // 学年
  semester: "前期",                  // 学期
  credit: "2",                       // 単位
  theme: "テーマ",                   // テーマ
  studentId: "学籍番号",             // 学籍番号
  author: "名前",                    // 名前
  doc
)
