// {{ .FuncName }} {{ if eq .Comment "" }}generated by sqlbrick, used to operate database table.{{ else }}{{ .Comment }}{{ end }}
func (b *{{ .BrickName }}Brick){{ .FuncName }}() error {
    stmt, err := b.db.Prepare(`{{ index .Segments 0 }}`)
    if err != nil {
        return err
    }
    _, err = stmt.Exec()
    return err
}