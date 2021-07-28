.PHONY: all static pandoc finish clean

# Output directory, can be overridden by environment
OUTPUT_DIR ?= output

all: clean finish

$(OUTPUT_DIR):
	mkdir -p $(OUTPUT_DIR)

static: $(OUTPUT_DIR)
	cp -r media $(OUTPUT_DIR)/
	cp -r styles $(OUTPUT_DIR)/
	cp -r fonts $(OUTPUT_DIR)/

pandoc: $(OUTPUT_DIR)
	ls -1 content | grep .md | sed 's/.md//' | xargs -n 1 -I NAME \
		pandoc \
			--standalone \
			--to=html \
			--template=template.html \
			--metadata-file=metadata.yml \
			--output=$(OUTPUT_DIR)/NAME.html \
			content/NAME.md

finish: static pandoc
	ls -1 content | grep .md | sed 's/.md//' | xargs -n 1 -I NAME \
		sed -i 's/<a href="NAME.html">\([^<]*\)<\/a>/<strong class="active">\1<\/strong>/' \
			$(OUTPUT_DIR)/NAME.html

clean:
	rm -rf $(OUTPUT_DIR)/fonts
	rm -rf $(OUTPUT_DIR)/media
	rm -rf $(OUTPUT_DIR)/styles
	rm -rf $(OUTPUT_DIR)/*.html
