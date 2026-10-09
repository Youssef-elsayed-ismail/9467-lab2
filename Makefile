DIR ?= watch_dir
MALICIOUS_DIR ?= quarantine
INTERVAL ?= 5

.PHONY: setup daemon restore clean

setup:
	@mkdir -p $(DIR) $(MALICIOUS_DIR)

daemon: setup
	./antivirusd.sh $(DIR) $(MALICIOUS_DIR) $(INTERVAL)

restore: setup
	./restore.sh $(DIR) $(MALICIOUS_DIR)

clean:
	rm -rf directory-info.last directory-info.new .whitelist
