CONTENT_DIR ?= content
OUTPUT_DIR ?= output
STATICS := media styles fonts

CONTENT_FILES := $(wildcard $(CONTENT_DIR)/*.md)
CONTENT_OUTPUT := $(patsubst $(CONTENT_DIR)/%.md,$(OUTPUT_DIR)/%.html, $(CONTENT_FILES))
STATIC_OUTPUT := $(patsubst %,$(OUTPUT_DIR)/%, $(STATICS))

.PHONY: all
all: clean $(CONTENT_OUTPUT) $(STATIC_OUTPUT)

$(OUTPUT_DIR):
	mkdir -p $(OUTPUT_DIR)

$(OUTPUT_DIR)/%-pandoc.html: $(CONTENT_DIR)/%.md $(OUTPUT_DIR)
	pandoc \
		--standalone \
		--to=html \
		--template=template.html \
		--metadata-file=metadata.yml \
		--wrap=none \
		--output=$@ \
		$<

$(OUTPUT_DIR)/%.html: $(OUTPUT_DIR)/%-pandoc.html $(OUTPUT_DIR)
	sed 's/<a href="$*.html">\([^<]*\)<\/a>/<strong class="active">\1<\/strong>/' \
		$< > $@

$(OUTPUT_DIR)/%: % $(OUTPUT_DIR)
	cp -r $< $@

.PHONY: clean
clean:
	rm -rf $(OUTPUT_DIR)
