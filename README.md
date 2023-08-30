# テーブル設計

## usersテーブル

| Columns            | Type   | Options                   |
| ------------------ | ------ | ------------------------- |
| email              | string | null: false, unique: true |
| encrypted_password | string | null: false               |
| name               | string | null: false               |
| profile            | text   | null: false               |
| occupation         | text   | null: false               |
| position           | text   | null: false               |

### Association

- has_many :prototypes
- has_many :comments

## prototypesテーブル

| Columns    | Type       | Options                    |
| ---------- | ---------- | -------------------------- |
| title      | string     | null: false                |
| catch_copy | text       | null: false                |
| concept    | text       | null: false                |
| user       | references | null: false, foreign: true |

### Association

- belongs_to :user
- has_many :comments

## commentsテーブル

| Columns   | Type       | Options                    |
| --------- | ---------- | -------------------------- |
| content   | text       | null: false                |
| prototype | references | null: false, foreign: true |
| user      | references | null: false, foreign: true |

### Association

- belongs_to :prototype
- belongs_to :user