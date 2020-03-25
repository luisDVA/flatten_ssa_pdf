
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Función `flatten_ssa_pdf()`

<!-- badges: start -->

<!-- badges: end -->

Función para cargar los datos de casos positivos de COVID19 desde los
comunicados técnicos diarios de la Secretaría de Salud (Gobierno de
México).

Utiliza `pdftools` para leer todo el contenido de los reportes y
expresiones regulares para alinear las líneas de texto previo a leerlas
como archivos de anchos fijos.

El único argument que toma es la ruta local o web del archivo PDF.
Genera un ‘tibble’ con los datos tabulares de todas las páginas del
archivo.

Probada con las versiones de los PDF archivadas en el repostorio de
Katia Guzmán Martínez (<https://github.com/guzmart/covid19_mex>) de
marzo 19 a marzo 22 de 2020.

``` r
source("flatten_ssa_pdf.R")
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
# url del comunicado técnico
url_pdf_ssa_2403 <- "https://www.gob.mx/cms/uploads/attachment/file/543205/Tabla_casos_positivos_COVID-19_resultado_InDRE_2020.03.24.pdf"
# importar datos
flatten_ssa_pdf(url_pdf_ssa_2403)
#> # A tibble: 405 x 8
#>    `Nº Caso` Estado Sexo   Edad `Fecha de Inici… `Identificación… Procedencia
#>        <dbl> <chr>  <chr> <dbl> <chr>            <chr>            <chr>      
#>  1         1 CIUDA… M        35 22/02/2020       confirmado       Italia     
#>  2         2 SINAL… M        41 22/02/2020       confirmado       Italia     
#>  3         3 CIUDA… M        59 23/02/2020       confirmado       Italia     
#>  4         4 COAHU… F        20 27/02/2020       confirmado       Italia     
#>  5         5 CHIAP… F        18 25/02/2020       confirmado       Italia     
#>  6         6 MÉXICO M        71 21/02/2020       confirmado       Italia     
#>  7         7 CIUDA… M        46 29/02/2020       confirmado       Estados Un…
#>  8         8 QUERE… M        43 09/03/2020       confirmado       España     
#>  9         9 CIUDA… M        41 07/03/2020       confirmado       Estados Un…
#> 10        10 CIUDA… F        30 07/03/2020       confirmado       España     
#> # … with 395 more rows, and 1 more variable: `Fecha de llegada a México` <chr>
```
