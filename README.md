# BusinessReport <img src="man/figures/logo.png" align="right" height="139" alt="" />

<!-- badges: start -->
[![R-CMD-check](https://github.com/lemuelemos/BusinessReport/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/lemuelemos/BusinessReport/actions/workflows/R-CMD-check.yaml)
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
<!-- badges: end -->

`BusinessReport` é um pacote R que fornece templates profissionais **Quarto/Typst**
para relatórios corporativos e analíticos. Com uma chamada de função, você obtém
um projeto Quarto completo com:

- Capa e contracapa opcionais
- Três estilos distintos de sumário (Clássico, Moderno, Minimalista)
- Uma coleção de 14 fontes de publicações financeiras e projetos tipográficos renomados
- Layout profissional A4 com cabeçalho, rodapé, e hierarquia tipográfica completa
- Cor de destaque única que propaga para todos os elementos visuais

## Instalação

```r
pak::pak("lemuelemos/BusinessReport")
```

## Uso rápido

```r
library(BusinessReport)

# Criar um projeto novo
create_business_report(
  path        = "my-report-2025",
  title       = "Relatório Anual: 2025",
  subtitle    = "Análise de Adequação de Capital",
  author      = "Gerência de Modelagem e Monitoramento",
  institution = "FGCoop",
  font        = "ibm-plex",      # IBM Plex Sans
  primary_color = "#0d3d6e",
  toc_style   = 2,               # Sumário Moderno
  cover       = TRUE,
  back_cover  = TRUE
)

# Renderizar
quarto::quarto_render("my-report-2025/report.qmd")
```

## Fontes disponíveis

```r
list_fonts()
```

| id | Display Name | Estilo | Uso famoso |
|----|--------------|--------|-----------|
| `georgia` | Georgia | Serif | The Economist |
| `palatino` | Palatino Linotype | Serif | LaTeX padrão |
| `garamond` | EB Garamond | Serif | Penguin Books |
| `baskerville` | Libre Baskerville | Serif | Google Books |
| `merriweather` | Merriweather | Serif | Medium.com |
| `crimson` | Crimson Pro | Serif | Periódicos acadêmicos |
| `spectral` | Spectral | Serif | Google Fonts |
| `lato` | Lato | Sans | Relatórios da ONU |
| `source-sans` | Source Sans 3 | Sans | Adobe |
| `fira-sans` | Fira Sans | Sans | Mozilla |
| `ibm-plex` | IBM Plex Sans | Sans | IBM annual reports |
| `montserrat` | Montserrat | Sans | Pitch decks modernos |
| `roboto` | Roboto | Sans | Google |
| `inter` | Inter | Sans | Linear, Vercel |

## Estilos de sumário

```r
list_toc_styles()
```

| ID | Nome | Características |
|----|------|----------------|
| 1 | Clássico | Dot leaders, capítulos em negrito e cor primária |
| 2 | Moderno | Barra lateral colorida, número em badge |
| 3 | Minimalista | Sem decoração, hierarquia por tipografia |

## Personalização pós-criação

```r
set_font("my-report-2025",          font  = "merriweather")
set_toc_style("my-report-2025",     style = 3)
set_primary_color("my-report-2025", color = "#8b1a1a")
toggle_cover("my-report-2025",      cover = FALSE)
toggle_back_cover("my-report-2025", back_cover = FALSE)
```

## Estrutura gerada

```
meu-relatorio/
├── report.qmd
├── assets/
│   └── logo.svg                     ← substitua pelo seu logo
└── _extensions/
    └── business-report/
        ├── _business-report-config.typ  ← gerado pelo R; editável
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

- R ≥ 4.2
- Quarto ≥ 1.4 com suporte a Typst
- Fontes OFL devem ser instaladas separadamente
  ([Google Fonts](https://fonts.google.com))

## Licença

MIT © BusinessReport authors
