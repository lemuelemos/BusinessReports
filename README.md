# <img src="man/figures/hexsticker.png" alt="Logomarca do BusinessReport" width="120" style="vertical-align: middle; margin-right: 18px;"> BusinessReport

<!-- badges: start -->
[![R-CMD-check](https://github.com/lemuelemos/BusinessReport/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/lemuelemos/BusinessReport/actions/workflows/R-CMD-check.yaml)
[![pkgdown](https://github.com/lemuelemos/BusinessReport/actions/workflows/pkgdown.yaml/badge.svg)](https://github.com/lemuelemos/BusinessReport/actions/workflows/pkgdown.yaml)
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![Licença: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
<!-- badges: end -->

`BusinessReport` é um pacote R que fornece modelos profissionais **Quarto/Typst**
para relatórios corporativos e analíticos. Com uma chamada de função, você obtém
um projeto Quarto completo com:

- Capa e contracapa opcionais
- Três estilos distintos de sumário
- Fontes serifadas e sem serifa curadas para relatórios
- Layout profissional A4 com hierarquia tipográfica consistente
- Cor de destaque única aplicada a todo o modelo

## Instalação

```r
pak::pak("lemuelemos/BusinessReport")
```

## Uso rápido

```r
library(BusinessReport)

create_business_report(
  path = "my-report-2025",
  title = "Relatório Anual: 2025",
  subtitle = "Análise de Adequação de Capital",
  author = "Gerência de Modelagem e Monitoramento",
  institution = "FGCoop",
  font = "georgia",
  primary_color = "#0d3d6e",
  toc_style = 2L,
  cover = TRUE,
  back_cover = TRUE
)

quarto::quarto_render("my-report-2025/report.qmd")
```

## Fontes disponíveis

```r
list_fonts()
```

| id | Fonte | Estilo | Observação |
|----|-------|--------|------------|
| `georgia` | Georgia | Serifada | Fonte de sistema |
| `palatino` | Palatino Linotype | Serifada | Fonte de sistema |
| `garamond` | EB Garamond | Serifada | Requer instalação |
| `baskerville` | Libre Baskerville | Serifada | Requer instalação |
| `merriweather` | Merriweather | Serifada | Requer instalação |
| `crimson` | Crimson Pro | Serifada | Requer instalação |
| `spectral` | Spectral | Serifada | Requer instalação |
| `lato` | Lato | Sem serifa | Requer instalação |
| `source-sans` | Source Sans 3 | Sem serifa | Requer instalação |
| `fira-sans` | Fira Sans | Sem serifa | Requer instalação |
| `ibm-plex` | IBM Plex Sans | Sem serifa | Requer instalação |
| `montserrat` | Montserrat | Sem serifa | Requer instalação |
| `roboto` | Roboto | Sem serifa | Requer instalação |
| `inter` | Inter | Sem serifa | Requer instalação |

## Estilos de sumário

```r
list_toc_styles()
```

| ID | Nome | Descrição |
|----|------|-----------|
| 1 | Clássico | Dot leaders e capítulos em destaque |
| 2 | Moderno | Barra lateral colorida e badge de página |
| 3 | Minimalista | Hierarquia limpa com poucos ornamentos |

## Personalização

```r
set_font("my-report-2025", font = "merriweather")
set_toc_style("my-report-2025", style = 3L)
set_primary_color("my-report-2025", color = "#8b1a1a")
toggle_cover("my-report-2025", cover = FALSE)
toggle_back_cover("my-report-2025", back_cover = FALSE)
```

## Estrutura gerada

```text
meu-relatorio/
├── report.qmd
├── assets/
│   └── logo.svg
└── _extensions/
    └── business-report/
        ├── _business-report-config.typ
        ├── _extension.yml
        ├── typst-template.typ
        ├── typst-show.typ
        ├── cover.typ
        ├── back-cover.typ
        └── toc/
            ├── toc-classic.typ
            ├── toc-modern.typ
            └── toc-minimal.typ
```

## Pré-requisitos

- R >= 4.2
- Quarto >= 1.4 com suporte a Typst
- Fontes de código aberto instaladas no sistema quando necessário

## Documentação

O site da documentação é gerado com `pkgdown` e publicado em:
<https://lemuelemos.github.io/BusinessReport/>

## Licença

MIT © BusinessReport authors
