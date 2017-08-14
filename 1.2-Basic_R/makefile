all: Basic_R.html Basic_R.R Basic_R.pdf

Basic_R.html: index.Rmd 
	Rscript -e "rmarkdown::render('index.Rmd', output_format = 'all', output_file='Basic_R.html')"

Basic_R.pdf: Basic_R.html index.Rmd 
	electron-pdf Basic_R.html Basic_R.pdf --landscape

Basic_R.R: index.Rmd
	Rscript -e "knitr::purl('index.Rmd', output='Basic_R.R')"

clean: 
	rm Basic_R.html Basic_R.R Basic_R.pdf
