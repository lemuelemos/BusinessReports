# BusinessReport (versão de desenvolvimento)

# BusinessReport 0.1.0

## Novidades

* `create_business_report()` cria um projeto completo em Quarto/Typst com uma
  única chamada de função. As opções controlam título, autoria, instituição,
  data, fonte, cor de destaque, estilo do sumário e presença de capa e
  contracapa.

* `list_fonts()` apresenta as 14 fontes disponíveis, cobrindo famílias
  serifadas e sem serifa inspiradas em publicações financeiras e projetos
  tipográficos de código aberto.

* `set_font()`, `set_toc_style()`, `set_primary_color()`, `toggle_cover()` e
  `toggle_back_cover()` permitem ajustar um projeto existente sem recriá-lo.

* Três estilos de sumário estão disponíveis: **Clássico**, **Moderno** e
  **Minimalista**.

* A extensão Quarto (`business-report-typst`) usa um modelo Typst que lê a
  configuração a partir de `_business-report-config.typ`, facilitando edição
  posterior e versionamento.
