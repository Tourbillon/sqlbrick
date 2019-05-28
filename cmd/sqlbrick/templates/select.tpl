// {{ .FuncName }} {{ if eq .Comment "" }}generated by sqlbrick, select data from database.{{ else }}{{ .Comment }}{{ end }}
{{- if gt .TotalArgs 0 }}
{{ if .IsTx -}}
func (b *{{ .BrickName }}BrickTx){{ .FuncName }}(dest interface{}, {{ .ArgName }} interface{}) error {
{{ else -}}
func (b *{{ .BrickName }}Brick){{ .FuncName }}(dest interface{}, {{ .ArgName }} interface{}) error {
{{- end -}}
    {{ if .IsTx -}}
    if err := b.checkTx(); err != nil {
        return err
    }

    stmt, err := b.tx.PrepareNamed(
        `{{ index .Segments 0 }}`)
    {{ else -}}
    stmt, err := b.db.PrepareNamed(
            `{{ index .Segments 0 }}`)
    {{ end -}}
    if err != nil {
        {{- if .IsTx -}}
        if rbe := b.tx.Rollback(); rbe != nil {
            return rbe
        }
        {{ end }}
        return err
    }

    {{ if eq .TotalArgs 1 -}}
    // create map arguments for sqlx
    args := map[string]interface{}{
    {{- range $k, $v := .Args }}
    {{ $mk := ToSnake $v }}"{{ $mk }}": {{ $v }},
    {{- end }}
    }
    {{ end }}

    {{ if eq .Mapper 1 }}
    row := stmt.QueryRowx(args)
    if row.Err() != nil {
        return row.Err()
    }

    return row.Scan(dest)
    {{- else if eq .Mapper 2 }}
    row := stmt.QueryRowx(args)
    if row.Err() != nil {
    	return row.Err()
    }

    return row.StructScan(dest)
    {{- else }}
    rows, err := stmt.Queryx(args)
    if err != nil {
        return err
    }

    return sqlx.StructScan(rows, dest)
    {{- end }}
}
{{ else }}
{{ if .IsTx -}}
func (b *{{ .BrickName }}BrickTx){{ .FuncName }}(dest interface{}) error {
{{ else -}}
func (b *{{ .BrickName }}Brick){{ .FuncName }}(dest interface{}) error {
{{- end -}}
    {{ if .IsTx -}}
    if err := b.checkTx(); err != nil {
        return err
    }

    err := b.tx.Select(dest, `{{ index .Segments 0 }}`)
    if err != nil {
        if rbe := b.tx.Rollback(); rbe != nil {
            return rbe
        }
        return err
    }
    {{ else -}}
    {{ if or (eq .Mapper 1) (eq .Mapper 2) }}
    stmt, err := b.db.Prepare(`{{ index .Segments 0 }}`)
    if err != nil {
        return err
    }
    return stmt.QueryRow().Scan(dest)
    {{- else }}
    return b.db.Select(dest, `{{ index .Segments 0 }}`)
    {{- end }}
    {{- end }}
}
{{ end }}