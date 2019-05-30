// {{ .FuncName }} {{ if eq .Comment "" }}generated by sqlbrick, insert data into database.
{{- else -}}
{{ .Comment }}
{{- end }}
{{ if .IsTx -}}
func (b *{{ .BrickName }}BrickTx){{ .FuncName }}({{- if .WithContext -}}ctx context.Context, {{ end }}args *entity.{{ .BrickName }}) (sql.Result, error) {
{{ else -}}
func (b *{{ .BrickName }}Brick){{ .FuncName }}({{- if .WithContext -}}ctx context.Context, {{ end }}args *entity.{{ .BrickName }}) (sql.Result, error) {
{{- end -}}
    {{ if .IsTx -}}
    if err := b.checkTx(); err != nil {
        return nil, err
    }

    stmt, err := b.tx.PrepareNamed(
        `{{ index .Segments 0 }}`)
    {{- else -}}
        stmt, err := b.db.PrepareNamed(
            `{{ index .Segments 0 }}`)
    {{- end }}
    if err != nil {
        {{- if .IsTx -}}
        if rbe := b.tx.Rollback(); rbe != nil {
            return nil, rbe
        }
        {{ end }}
        return nil, err
    }

    result, err := stmt.{{- if .WithContext -}}ExecContext(ctx, {{ else }}Exec({{ end }}args)
    if err != nil {
        {{- if .IsTx -}}
        if rbe := b.tx.Rollback(); rbe != nil {
            return nil, rbe
        }
        {{ end }}
        return nil, err
    }

    return result, nil
}