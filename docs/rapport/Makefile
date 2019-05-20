all: main.rmd
	@echo "rendering all..."
	Rscript -e "bookdown::render_book('$<', c('bookdown::pdf_book', 'bookdown::gitbook', 'bookdown::html_document2'))"
	@echo "done!"

pdf: main.rmd
	@echo "rendering pdf book..."
	Rscript -e "bookdown::render_book('$<', 'bookdown::pdf_book', output_file='../book.pdf')"
	@echo "done!"

html_book: main.rmd
	@echo "rendering html book..."
	Rscript -e "bookdown::render_book('$<', 'bookdown::gitbook')"
	@echo "done!"

html_document: main.rmd
	@echo "rendering html document..."
	Rscript -e "bookdown::render_book('$<', 'bookdown::html_document2')"
	@echo "done!"
