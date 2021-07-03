.PHONY: html clean

# Output directory, can be overridden by environment
OUTPUT_DIR ?= output

html: clean
	mkdir -p $(OUTPUT_DIR)
	cp -r media $(OUTPUT_DIR)/
	cp -r styles $(OUTPUT_DIR)/
	cp -r fonts $(OUTPUT_DIR)/
	ls -1 content | grep .md | sed 's/.md//' | xargs -n 1 -I NAME \
	    pandoc \
	        --standalone \
	        --to=html \
	        --template=template.html \
	        --metadata-file=metadata.yml \
	        --output=$(OUTPUT_DIR)/NAME.html \
	        content/NAME.md

clean:
	rm -rf $(OUTPUT_DIR)/fonts
	rm -rf $(OUTPUT_DIR)/media
	rm -rf $(OUTPUT_DIR)/styles
	rm -rf $(OUTPUT_DIR)/*.html
