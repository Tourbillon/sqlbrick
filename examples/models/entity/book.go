// Code generated by github.com/anbillon/sqlbrick. DO NOT EDIT IT.

// This file is generated from: book.sqb

package entity

import (
	"github.com/anbillon/sqlbrick/typex"
)

// Type definition for Book which defined in sqb file.
// This can be used as a model in database operation.
type Book struct {
	Id         int32            `db:"id"`
	Uid        int32            `db:"uid"`
	Name       string           `db:"name"`
	Content    typex.NullString `db:"content"`
	CreateTime typex.NullTime   `db:"create_time"`
	Price      int32            `db:"price"`
}