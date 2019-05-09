all: index.rmd
	@echo "rendering all..."
	Rscript -e "bookdown::render_book('$<', c('bookdown::pdf_book', 'bookdown::gitbook', 'bookdown::html_document2'))"
	@echo "done!"

pdf: index.rmd
	@echo "rendering pdf book..."
	Rscript -e "bookdown::render_book('$<', 'bookdown::pdf_book')"
	@echo "done!"

html_book: index.rmd
	@echo "rendering html book..."
	Rscript -e "bookdown::render_book('$<', 'bookdown::gitbook')"
	@echo "done!"

html_document: index.rmd
	@echo "rendering html document..."
	Rscript -e "bookdown::render_book('$<', 'bookdown::html_document2')"
	@echo "done!"
