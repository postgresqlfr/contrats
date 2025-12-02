
##
## P A N D O C
##
P=pandoc

# if pandoc is not installed, 
# we'll use docker image pandoc/extra:latest-ubuntu 
# instead

ifeq (, $(shell which $(P)))
	#DOCKER?=latest-ubuntu
  # https://github.com/dinolupo/pandoc-md/issues/1#issuecomment-3586755187
  DOCKER?=3.7-ubuntu
endif

ifneq ($(DOCKER),)
	P:=docker run --rm -it --privileged --volume $(CURDIR):/pandoc pandoc/extra:$(DOCKER)
endif

PANDOC_ARGS=--standalone
P+= $(PANDOC_ARGS)


##
##  S O U R C E S
##

# Ignore documentation
EXCLUDES:= -and -not -name 'QUICKSTART.md' -and -not -name 'README.md'
# $(SRCS) is the list of all source files
SRCS=$(shell find . -type f -name '*.md' $(EXCLUDES) )

##
## O B J E C T S
##

PDF_OBJS=$(SRCS:.md=.pdf)
ODT_OBJS=$(SRCS:.md=.odt)
DOCX_OBJS=$(SRCS:.md=.docx)

##
## T A R G E T S
##

pdf: $(PDF_OBJS)
odt: $(ODT_OBJS)
docx: $(DOCX_OBJS)

all: pdf docx

clean:
	rm -fr $(PDF_OBJS)
	rm -fr $(ODT_OBJS)
	rm -fr $(DOCX_OBJS)

##
## B U I L D
## R U L E S
##

%.pdf: %.md
	$P --from markdown --template eisvogel $^ -o $@

%.odt: %.md
	$P $^ -o $@

%.docx: %.md
	$P $^ -o $@
