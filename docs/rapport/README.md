# Project-specific R Markdown Notes

If bookdown is not already installed run in your R console
```r
install.packages("bookdown", dependencies=TRUE)
```

Make sure you have MySQL or MariaDB package,
otherwise install them using your distro package manager.

Install R libraries for connecting to the database:
```r
install.packages(c("DBI", "RMySQL"), dependencies=TRUE)
```

**USE THE MAKEFILE**
